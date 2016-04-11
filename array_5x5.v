/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  array_5x5.v
--Project Name: Video_Shift_Tap
--Data modified: 2016-04-11 14:38:37 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module array_5x5 #(
    parameter DSIZE  = 24,
    parameter VIDEO_WIDTH       = 1920 ,
    parameter VIDEO_PRE_WIDTH   = 2200-1920
)(
    input			        clock		,
	input			        rst_n       ,
	input			        invs        ,
	input			        inde        ,
	input[DSIZE-1:0]		indata      ,

    output                  outvs       ,
    output                  outde       ,
    output[DSIZE-1:0]       outdata_0_0 ,
    output[DSIZE-1:0]       outdata_0_1 ,
    output[DSIZE-1:0]       outdata_0_2 ,
    output[DSIZE-1:0]       outdata_0_3 ,
    output[DSIZE-1:0]       outdata_0_4 ,
    output[DSIZE-1:0]       outdata_1_0 ,
    output[DSIZE-1:0]       outdata_1_1 ,
    output[DSIZE-1:0]       outdata_1_2 ,
    output[DSIZE-1:0]       outdata_1_3 ,
    output[DSIZE-1:0]       outdata_1_4 ,
    output[DSIZE-1:0]       outdata_2_0 ,
    output[DSIZE-1:0]       outdata_2_1 ,
    output[DSIZE-1:0]       outdata_2_2 ,
    output[DSIZE-1:0]       outdata_2_3 ,
    output[DSIZE-1:0]       outdata_2_4 ,
    output[DSIZE-1:0]       outdata_3_0 ,
    output[DSIZE-1:0]       outdata_3_1 ,
    output[DSIZE-1:0]       outdata_3_2 ,
    output[DSIZE-1:0]       outdata_3_3 ,
    output[DSIZE-1:0]       outdata_3_4 ,
    output[DSIZE-1:0]       outdata_4_0 ,
    output[DSIZE-1:0]       outdata_4_1 ,
    output[DSIZE-1:0]       outdata_4_2 ,
    output[DSIZE-1:0]       outdata_4_3 ,
    output[DSIZE-1:0]       outdata_4_4
);

wire [DSIZE*5*5-1:0]        outdata;

array_tap #(
    .SIZE              (5                   ),
    .DSIZE             (DSIZE               ),
    .VIDEO_WIDTH       (VIDEO_WIDTH         ),
    .VIDEO_PRE_WIDTH   (VIDEO_PRE_WIDTH     )
)array_tap_inst(
/*  input			    */  .clock		  (clock	 ),
/*	input			    */  .rst_n        (rst_n     ),
/*	input			    */  .invs         (invs      ),
/*	input			    */  .inde         (inde      ),
/*	input[DSIZE-1:0]	*/	.indata       (indata    ),

/*  output               */ .outvs        (outvs     ),
/*  output               */ .outde        (outde     ),
/*  output[DSIZE*SIZE*SIZE-1:0]*/
                            .outdata      (outdata   )
);


assign outdata_0_0 = outdata[(0+5*0) *  DSIZE+:DSIZE];
assign outdata_0_1 = outdata[(0+5*1) *  DSIZE+:DSIZE];
assign outdata_0_2 = outdata[(0+5*2) *  DSIZE+:DSIZE];
assign outdata_0_3 = outdata[(0+5*3) *  DSIZE+:DSIZE];
assign outdata_0_4 = outdata[(0+5*4) *  DSIZE+:DSIZE];
assign outdata_1_0 = outdata[(1+5*0) *  DSIZE+:DSIZE];
assign outdata_1_1 = outdata[(1+5*1) *  DSIZE+:DSIZE];
assign outdata_1_2 = outdata[(1+5*2) *  DSIZE+:DSIZE];
assign outdata_1_3 = outdata[(1+5*3) *  DSIZE+:DSIZE];
assign outdata_1_4 = outdata[(1+5*4) *  DSIZE+:DSIZE];
assign outdata_2_0 = outdata[(2+5*0) *  DSIZE+:DSIZE];
assign outdata_2_1 = outdata[(2+5*1) *  DSIZE+:DSIZE];
assign outdata_2_2 = outdata[(2+5*2) *  DSIZE+:DSIZE];
assign outdata_2_3 = outdata[(2+5*3) *  DSIZE+:DSIZE];
assign outdata_2_4 = outdata[(2+5*4) *  DSIZE+:DSIZE];
assign outdata_3_0 = outdata[(3+5*0) *  DSIZE+:DSIZE];
assign outdata_3_1 = outdata[(3+5*1) *  DSIZE+:DSIZE];
assign outdata_3_2 = outdata[(3+5*2) *  DSIZE+:DSIZE];
assign outdata_3_3 = outdata[(3+5*3) *  DSIZE+:DSIZE];
assign outdata_3_4 = outdata[(3+5*4) *  DSIZE+:DSIZE];
assign outdata_4_0 = outdata[(4+5*0) *  DSIZE+:DSIZE];
assign outdata_4_1 = outdata[(4+5*1) *  DSIZE+:DSIZE];
assign outdata_4_2 = outdata[(4+5*2) *  DSIZE+:DSIZE];
assign outdata_4_3 = outdata[(4+5*3) *  DSIZE+:DSIZE];
assign outdata_4_4 = outdata[(4+5*4) *  DSIZE+:DSIZE];

endmodule
