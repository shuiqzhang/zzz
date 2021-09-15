/////////////////////////////////////////////////////////////////////
////                                                             ////
////  USB CRC5 and CRC16 Modules                                 ////
////                                                             ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
////                                                             ////
////  Downloaded from: http://www.opencores.org/cores/usb/       ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2000-2003 Rudolf Usselmann                    ////
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
//  $Id: usbf_crc5.v,v 1.4 2010/05/13 10:00:51 sbabu Exp $
//
//  $Date: 2010/05/13 10:00:51 $
//  $Revision: 1.4 $
//  $Author: sbabu $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: usbf_crc5.v,v $
//               Revision 1.4  2010/05/13 10:00:51  sbabu
//               commiting detailed_rtl_exit usb block files
//
//               Revision 1.1  2010/04/30 10:57:12  sbabu
//               commiting initila "detiled_rtl " anlaysis updated files
//
//               Revision 1.1  2010/04/26 06:17:20  sbabu
//               commiting USB block
//
//               Revision 1.1  2010/04/21 12:02:51  sbabu
//               adding snapshot modules
//
//               Revision 1.3  2010/02/10 19:10:36  mjohnson
//               reverting back to original usb core for now
//
//               Revision 1.1.1.1  2010/01/19 23:19:52  mjohnson
//               Initial release of spyglass reference flow using leon3mp
//
//               Revision 1.1  2001/08/03 05:30:09  rudi
//
//
//               1) Reorganized directory structure
//
//               Revision 1.0  2001/03/07 09:17:12  rudi
//
//
//               Changed all revisions to revision 1.0. This is because OpenCores CVS
//               interface could not handle the original '0.1' revision ....
//
//               Revision 0.1.0.1  2001/02/28 08:10:42  rudi
//               Initial Release
//
//                            

`include "../rtl/usb/usbf_defines.v"

///////////////////////////////////////////////////////////////////
//
// CRC5
//
///////////////////////////////////////////////////////////////////

module usbf_crc5(crc_in, din, crc_out);
input	[4:0]	crc_in;
input	[10:0]	din;
output	[4:0]	crc_out;

assign crc_out[0] =	din[10] ^ din[9] ^ din[6] ^ din[5] ^ din[3] ^
			din[0] ^ crc_in[0] ^ crc_in[3] ^ crc_in[4];

assign crc_out[1] =	din[10] ^ din[7] ^ din[6] ^ din[4] ^ din[1] ^
			crc_in[0] ^ crc_in[1] ^ crc_in[4];

assign crc_out[2] =	din[10] ^ din[9] ^ din[8] ^ din[7] ^ din[6] ^
			din[3] ^ din[2] ^ din[0] ^ crc_in[0] ^ crc_in[1] ^
			crc_in[2] ^ crc_in[3] ^ crc_in[4];

assign crc_out[3] =	din[10] ^ din[9] ^ din[8] ^ din[7] ^ din[4] ^ din[3] ^
			din[1] ^ crc_in[1] ^ crc_in[2] ^ crc_in[3] ^ crc_in[4];

assign crc_out[4] =	din[10] ^ din[9] ^ din[8] ^ din[5] ^ din[4] ^ din[2] ^
			crc_in[2] ^ crc_in[3] ^ crc_in[4];

endmodule

