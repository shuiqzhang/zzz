/////////////////////////////////////////////////////////////////////
////                                                             ////
////  WISHBONE Connection Matrix Priority Decoder                ////
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
//  $Id: wb_conmax_pri_dec.v,v 1.2 2010/05/13 10:02:15 sbabu Exp $
//
//  $Date: 2010/05/13 10:02:15 $
//  $Revision: 1.2 $
//  $Author: sbabu $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: wb_conmax_pri_dec.v,v $
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
//               Revision 1.1.1.1  2001/10/19 11:01:42  rudi
//               WISHBONE CONMAX IP Core
//
//
//
//
//

`include "../rtl/wb_conmax/wb_conmax_defines.v"

module wb_conmax_pri_dec(valid, pri_in, pri_out);

////////////////////////////////////////////////////////////////////
//
// Module Parameters
//

parameter [1:0]	pri_sel = 2'd0;

////////////////////////////////////////////////////////////////////
//
// Module IOs
//

input		valid;
input	[1:0]	pri_in;
output	[3:0]	pri_out;

////////////////////////////////////////////////////////////////////
//
// Local Wires
//

wire	[3:0]	pri_out;
reg	[3:0]	pri_out_d0;
reg	[3:0]	pri_out_d1;

////////////////////////////////////////////////////////////////////
//
// Priority Decoder
//

// 4 Priority Levels
always @(valid or pri_in)
	if(!valid)		pri_out_d1 = 4'b0001;
	else
	if(pri_in==2'h0)	pri_out_d1 = 4'b0001;
	else
	if(pri_in==2'h1)	pri_out_d1 = 4'b0010;
	else
	if(pri_in==2'h2)	pri_out_d1 = 4'b0100;
	else			pri_out_d1 = 4'b1000;

// 2 Priority Levels
always @(valid or pri_in)
	if(!valid)		pri_out_d0 = 4'b0001;
	else
	if(pri_in==2'h0)	pri_out_d0 = 4'b0001;
	else			pri_out_d0 = 4'b0010;

// Select Configured Priority

assign pri_out = (pri_sel==2'd0) ? 4'h0 : ( (pri_sel==1'd1) ? pri_out_d0 : pri_out_d1 );

endmodule

