/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  ram_addr_loop.v
--Project Name: Video_Shift_Tap
--Data modified: 2016-04-11 14:38:37 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module ram_addr_loop #(
        parameter COL   = 5,
        parameter WIDTH = 1920 ,
        parameter PRE_WIDTH = 2200 -1920,
        parameter DELAY_LINE = 2,
        parameter ASIZE     = 16
)(
    input               clock           ,
    input               rst_n           ,
    input               vsync           ,
    input               de              ,
    output[ASIZE-1:0]   wr_addr         ,
    output              wr_en           ,
    output[ASIZE-1:0]   rd_addr         ,
    output              rd_en           ,
    output[3:0]         wr_point        ,
    output[3:0]         rd_point        ,
    output[COL-1:0]     rd_mask         ,
    output              vsync_delay     ,
    output              de_delay
);
localparam RAM_DELAY = 3;
localparam VS_TOTLE_DELAY = DELAY_LINE*(PRE_WIDTH+WIDTH)-RAM_DELAY;

localparam EXT_LINE = COL+1-DELAY_LINE-1;

wire[DELAY_LINE-1:0]    vs_lat;
wire                    vs_mix_lat;

latency_dynamic #(
	.LSIZE         (16     )
)vs_latency_dynamic_inst(
/*	input		       */ .clk	     (clock   ),
/*	input		       */ .rst_n     (rst_n   ),
/*  input [LSIZE-1:0]  */ .lat       (VS_TOTLE_DELAY   ),
/*	input		       */ .d         (vsync   ),
/*	output		       */ .q         (vs_mix_lat  )
);

wire[DELAY_LINE-1:0]    de_lat;
wire              de_mix_lat;
latency_dynamic #(
	.LSIZE         (16     )
)de_latency_dynamic_inst(
/*	input		       */ .clk	     (clock   ),
/*	input		       */ .rst_n     (rst_n   ),
/*  input [LSIZE-1:0]  */ .lat       (PRE_WIDTH+WIDTH-RAM_DELAY   ),
/*	input		       */ .d         (de      ),
/*	output		       */ .q         (de_lat[0]  )
);

genvar II;
generate
if(DELAY_LINE>1)begin
    for(II=1;II<DELAY_LINE;II=II+1)begin
        latency_dynamic #(
        	.LSIZE         (16     )
        )de_latency_dynamic_inst_next(
        /*	input		       */ .clk	     (clock   ),
        /*	input		       */ .rst_n     (rst_n   ),
        /*  input [LSIZE-1:0]  */ .lat       (PRE_WIDTH+WIDTH   ),
        /*	input		       */ .d         (de_lat[II-1]  ),
        /*	output		       */ .q         (de_lat[II]  )
        );

        // latency_dynamic #(
        // 	.LSIZE         (16     )
        // )vs_latency_dynamic_inst_next(
        // /*	input		       */ .clk	     (clock   ),
        // /*	input		       */ .rst_n     (rst_n   ),
        // /*  input [LSIZE-1:0]  */ .lat       (PRE_WIDTH+WIDTH   ),
        // /*	input		       */ .d         (vs_lat[II-1]  ),
        // /*	output		       */ .q         (vs_lat[II]  )
        // );

    end
    assign de_mix_lat = de_lat[DELAY_LINE-1];
//    assign vs_mix_lat = vs_lat[DELAY_LINE-1];
end else begin
    assign de_mix_lat = de_lat[0];
//    assign vs_mix_lat = vs_lat[0];
end
endgenerate
//--->> VS EDGE <<---------------

edge_generator #(
	.MODE	("NORMAL")   // FAST NORMAL BEST
)wr_vs_edge_generator_inst(
	.clk			(clock			),
	.rst_n          (rst_n          ),
	.in             (vsync             ),
	.raising        (wr_vs_raising    ),
	.falling        (wr_vs_falling    )
);

wire	rd_vs_falling;
wire	rd_vs_raising;

edge_generator #(
	.MODE	("NORMAL")   // FAST NORMAL BEST
)rd_vs_edge_generator_inst(
	.clk			(clock			),
	.rst_n          (rst_n          ),
	.in             (vs_mix_lat       ),
	.raising        (rd_vs_raising    ),
	.falling        (rd_vs_falling    )
);
//---<< VS EDGE >>---------------
reg [ASIZE-1:0]      wr_addr_cnt;

always@(posedge clock,negedge rst_n)
    if(~rst_n)      wr_addr_cnt    <= {ASIZE{1'd0}};
    else begin
        if(vsync)   wr_addr_cnt    <= {ASIZE{1'd0}};
        else if(de)begin
        //     if(wr_addr_cnt == WIDTH-1'b1)
        //             wr_addr_cnt    <= {ASIZE{1'd0}};
        //     else    wr_addr_cnt    <= wr_addr_cnt + 1'b1;
        // end else    wr_addr_cnt    <= wr_addr_cnt;
            wr_addr_cnt    <= wr_addr_cnt + 1'b1;
        end else    wr_addr_cnt    <= {ASIZE{1'd0}};
    end

reg [ASIZE-1:0]      rd_addr_cnt;

always@(posedge clock,negedge rst_n)
    if(~rst_n)      rd_addr_cnt    <= {ASIZE{1'd0}};
    else begin
        if(vs_mix_lat)   rd_addr_cnt   <= {ASIZE{1'd0}};
        else if(de_mix_lat)begin
        //     if(rd_addr_cnt == WIDTH-1'b1)
        //             rd_addr_cnt    <= {ASIZE{1'd0}};
        //     else    rd_addr_cnt    <= rd_addr_cnt + 1'b1;
        // end else    rd_addr_cnt    <= rd_addr_cnt;
            rd_addr_cnt    <= rd_addr_cnt + 1'b1;
        end else    rd_addr_cnt    <= {ASIZE{1'd0}};
    end

//--->> COLUMN LOOP <<----------
wire	wr_de_falling;
wire	wr_de_raising;

edge_generator #(
	.MODE	("NORMAL")   // FAST NORMAL BEST
)wr_de_edge_generator_inst(
	.clk			(clock			),
	.rst_n          (rst_n          ),
	.in             (de             ),
	.raising        (wr_de_raising    ),
	.falling        (wr_de_falling    )
);

wire	rd_de_falling;
wire	rd_de_raising;

edge_generator #(
	.MODE	("NORMAL")   // FAST NORMAL BEST
)rd_de_edge_generator_inst(
	.clk			(clock			),
	.rst_n          (rst_n          ),
	.in             (de_mix_lat     ),
	.raising        (rd_de_raising    ),
	.falling        (rd_de_falling    )
);

reg [3:0]       wr_col;
reg [3:0]       rd_col;

always@(posedge clock,negedge rst_n)
    if(~rst_n)  wr_col  <= 4'd0;
    else begin
        if(vsync)  wr_col  <= 4'd0;
        else if(wr_de_falling)
                if(wr_col == COL-1)
                        wr_col  <= 4'd0;
                else    wr_col  <= wr_col + 1'b1;
        else    wr_col  <= wr_col;
    end

always@(posedge clock,negedge rst_n)
    if(~rst_n)  rd_col  <= 4'd0;
    else begin
        if(vs_mix_lat)
                rd_col  <= 4'd0;
        else if(rd_de_falling)
                if(rd_col == COL-1)
                        rd_col  <= 4'd0;
                else    rd_col  <= rd_col + 1'b1;
        else    rd_col  <= rd_col;
    end

//---<< COLUMN LOOP >>----------
//--->> READ MASK <<------------
wire[COL-1:0]   mask_read;
reg [COL-1:0]      mask_line;

always@(posedge clock,negedge rst_n)begin: MASK_CNT_BLOCK
reg [15:0]       wr_view_cnt,rd_view_cnt;
reg [3:0]        sub_wr_rd;
reg [3:0]        ext_sub;
reg [3:0]        fraction_wr;
reg [3:0]        pre_fraction_wr;
reg              wr_flag;
reg              rd_flag;
integer KK;
    if(~rst_n)begin
        wr_view_cnt <= {16{1'b0}};
        rd_view_cnt <= {16{1'b0}};
        wr_flag     <= 1'b0;
        rd_flag     <= 1'b0;
    end else begin
        if(vsync)   wr_view_cnt   <=  {16{1'b0}};
        else if(wr_de_falling)
                    wr_view_cnt   <= wr_view_cnt + 1'b1;
        else        wr_view_cnt   <= wr_view_cnt;

        if(vs_mix_lat)
                    rd_view_cnt   <=  {16{1'b0}};
        else if(rd_de_falling)
                    rd_view_cnt   <= rd_view_cnt + 1'b1;
        else        rd_view_cnt   <= rd_view_cnt;
        //--->> FLAG <<-----
        if(vsync && vs_mix_lat)begin
            wr_flag     <= 1'b0;
            rd_flag     <= 1'b0;
        end else begin
            if(wr_vs_falling)
                    wr_flag <= ~wr_flag;
            else    wr_flag <= wr_flag;
            if(rd_vs_falling)
                    rd_flag <= ~rd_flag;
            else    rd_flag <= rd_flag;
        end
        //---<< FLAG >>-----
        sub_wr_rd   <= (wr_flag == rd_flag) ? wr_view_cnt-rd_view_cnt : sub_wr_rd - rd_de_falling;
        ext_sub     <= (EXT_LINE < sub_wr_rd)? 4'd0 : EXT_LINE - sub_wr_rd;
        pre_fraction_wr <= (wr_view_cnt>15)? 4'd16 : wr_view_cnt[3:0];
        fraction_wr <= (wr_flag == rd_flag) ? pre_fraction_wr : 4'd16;
    //    mask_line[DELAY_LINE] <= 1'b0;
        for(KK=0;KK<COL;KK=KK+1)begin
            if(wr_view_cnt>COL)
                    mask_line[KK]    <= !(ext_sub > KK);
            else    mask_line[KK]    <= fraction_wr > KK;
        end
end end

assign  mask_read = mask_line[COL-1:0];

//---<< READ MASK >>------------
assign wr_addr  = wr_addr_cnt;
assign rd_addr  = rd_addr_cnt;
assign wr_en    = de;
assign rd_en    = de_mix_lat;

assign wr_point = wr_col;
assign rd_point = rd_col;

assign vsync_delay  = vs_mix_lat;
assign de_delay     = de_mix_lat;

assign rd_mask = mask_read;

endmodule
