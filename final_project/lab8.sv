module lab8 (input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
             // VGA Interface
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK,     //SDRAM Clock
             // SRAM On the FPGA
             output logic SRAM_CE_N, SRAM_UB_N, SRAM_LB_N, SRAM_OE_N, SRAM_WE_N, // Chip enable, Upper Byte, Lower Byte, Output enable, WE?
             output logic [19:0] SRAM_ADDR, // Address, it's 20 bits but we only use the first
             inout  wire  [15:0] SRAM_DQ
             );

    logic Reset_h, Clk;
    logic [7:0] keycode;

    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]); // The push buttons are active low
    end

    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    logic [9:0] DrawX, DrawY, SaveX, SaveY;

    logic drawBlock;
    logic [3:0] colorIndex_save, colorIndex_draw, colorIndex_fifo;

    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst (.Clk(Clk),
                             .Reset(Reset_h),
                             // signals connected to NIOS II
                             .from_sw_address(hpi_addr),
                             .from_sw_data_in(hpi_data_in),
                             .from_sw_data_out(hpi_data_out),
                             .from_sw_r(hpi_r),
                             .from_sw_w(hpi_w),
                             .from_sw_cs(hpi_cs),
                             .from_sw_reset(hpi_reset),
                             // signals connected to EZ-OTG chip
                             .OTG_DATA(OTG_DATA),
                             .OTG_ADDR(OTG_ADDR),
                             .OTG_RD_N(OTG_RD_N),
                             .OTG_WR_N(OTG_WR_N),
                             .OTG_CS_N(OTG_CS_N),
                             .OTG_RST_N(OTG_RST_N));

     lab7_soc nios_system (.clk_clk(Clk),
                           .reset_reset_n(1'b1), // Never reset NIOS
                           .sdram_wire_addr(DRAM_ADDR),
                           .sdram_wire_ba(DRAM_BA),
                           .sdram_wire_cas_n(DRAM_CAS_N),
                           .sdram_wire_cke(DRAM_CKE),
                           .sdram_wire_cs_n(DRAM_CS_N),
                           .sdram_wire_dq(DRAM_DQ),
                           .sdram_wire_dqm(DRAM_DQM),
                           .sdram_wire_ras_n(DRAM_RAS_N),
                           .sdram_wire_we_n(DRAM_WE_N),
                           .sdram_clk_clk(DRAM_CLK),
                           .keycode_export(keycode),
                           .otg_hpi_address_export(hpi_addr),
                           .otg_hpi_data_in_port(hpi_data_in),
                           .otg_hpi_data_out_port(hpi_data_out),
                           .otg_hpi_cs_export(hpi_cs),
                           .otg_hpi_r_export(hpi_r),
                           .otg_hpi_w_export(hpi_w),
                           .otg_hpi_reset_export(hpi_reset));

    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance (.inclk0(Clk), .c0(VGA_CLK));

    blocks blockInstance (.Clk(Clk), .Reset(Reset_h), .DrawX(DrawX), .DrawY(DrawY), .colorIndex(colorIndex_save), .drawBlock(drawBlock)); // interface with frame buffer

    frameBuffer fbinstance(.SRAM_OE_N, .colorIndex_save(colorIndex_save), .SaveX(), .SaveY(), .DrawX(), .DrawY(),
									.data_out(colorIndex_fifo), .fifo_address(), .fifo_we(), .SRAM_ADDR, .SRAM_DQ, .flip_page());


    fifoRAM blockMemory2 (.data_In(colorIndex_fifo), .write_address(), .read_address(), .we(), .Clk(Clk), .data_Out(colorIndex_draw)); // interface with frame buffer and color mapper
    color_mapper color_instance (.colorIndex(colorIndex_draw), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B)); // interface with FIFO and VGA

    VGA_controller vga_controller_instance (.Clk(Clk), .Reset(Reset_h), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_CLK(VGA_CLK),
                                            .VGA_BLANK_N(VGA_BLANK_N), .VGA_SYNC_N(VGA_SYNC_N), .DrawX(DrawX), .DrawY(DrawY));

    // Display keycode on hex display
    HexDriver hex_inst_0 (colorIndex_draw[3:0], HEX0);
    HexDriver hex_inst_1 (colorIndex_save[3:0], HEX1);
    HexDriver hex_inst_2 (VGA_B[3:0], HEX2);
    HexDriver hex_inst_3 (VGA_B[7:4], HEX3);
    HexDriver hex_inst_4 (VGA_G[3:0], HEX4);
    HexDriver hex_inst_5 (VGA_G[7:4], HEX5);
    HexDriver hex_inst_6 (VGA_R[3:0], HEX6);
    HexDriver hex_inst_7 (VGA_R[7:4], HEX7);
endmodule
