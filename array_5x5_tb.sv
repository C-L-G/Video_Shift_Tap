/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  array_5x5_tb.sv
--Project Name: Video_Shift_Tap
--Data modified: 2016-04-11 14:38:37 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module array_5x5_tb;

bit     clock;
bit     rst_n;

clock_rst_verb #(
	.ACTIVE			 (0),
	.FreqM			 (100)
)clock_rst_verb_inst(
	.clock     (clock ),
	.rst_x     (rst_n )
);

wire        vsync,hsync,de,field;

video_sync_generator_B1 #(
	.MODE      ("1080P@60")
)video_sync_generator_B1_inst(
/*	input		*/		.pclk 		(clock        ),
/*	input		*/		.rst_n      (rst_n        ),
/*	input		*/		.enable     (1'b1         ),
/*	input		*/		.pause		(1'b0         ),
	//--->> Extend Sync
/*	output		*/		.vsync  	(vsync        ),
/*	output		*/		.hsync      (hsync        ),
/*	output		*/		.de         (de           ),
/*	output		*/		.field      (field        )
);

bit[7:0]        inxdata,inydata;

always@(posedge de)
    inxdata  = 0;


always@(posedge clock)
    if(de)
            inxdata = inxdata + 1;
    else    inxdata = inxdata;

always@(negedge de)
    inydata = inydata + 1;

always@(vsync)
    inydata = 0;

array_5x5 #(
    .DSIZE             (16          ),
    .VIDEO_WIDTH       (1920        ),
    .VIDEO_PRE_WIDTH   (2200-1920   )
)array_5x5_inst(
/*  input			    */  .clock	         (clock              ),
/*	input			    */  .rst_n           (rst_n              ),
/*	input			    */  .invs            (vsync              ),
/*	input			    */  .inde            (de                 ),
/*	input[DSIZE-1:0]	*/	.indata          ({inydata,inxdata}  )
);

endmodule
