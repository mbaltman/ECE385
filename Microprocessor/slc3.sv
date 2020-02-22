module slc3(
	input logic [15:0] S,
	input logic Clk, Reset, Run, Continue,
	output logic [11:0] LED,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
	output logic CE, UB, LB, OE, WE,
	output logic [19:0] ADDR,
	output logic [15:0] IR,PC,MAR,
	output logic GatePC, LD_MAR, LD_PC, MIO_EN, Gate_MDR, LD_IR,
	output logic [1:0] PCMUX,
	inout wire [15:0] Data // tristate buffers need to be of type wire
	);

	// Declaration of push button active high signals
	logic Reset_ah, Continue_ah, Run_ah;

	assign Reset_ah = ~Reset;
	assign Continue_ah = ~Continue;
	assign Run_ah = ~Run;

	// Internal connections
	//logic LD_IR;
	logic BEN;
	logic  LD_MDR, LD_BEN, LD_CC, LD_REG, LD_LED;
	logic [1:0]  ADDR2MUX, ALUK;
	logic GateALU, GateMARMUX;
	logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX;


	logic [15:0] MDR_In;
	logic [15:0] MDR, MARMUX, ADDADD, ALUOUT;
	logic [15:0] Data_from_SRAM, Data_to_SRAM;

	// Signals being displayed on hex display
	logic [3:0][3:0] hex_4;


	// For week 1, hexdrivers will display IR. Comment out these in week 2.
	HexDriver hex_driver3 (IR[15:12], HEX3);
	HexDriver hex_driver2 (IR[11:8], HEX2);
	HexDriver hex_driver1 (IR[7:4], HEX1);
	HexDriver hex_driver0 (IR[3:0], HEX0);

	// For week 2, hexdrivers will be mounted to Mem2IO
	// HexDriver hex_driver3 (hex_4[3][3:0], HEX3);
	// HexDriver hex_driver2 (hex_4[2][3:0], HEX2);
	// HexDriver hex_driver1 (hex_4[1][3:0], HEX1);
	// HexDriver hex_driver0 (hex_4[0][3:0], HEX0);

	// The other hex display will show PC for both weeks.
	HexDriver hex_driver7 (PC[15:12], HEX7);
	HexDriver hex_driver6 (PC[11:8], HEX6);
	HexDriver hex_driver5 (PC[7:4], HEX5);
	HexDriver hex_driver4 (PC[3:0], HEX4);

	// Connect MAR to ADDR, which is also connected as an input into MEM2IO.
	// MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
	// input into MDR)
	assign ADDR = { 4'b00, MAR }; // Note, our external SRAM chip is 1Mx16, but address space is only 64Kx16
	assign MIO_EN = ~OE;

	// You need to make your own datapath module and connect everything to the datapath
	// Be careful about whether Reset is active high or low


	datapath d0 (	.MDR(MDR), .PC(PC), .ADDADD(ADDADD), .ALUOUT(ALUOUT),
					.s1(GatePC), .s2(GateMDR), .s3(GateALU), .s4(GateMARMUX), .data(Data));

	MDR_module mdr(.data(Data), .mdrin(MDR_In), .mioen(MIO_EN), .mdrout(MDR), .ld(LD_MDR), .clk(Clk), .reset(Reset_ah));

	PC_module pc(.pcout(PC), .data(Data), .address(ADDADD), .s(PC_MUX), .clk(Clk), .reset(Reset_ah));

	IR_module ir(.data(Data), .iroutput(IR), .ld(LD_IR), .clk(Clk), .reset(Reset_ah));

	MAR_module mar(.data(Data), .marout(MAR), .ld(LD_MAR), .clk(Clk), .reset(Reset_ah));

	// Our SRAM and I/O controller
	Mem2IO memory_subsystem(
		.*, .Reset(Reset_ah), .ADDR(ADDR), .Switches(S),
		.HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]),
		.Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
		.Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
	);

	// The tri-state buffer serves as the interface between Mem2IO and SRAM
	tristate #(.N(16)) tr0(
		.Clk(Clk), .tristate_output_enable(~WE), .Data_write(Data_to_SRAM), .Data_read(Data_from_SRAM), .Data(Data)
	);

	// State machine and control signals
	ISDU state_controller(
		.*, .Reset(Reset_ah), .Run(Run_ah), .Continue(Continue_ah),
		.Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
		.Mem_CE(CE), .Mem_UB(UB), .Mem_LB(LB), .Mem_OE(OE), .Mem_WE(WE)
	);

endmodule
