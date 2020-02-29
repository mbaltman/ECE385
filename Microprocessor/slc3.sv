module slc3(
	input  logic [15:0] S,
	input  logic Clk, Reset, Run, Continue,
	output logic [11:0] LED,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
	output logic CE, UB, LB, OE, WE,
	output logic [19:0] ADDR,
	output logic [15:0] IR, PC, MAR,
	output logic GatePC, LD_MAR, LD_PC, MIO_EN, Gate_MDR, LD_IR,
	output logic [1:0] PCMUX,
	inout  wire  [15:0] Data // tristate buffers need to be of type wire  //ask david if this is the datapath
	);

	// Declaration of push button active high signals
	logic Reset_ah, Continue_ah, Run_ah, WE_S;

	//synchronize these signals
	sync R_sync (Clk, ~Reset,Reset_ah);
	sync C_sync (Clk, ~Continue,Continue_ah);
	sync Ru_sync (Clk, ~Run,Run_ah);
	sync Oe_sync (Clk, ~OE,MIO_EN);
	sync We_sync (Clk, ~WE,WE_S);

	// Internal connections
	logic BEN;
	logic LD_MDR, LD_BEN, LD_CC, LD_REG, LD_LED;
	logic [1:0]  ADDR2MUX, ALUK;
	logic GateALU, GateMARMUX;
	logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX;

	logic [15:0] MDR_In;
	logic [15:0] MDR, MARMUX, ALUOUT;
	logic [15:0] Data_from_SRAM, Data_to_SRAM;
	logic [15:0] SR1OUT, SR2OUT;
	logic [15:0] ADDR2MUXOUT, ADDR1MUXOUT, SR2MUXOUT;

	// Signals being displayed on hex display
	logic [3:0][3:0] hex_4;

	// For week 2, hexdrivers will be mounted to Mem2IO
	HexDriver hex_driver3 (hex_4[3][3:0], HEX3);
	HexDriver hex_driver2 (hex_4[2][3:0], HEX2);
	HexDriver hex_driver1 (hex_4[1][3:0], HEX1);
	HexDriver hex_driver0 (hex_4[0][3:0], HEX0);

	// The other hex display will show PC for both weeks.
	HexDriver hex_driver7 (PC[15:12], HEX7);
	HexDriver hex_driver6 (PC[11:8], HEX6);
	HexDriver hex_driver5 (PC[7:4], HEX5);
	HexDriver hex_driver4 (PC[3:0], HEX4);

	// Connect MAR to ADDR, which is also connected as an input into MEM2IO.
	// MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
	// input into MDR)
	assign ADDR = { 4'b00, MAR }; // Note, our external SRAM chip is 1Mx16, but address space is only 64Kx16

	// You need to make your own datapath module and connect everything to the datapath
	// Be careful about whether Reset is active high or low

	datapath d0(
	.MDR, .PC, .MARMUX, .ALUOUT,
	.s1(GatePC), .s2(GateMDR), .s3(GateALU), .s4(GateMARMUX),
	.data(Data)
	);

	MDR_module mdr(.data(Data), .mdrin(MDR_In), .mioen(MIO_EN), .mdrout(MDR), .ld(LD_MDR), .clk(Clk), .reset(Reset_ah));

	PC_module pc(.pcout(PC), .data(Data), .address(MARMUX), .s(PCMUX), .ld(LD_PC), .clk(Clk), .reset(Reset_ah));

	IR_module ir(.data(Data), .iroutput(IR), .ld(LD_IR), .clk(Clk), .reset(Reset_ah));

	MAR_module mar(.data(Data), .marout(MAR), .ld(LD_MAR), .clk(Clk), .reset(Reset_ah));

	RegFile_module regfile(
	.data(Data), .SR1_11(IR[11:9]), . SR1_8(IR[8:6]), .SR2_2(IR[2:0]),
	.DRMUX, .SR1MUX, .LD_REG, .clk(Clk), .reset(Reset_ah), .SR1(SR1OUT), .SR2(SR2OUT)
	);

	nzp_module nzpmod(.data(Data), .LD_CC, .LD_BEN, .currNZP(IR[11:9]), .clk(Clk), . reset(Reset_ah), .BEN);

	addr2mux_module muxaddr2(.d1(16'(signed'(IR[5:0]))), .d2(16'(signed'(IR[8:0]))), .d3(16'(signed'(IR[10:0]))), .s(ADDR2MUX), .o(ADDR2MUXOUT));

	mux2 muxaddr1(.d0(SR1OUT), .d1(PC), .s(ADDR1MUX), .y(ADDR1MUXOUT));

	mux2 muxsr2(.d0(SR2OUT), .d1(16'(signed'(IR[4:0]))), .s(IR[5]), .y(SR2MUXOUT));

	ripple_adder addradder(.A(ADDR1MUXOUT), .B(ADDR2MUXOUT), .Sum(MARMUX));

	alu_module alu(.A(SR1OUT), .B(SR2MUXOUT), .s(ALUK), .out(ALUOUT));

	// Our SRAM and I/O controller
	Mem2IO memory_subsystem(
	.*, .Reset(Reset_ah), .ADDR(ADDR), .Switches(S),
	.HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]),
	.Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
	.Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
	);

	// The tri-state buffer serves as the interface between Mem2IO and SRAM
	tristate #(.N(16)) tr0(
	.Clk(Clk), .tristate_output_enable(WE_S), .Data_write(Data_to_SRAM), .Data_read(Data_from_SRAM), .Data(Data)
	);

	// State machine and control signals
	ISDU state_controller(
	.*, .Reset(Reset_ah), .Run(Run_ah), .Continue(Continue_ah),
	.Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
	.Mem_CE(CE), .Mem_UB(UB), .Mem_LB(LB), .Mem_OE(OE), .Mem_WE(WE)
	);
endmodule
