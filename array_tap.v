/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  array_tap.v
--Project Name: Video_Shift_Tap
--Data modified: 2016-04-11 14:38:37 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module array_tap #(
    parameter SIZE = 5,
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
    output[DSIZE*SIZE*SIZE-1:0]outdata
);

wire vector_vs,vector_de;
wire[DSIZE*SIZE-1:0] vector_data;

vector #(
    .LENGTH             (SIZE               ),
    .DSIZE              (DSIZE              ),
    .VIDEO_WIDTH        (VIDEO_WIDTH        ),
    .VIDEO_PRE_WIDTH    (VIDEO_PRE_WIDTH    )
)vector_inst(
/*  input			        */  .clock		(clock          ),
/*	input			        */  .rst_n      (rst_n          ),
/*	input			        */  .invs       (invs           ),
/*	input			        */  .inde       (inde           ),
/*	input[DSIZE-1:0]		*/  .indata     (indata         ),
/**/
/*  output                  */  .outvs      (vector_vs      ),
/*  output                  */  .outde      (vector_de      ),
/*  output[DSIZE*LENGTH-1:0]*/  .outdata    (vector_data    )
);


reg [DSIZE*SIZE-1:0] data_reg [SIZE-1:0];

always@(posedge clock,negedge rst_n)begin : SHIFT_BLOCK
integer KK;
    if(~rst_n)begin
        for(KK=1;KK<SIZE;KK=KK+1)
            data_reg[KK]    <= {(DSIZE*SIZE){1'b0}};
    end else begin
        data_reg[1]    <= vector_de? data_reg[0] : {(DSIZE*SIZE){1'b0}};
        for(KK=1;KK<SIZE-1;KK=KK+1)
            data_reg[KK+1]    <= data_reg[KK];
end end

always@(*)
    data_reg[0] = vector_de? vector_data : {(DSIZE*SIZE){1'b0}};

genvar LL;
generate
for(LL=0;LL<SIZE;LL=LL+1)
    assign outdata[LL*(DSIZE*SIZE)+:DSIZE*SIZE] = data_reg[LL];
endgenerate
//--->> SYNC LATENCY <<-----
latency #(
	.LAT	((SIZE-1)/2	),
	.DSIZE	(2		)
)lat_de_vs_inst(
	.clk	(clock		),
	.rst_n	(rst_n		),
	.d		({vector_vs,vector_de}		),
	.q		({outvs,outde}	)
);

endmodule
