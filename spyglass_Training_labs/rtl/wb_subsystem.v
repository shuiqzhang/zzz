`timescale 1ns/10ps
/*******************************************************************
*** This module instantiates the Wishbone sub-system. Its port  ****
*** definitions match the connections to the AHB Bus            ****
*** The AHB2Wishbone bridge is connected as a master to the     ****
*** Wishbone connection matrix. USB and ACD are connected as    ****
*** slaves to the connection matrix                             ****
*** The subsystem uses a 125MHz clock generator instantiated    ****
*** as a behavioral model                                       ***
*******************************************************************/
module wb_subsystem(WBClk, WBReset, Hclk, Hresetn, Hwrite, Haddr, Hwdata, Hsel, Htrans, Hsize, Hburst, Hready, Hresp, Hrdata, phy_clk_i, phy_rst_o, DataOut_o, TxValid_o, TxReady_i, RxValid_i, RxActive_i, RxError_i, DataIn_i, XcvSelect_o, TermSel_o, SuspendM_o, LineState_i, OpMode_o, usb_vbus_i, VControl_Load_o, VControl_o, VStatus_i, sram_adr_o, sram_data_i, sram_data_o, sram_re_o, sram_we_o);

    //Wishbone clock and reset
    input WBClk, WBReset;

    //AHB Interface
    input Hclk; //Bus clock
    input Hresetn; //Active low sync reset
    input Hwrite; //Read/Write enable
    input [31:0] Hwdata; //Write data bus
    input [2:0] Hburst; //Burst type
    input [2:0] Hsize; //unused
    input [1:0] Htrans;
    input Hsel; //Slave select signal
    input [31:0] Haddr; //Address bus
    output [31:0] Hrdata; //Read data bus
    output [1:0] Hresp; // Response
    output Hready; // to indicate bridge is ready
    //USB UTMI Interface
    input           phy_clk_i;
    output          phy_rst_o;
    output  [7:0]   DataOut_o;
    output          TxValid_o;
    input           TxReady_i;
    input   [7:0]   DataIn_i;
    input           RxValid_i;
    input           RxActive_i;
    input           RxError_i;
    output          XcvSelect_o;
    output          TermSel_o;
    output          SuspendM_o;
    input   [1:0]   LineState_i;
    output  [1:0]   OpMode_o;
    input           usb_vbus_i;
    output          VControl_Load_o;
    output  [3:0]   VControl_o;
    input   [7:0]   VStatus_i;
    //USB Buffer Memory Interface
    output  [14:0]  sram_adr_o;
    input   [31:0]  sram_data_i;
    output  [31:0]  sram_data_o;
    output          sram_re_o;
    output          sram_we_o;

//Subsystem declarations
//    wire WB_clk; // Wishbone subsystem clock
//    wire WB_reset; // Wishbone subsystem reset

//Declarations for master side of the WB connection matrix
    wire [31:0] WB_master_addr; //Address bus for WB Master
    wire [31:0] WB_master_data_i; //Data input to WB Master
    wire [31:0] WB_master_data_o; //Data output for WB Master
    wire master_we; // Write enable for Master
    wire master_ack; //Acknowledge signal for master
    wire master_strobe; //Strobe signal to indicate valid data transfer cycle
    wire master_cycle; //Strobe signal to indicate valil bus cycle

//Declaration for the slave0 (IMA_ADPCM) of WB connection matrix
    wire [31:0] IMA_ADPCM_addr; // Address bus for IMA_ADPCM
    wire [31:0] IMA_ADPCM_data_i; // Data input to IMA_ADPCM
    wire [31:0] IMA_ADPCM_data_o; //Data output from IMA_ADPCM
    wire IMA_ADPCM_write_en; // Write enable for IMA_ADPCM
    wire IMA_ADPCM_cycle; // Cycle signal for IMA_ADPCM
    wire IMA_ADPCM_strobe; //Acknowledge for IMA_ADPCM
    wire IMA_ADPCM_ack;  //Acknowledge for IMA_ADPCM

//Declaration for the slave0 (USB) of WB connection matrix
    wire [31:0] usb_addr; // Address bus for USB
    wire [31:0] usb_data_i; // Data input to USB
    wire [31:0] usb_data_o; //Data output from USB
    wire usb_write_en; // Write enable for USB
    wire usb_cycle; // Cycle signal for USB
    wire usb_strobe; //Strobe signal for USB
    wire usb_ack; //Acknowledge for USB

 // wb_clkgen wb_clkgen_u2(
//      .clk(WB_clk),
//      .reset(WB_reset));


  ahb2wb ahb2wb_u0(
      .htrans(Htrans) ,
      .dat_i(WB_master_data_i) ,
      .hresetn(Hresetn) ,
      .hclk(Hclk) ,
      .hwrite(Hwrite) ,
      .hrdata(Hrdata) ,
      .hsel(Hsel) ,
      .hready(Hready) ,
      .dat_o(WB_master_data_o) ,
      .ack_i(master_ack),
      .hburst(Hburst) ,
      .hwdata(Hwdata) ,
      .hresp(Hresp) ,
      .we_o(master_we) ,
      .hsize(Hsize) ,
      .haddr(Haddr[15:0]) ,
      .adr_o(WB_master_addr[15:0]) ,
      .cyc_o(master_cycle) ,
      .stb_o(master_strobe),
      .clk_i(WBClk),
      .rst_i(WBReset));

  wb_conmax_top conmax_u1 (
      .clk_i(WBClk),
      .rst_i(WBReset),
      .m0_data_i(WB_master_data_o),
`ifdef Fix_W415
      .m0_data_o(WB_master_data_i),
`else
      .m0_data_o(WB_master_data_o),
`endif

//* UndrivenInterm-ML Issue
`ifdef Fix_UndrivenInTerm
      .m0_addr_i({16'b0, WB_master_addr[15:0]}),
`else
      .m0_addr_i(WB_master_addr),
`endif
//      .m0_sel_i(),
      .m0_we_i(master_we),
      .m0_cyc_i(master_cycle),
      .m0_stb_i(master_strobe),
      .m0_ack_o(master_ack),
//      .m0_err_o(),
//      .m0_rty_o(),
`ifdef Fix_UndrivenInTerm
      .s0_data_i({16'b0, IMA_ADPCM_data_o[15:0]}),
`else
       .s0_data_i(IMA_ADPCM_data_o),
`endif
      .s0_data_o(IMA_ADPCM_data_i),
      .s0_addr_o(IMA_ADPCM_addr),
   //   .s0_sel_o(),
      .s0_we_o(IMA_ADPCM_we),
      .s0_cyc_o(IMA_ADPCM_cycle),
      .s0_stb_o(IMA_ADPCM_strobe),
      .s0_ack_i(IMA_ADPCM_ack),
  //    .s0_err_i(),
  //    .s0_rty_i(),
      .s1_data_i(usb_data_o),
      .s1_data_o(usb_data_i),
      .s1_addr_o(usb_addr),
  //    .s1_sel_o(),
      .s1_we_o(usb_we),
      .s1_cyc_o(usb_cycle),
      .s1_stb_o(usb_strobe),
      .s1_ack_i(usb_ack),
  //    .s1_err_i(),
  //    .s1_rty_i(),
// NEWLY ADDED CONNECTIONS and ALL NEW CONNECTIONS MADE it VCC
     .m1_we_i(1'b0),
     .m1_cyc_i(1'b0),
     .m1_stb_i(1'b0),
     .m2_we_i(1'b0),
     .m2_cyc_i(1'b0),
     .m2_stb_i(1'b0),
     .m3_we_i(1'b0),
     .m3_cyc_i(1'b0),
     .m3_stb_i(1'b0),
     .m4_we_i(1'b0),
     .m4_cyc_i(1'b0),
     .m4_stb_i(1'b0),
     .m5_we_i(1'b0),
     .m5_cyc_i(1'b0),
     .m5_stb_i(1'b0),
     .m6_we_i(1'b0),
     .m6_cyc_i(1'b0),
     .m6_stb_i(1'b0),
     .m7_we_i(1'b0),
     .m7_cyc_i(1'b0),
     .m7_stb_i(1'b0),
     .s2_ack_i(1'b0),
     .s2_err_i(1'b0),
     .s2_rty_i(1'b0),
     .s3_ack_i(1'b0),
     .s3_err_i(1'b0),
     .s3_rty_i(1'b0),
     .s4_ack_i(1'b0),
     .s4_err_i(1'b0),
     .s4_rty_i(1'b0),
     .s5_ack_i(1'b0),
     .s5_err_i(1'b0),
     .s5_rty_i(1'b0),
     .s6_ack_i(1'b0),
     .s6_err_i(1'b0),
     .s6_rty_i(1'b0),
     .s7_ack_i(1'b0),
     .s7_err_i(1'b0),
     .s7_rty_i(1'b0),
     .s8_ack_i(1'b0),
     .s8_err_i(1'b0),
     .s8_rty_i(1'b0),
     .s9_ack_i(1'b0),
     .s9_err_i(1'b0),
     .s9_rty_i(1'b0),
     .s10_ack_i(1'b0),
     .s10_err_i(1'b0),
     .s10_rty_i(1'b0),
     .s11_ack_i(1'b0),
     .s11_err_i(1'b0),
     .s11_rty_i(1'b0),
     .s12_ack_i(1'b0),
     .s12_err_i(1'b0),
     .s12_rty_i(1'b0),
     .s13_ack_i(1'b0),
     .s13_err_i(1'b0),
     .s13_rty_i(1'b0),
     .s14_ack_i(1'b0),
     .s14_err_i(1'b0),
     .s14_rty_i(1'b0),
     .s15_ack_i(1'b0),
     .s15_err_i(1'b0),
     .s15_rty_i(1'b0),
     .s15_data_i(32'b0),
     .s14_data_i(32'b0),
     .s13_data_i(32'b0),
     .s12_data_i(32'b0),
     .s11_data_i(32'b0),
     .s10_data_i(32'b0),
     .s9_data_i(32'b0),
     .s8_data_i(32'b0),
     .s7_data_i(32'b0),
     .s6_data_i(32'b0),
     .s5_data_i(32'b0),
     .s4_data_i(32'b0),
     .s3_data_i(32'b0),
     .s2_data_i(32'b0),
     .m7_sel_i(4'b0),
     .m7_addr_i(32'b0),
     .m7_data_i(32'b0),
     .m6_sel_i(4'b0),
     .m6_addr_i(32'b0),
     .m6_data_i(32'b0),
     .m5_sel_i(4'b0),
     .m5_addr_i(32'b0),
     .m5_data_i(32'b0),
     .m4_sel_i(4'b0),
     .m4_addr_i(32'b0),
     .m4_data_i(32'b0),
     .m3_sel_i(4'b0),
     .m3_addr_i(32'b0),
     .m3_data_i(32'b0),
     .m2_sel_i(4'b0),
     .m2_addr_i(32'b0),
     .m2_data_i(32'b0),
     .m1_sel_i(4'b0),
     .m1_addr_i(32'b0),
     .m1_data_i(32'b0),
     .m0_sel_i(4'b0),
     .s0_err_i(1'b0),
     .s0_rty_i(1'b0),
     .s1_err_i(1'b0),
     .s1_rty_i(1'b0)

   


);

  usbf_top usbf_top_u3(
      // WISHBONE Interface
      .clk_i(WBClk), 
      .rst_i(WBReset), 
      .wb_addr_i(usb_addr), 
      .wb_data_i(usb_data_i), 
      .wb_data_o(usb_data_o),
      .wb_ack_o(usb_ack), 
      .wb_we_i(usb_we), 
      .wb_stb_i(usb_strobe), 
      .wb_cyc_i(usb_cycle), 
      .inta_o(), 
      .intb_o(),
      .dma_req_o(), 
      .dma_ack_i(16'b0), 
      .susp_o(), 
      .resume_req_i(1'b0),
      // UTMI Interface
      .phy_clk_pad_i(phy_clk_i),
      .phy_rst_pad_o(phy_rst_o),
      .DataOut_pad_o(DataOut_o), 
      .TxValid_pad_o(TxValid_o), 
      .TxReady_pad_i(TxReady_i),
      .RxValid_pad_i(RxValid_i), 
      .RxActive_pad_i(RxActive_i), 
      .RxError_pad_i(RxError_i),
      .DataIn_pad_i(DataIn_i), 
      .XcvSelect_pad_o(XcvSelect_o), 
      .TermSel_pad_o(TestSel_o),
      .SuspendM_pad_o(SuspendM_o), 
      .LineState_pad_i(LineState_i),
      .OpMode_pad_o(OpMode_o), 
      .usb_vbus_pad_i(usb_vbus_i),
      .VControl_Load_pad_o(VControl_Load_o), 
      .VControl_pad_o(VControl_o), 
      .VStatus_pad_i(VStatus_i),
      // Buffer Memory Interface
      .sram_adr_o(sram_adr_o), 
      .sram_data_i(sram_data_i), 
      .sram_data_o(sram_data_o), 
      .sram_re_o(sram_re_o), 
      .sram_we_o(sram_we_o));

  IMA_ADPCM_top IMA_ADPCM_top_u5(
      .wb_clk_i(WBClk),
      .wb_rst_i(WBReset),
      .wb_cyc_i(IMA_ADPCM_cycle),
      .wb_stb_i(IMA_ADPCM_strobe),
      .wb_we_i(IMA_ADPCM_we),
      .wb_adr_i(IMA_ADPCM_addr[1:0]),
      .wb_dat_i(IMA_ADPCM_data_i[15:0]),
      .wb_dat_o(IMA_ADPCM_data_o[15:0]),
      .wb_ack_o(IMA_ADPCM_ack));

endmodule
