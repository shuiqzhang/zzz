/////////////////////////////////////////////////////////////////////
////                                                             ////
////  WISHBONE Connection Matrix Priority Encoder                ////
////                                                             ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
////                                                             ////
////  Downloaded from: http://www.opencores.org/cores/wb_conmax/ ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2000-2002 Rudolf Usselmann                    ////
////                         www.asics.ws                        ////
////                         rudi@asics.ws                       ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

//  CVS Log
//
//  $Id: wb_conmax_pri_enc.v,v 1.2 2010/05/13 10:02:15 sbabu Exp $
//
//  $Date: 2010/05/13 10:02:15 $
//  $Revision: 1.2 $
//  $Author: sbabu $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: wb_conmax_pri_enc.v,v $
//               Revision 1.2  2010/05/13 10:02:15  sbabu
//               commiting wb_conmax blok for detailed_rtl_exit analysis
//
//               Revision 1.1  2010/04/30 10:57:13  sbabu
//               commiting initila "detiled_rtl " anlaysis updated files
//
//               Revision 1.1  2010/04/26 06:17:50  sbabu
//               commiting wb_conmax block
//
//               Revision 1.1  2010/04/21 12:02:52  sbabu
//               adding snapshot modules
//
//               Revision 1.1.1.1  2010/01/19 23:19:52  mjohnson
//               Initial release of spyglass reference flow using leon3mp
//
//               Revision 1.1.1.1  2001/10/19 11:01:41  rudi
//               WISHBONE CONMAX IP Core
//
//
//
//
//

`include "../rtl/wb_conmax/wb_conmax_defines.v"

module wb_conmax_pri_enc(
		valid,
		pri0, pri1, pri2, pri3,
		pri4, pri5, pri6, pri7,
		pri_out
		);

////////////////////////////////////////////////////////////////////
//
// Module Parameters
//

parameter	[1:0]	pri_sel = 2'd0;

////////////////////////////////////////////////////////////////////
//
// Module IOs
//

input	[7:0]	valid;
input	[1:0]	pri0, pri1, pri2, pri3;
input	[1:0]	pri4, pri5, pri6, pri7;
output	[1:0]	pri_out;

////////////////////////////////////////////////////////////////////
//
// Local Wires
//

wire	[3:0]	pri0_out, pri1_out, pri2_out, pri3_out;
wire	[3:0]	pri4_out, pri5_out, pri6_out, pri7_out;
wire	[3:0]	pri_out_tmp;
reg	[1:0]	pri_out0, pri_out1;
wire	[1:0]	pri_out;

////////////////////////////////////////////////////////////////////
//
// Priority Decoders
//

wb_conmax_pri_dec #(pri_sel) pd0(
		.valid(		valid[0]	),
		.pri_in(	pri0		),
		.pri_out(	pri0_out	)
		);


wb_conmax_pri_dec #(pri_sel) pd1(
		.valid(		valid[1]	),
		.pri_in(	pri1		),
		.pri_out(	pri1_out	)
		);

wb_conmax_pri_dec #(pri_sel) pd2(
		.valid(		valid[2]	),
		.pri_in(	pri2		),
		.pri_out(	pri2_out	)
		);

wb_conmax_pri_dec #(pri_sel) pd3(
		.valid(		valid[3]	),
		.pri_in(	pri3		),
		.pri_out(	pri3_out	)
		);

wb_conmax_pri_dec #(pri_sel) pd4(
		.valid(		valid[4]	),
		.pri_in(	pri4		),
		.pri_out(	pri4_out	)
		);

wb_conmax_pri_dec #(pri_sel) pd5(
		.valid(		valid[5]	),
		.pri_in(	pri5		),
		.pri_out(	pri5_out	)
		);

wb_conmax_pri_dec #(pri_sel) pd6(
		.valid(		valid[6]	),
		.pri_in(	pri6		),
		.pri_out(	pri6_out	)
		);

wb_conmax_pri_dec #(pri_sel) pd7(
		.valid(		valid[7]	),
		.pri_in(	pri7		),
		.pri_out(	pri7_out	)
		);

////////////////////////////////////////////////////////////////////
//
// Priority Encoding
//

assign pri_out_tmp =	pri0_out | pri1_out | pri2_out | pri3_out |
			pri4_out | pri5_out | pri6_out | pri7_out;

// 4 Priority Levels
always @(pri_out_tmp)
	if(pri_out_tmp[3])	pri_out1 = 2'h3;
	else
	if(pri_out_tmp[2])	pri_out1 = 2'h2;
	else
	if(pri_out_tmp[1])	pri_out1 = 2'h1;
	else			pri_out1 = 2'h0;

// 2 Priority Levels
always @(pri_out_tmp)
	if(pri_out_tmp[1])	pri_out0 = 2'h1;
	else			pri_out0 = 2'h0;

////////////////////////////////////////////////////////////////////
//
// Final Priority Output
//

// Select configured priority

assign pri_out = (pri_sel==2'd0) ? 2'h0 : ( (pri_sel==2'd1) ? pri_out0 : pri_out1 );

endmodule


