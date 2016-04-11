/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  video_shift_ram.v
--Project Name: Video_Shift_Tap
--Data modified: 2016-04-11 14:38:37 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module video_shift_ram #(
    parameter DSIZE = 24,
    parameter ASIZE = 10
)(
    input               clock       ,
    input               rst_n       ,
    input               wr_en       ,
    input [ASIZE-1:0]   wr_addr     ,
    input [DSIZE-1:0]   wr_data     ,
    input               rd_en       ,
    input [ASIZE-1:0]   rd_addr     ,
    output[DSIZE-1:0]   rd_data
);

IP_DoulPortRam  IP_DoulPortRam_inst(
    .clock             (clock             ),
	.rdaddress         (rd_addr[ASIZE-1:0]),
//	.rdclock           (clock             ),
	.rden              (rd_en             ),
	.wraddress         (wr_addr[ASIZE-1:0]),
//	.wrclock           (clock             ),
	.wren              (wr_en             ),
    .data              (wr_data[DSIZE-1:0]),
	.q                 (rd_data[DSIZE-1:0])
);

endmodule
