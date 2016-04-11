/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  vector.v
--Project Name: Video_Shift_Tap
--Data modified: 2016-04-11 14:38:37 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module vector #(
    parameter LENGTH = 5,
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
    output[DSIZE*LENGTH-1:0]outdata
);


localparam ASIZE  = (VIDEO_WIDTH <= 256)?  8  :
                    (VIDEO_WIDTH <= 512)?  9  :
                    (VIDEO_WIDTH <= 1024)? 10  :
                    (VIDEO_WIDTH <= 2048)? 11  :
                    (VIDEO_WIDTH <= 4096)? 12  : 13 ;


wire[ASIZE-1:0]    wr_addr         ;
wire               wr_en           ;
wire[ASIZE-1:0]    rd_addr         ;
wire               rd_en           ;
wire[3:0]          wr_point        ;
wire[3:0]          rd_point        ;
wire[LENGTH-1:0]   rd_mask         ;

wire                ram_delay_vs;
wire                ram_delay_de;

ram_addr_loop #(
    .COL            (LENGTH-1),
    .WIDTH          (VIDEO_WIDTH),
    .PRE_WIDTH      (VIDEO_PRE_WIDTH),
    .DELAY_LINE     ((LENGTH-1)/2),
    .ASIZE          (ASIZE   )
)ram_addr_loop_inst(
/*   input          */ .clock           (clock          ),
/*   input          */ .rst_n           (rst_n          ),
/*   input          */ .vsync           (invs           ),
/*   input          */ .de              (inde           ),
/*   output[15:0]   */ .wr_addr         (wr_addr        ),
/*   output         */ .wr_en           (wr_en          ),
/*   output[15:0]   */ .rd_addr         (rd_addr        ),
/*   output         */ .rd_en           (rd_en          ),
/*   output[COL-1:0]*/ .rd_mask         (rd_mask[LENGTH-2:0]),
/*   output[3:0]    */ .wr_point        (wr_point       ),
/*   output[3:0]    */ .rd_point        (rd_point       ),
/*   output         */ .vsync_delay     (ram_delay_vs   ),
/*   output         */ .de_delay        (ram_delay_de   )
);

assign rd_mask[LENGTH-1]    = 1'b1;     //current line is always action

ram_list #(
    .COL         (LENGTH-1      ),
    .DELAY_LINE  ((LENGTH-1)/2  ),
    .DSIZE       (DSIZE         ),
    .ASIZE       (ASIZE         )
)ram_list_inst(
/*  input                         */  .clock               (clock               ),
/*  input                         */  .rst_n               (rst_n               ),
/*  input                         */  .wr_en               (wr_en               ),
/*  input [15:0]                  */  .wr_addr             (wr_addr             ),
/*  input [DSIZE-1:0]             */  .wr_data             (indata              ),
/*  input [DELAY_LINE-1:0]        */  .rd_mask             (rd_mask[LENGTH-2:0] ),
/*  input                         */  .rd_en               (rd_en               ),
/*  input [15:0]                  */  .rd_addr             (rd_addr             ),
/*  input[3:0]                    */  .wr_point            (wr_point            ),
/*  input[3:0]                    */  .rd_point            (rd_point            ),
/*  output[DELAY_LINE*DSIZE-1:0]  */  .rd_data             (outdata[LENGTH*DSIZE-1:DSIZE]             )
);

assign outdata[DSIZE-1:0]   = indata;

latency #(
	.LAT	(1+2	), //2 clock for ram latency , 1 clock for order latency
	.DSIZE	(2		)
)lat_de_vs_inst(
	.clk	(clock		),
	.rst_n	(rst_n		),
	.d		({ram_delay_vs,ram_delay_de}		),
	.q		({outvs,outde}	)
);


endmodule
