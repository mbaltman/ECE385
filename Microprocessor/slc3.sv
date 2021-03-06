module slc3(
	input  logic [15:0] S,
	input  logic Clk, Reset, Run, Continue,
	output logic [11:0] LED,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
	output logic CE, UB, LB, OE, WE,
	output logic [19:0] ADDR,
	output logic [15:0] IR, PC, MAR, MDR, SR1OUT,
	output logic GatePC, LD_MAR, LD_PC, MIO_EN, GateMDR, LD_IR,
	output logic [1:0] PCMUX,
	inout  wire  [15:0] Data, DataPath,
	output integer stateNumber,
	output logic [2:0] SR1_SRC,
	output logic [15:0] registers [7:0]
	);

	// declaration of push button active high signals
	logic Reset_ah, Continue_ah, Run_ah, WE_S;

	// synchronize these signals
	sync R_sync (Clk, ~Reset, Reset_ah);
	sync C_sync (Clk, ~Continue, Continue_ah);
	sync Ru_sync (Clk, ~Run, Run_ah);

	assign MIO_EN = ~OE;

	// internal connections
	logic BEN;
	logic LD_MDR, LD_BEN, LD_CC, LD_REG, LD_LED;
	logic [1:0] ADDR2MUX, ALUK;
	logic GateALU, GateMARMUX;
	logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX;

	logic [15:0] MDR_In;
	logic [15:0] MARMUX, ALUOUT;
	logic [15:0] Data_from_SRAM, Data_to_SRAM;
	logic [15:0] SR2OUT;
	logic [15:0] ADDR2MUXOUT, ADDR1MUXOUT, SR2MUXOUT;

	// signals being displayed on hex display
	logic [3:0][3:0] hex_4;

	HexDriver hex_driver3 (hex_4[0][3:0], HEX0);
	HexDriver hex_driver2 (hex_4[1][3:0], HEX1);
	HexDriver hex_driver1 (hex_4[2][3:0], HEX2);
	HexDriver hex_driver0 (hex_4[3][3:0], HEX3);

	// hex display for PC
	HexDriver hex_driver7 (PC[15:12], HEX7);
	HexDriver hex_driver6 (PC[11:8], HEX6);
	HexDriver hex_driver5 (PC[7:4], HEX5);
	HexDriver hex_driver4 (PC[3:0], HEX4);

	// MEM2IO will determine what gets put onto Data_CPU (which serves as a potential input into MDR)
	assign ADDR = { 4'b00, MAR }; // Note, our external SRAM chip is 1Mx16, but address space is only 64Kx16

	// the datapath
	datapath d0(
	.MDR, .PC, .MARMUX, .ALUOUT,
	.s1(GatePC), .s2(GateMDR), .s3(GateALU), .s4(GateMARMUX),
	.data(DataPath)
	);

	// all key modules
	MDR_module mdr(.data(DataPath), .mdrin(MDR_In), .mioen(MIO_EN), .mdrout(MDR), .ld(LD_MDR), .clk(Clk), .reset(Reset_ah));

	PC_module pc(.pcout(PC), .data(DataPath), .address(MARMUX), .s(PCMUX), .ld(LD_PC), .clk(Clk), .reset(Reset_ah));

	IR_module ir(.data(DataPath), .iroutput(IR), .ld(LD_IR), .clk(Clk), .reset(Reset_ah));

	MAR_module mar(.data(DataPath), .marout(MAR), .ld(LD_MAR), .clk(Clk), .reset(Reset_ah));

	RegFile_module regfile(
	.data(DataPath), .SR1_11(IR[11:9]), . SR1_8(IR[8:6]), .SR2_2(IR[2:0]),
	.DRMUX, .SR1MUX, .LD_REG, .clk(Clk), .reset(Reset_ah), .SR1(SR1OUT), .SR2(SR2OUT),
	.SR1_SRC,
	.registers
	);

	nzp_module nzpmod(.data(DataPath), .LD_CC, .LD_BEN, .currNZP(IR[11:9]), .clk(Clk), .reset(Reset_ah), .BEN);

	addr2mux_module muxaddr2(.d1(16'(signed'(IR[5:0]))), .d2(16'(signed'(IR[8:0]))), .d3(16'(signed'(IR[10:0]))), .s(ADDR2MUX), .o(ADDR2MUXOUT));

	// muxes and adders
	mux2 muxaddr1(.d0(PC), .d1(SR1OUT), .s(ADDR1MUX), .y(ADDR1MUXOUT));

	mux2 muxsr2(.d0(SR2OUT), .d1(16'(signed'(IR[4:0]))), .s(SR2MUX), .y(SR2MUXOUT));

	ripple_adder addradder(.A(ADDR1MUXOUT), .B(ADDR2MUXOUT), .Sum(MARMUX), .CO());

	alu_module alu(.A(SR1OUT), .B(SR2MUXOUT), .s(ALUK), .out(ALUOUT));

	LED_module ledmod (.LD_LED, .clk(Clk), .IR11(IR[11:0]), .LED);

	// SRAM and I/O controller
	Mem2IO memory_subsystem(
	.*, .Reset(Reset_ah), .ADDR(ADDR), .Switches(S),
	.HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]),
	.Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
	.Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
	);


	// the tri-state buffer serves as the interface between Mem2IO and SRAM
	tristate #(.N(16)) tr0(
	.Clk(Clk), .tristate_output_enable(~WE), .Data_write(Data_to_SRAM), .Data_read(Data_from_SRAM), .Data(Data)
	);

	// state machine and control signals
	ISDU state_controller(
	.*, .Reset(Reset_ah), .Run(Run_ah), .Continue(Continue_ah),
	.Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
	.Mem_CE(CE), .Mem_UB(UB), .Mem_LB(LB), .Mem_OE(OE), .Mem_WE(WE), .stateNumber
	);
endmodule
