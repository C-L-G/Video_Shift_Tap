/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  ram_list.v
--Project Name: Video_Shift_Tap
--Data modified: 2016-04-11 14:38:37 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module ram_list #(
    parameter   COL         = 2,
    parameter   DELAY_LINE  = 2,
    parameter   DSIZE       = 10,
    parameter   ASIZE       = 10
)(
    input                           clock               ,
    input                           rst_n               ,
    input                           wr_en               ,
    input [ASIZE-1:0]               wr_addr             ,
    input [DSIZE-1:0]               wr_data             ,
    input                           rd_en               ,
    input [ASIZE-1:0]               rd_addr             ,
    input [COL-1:0]                 rd_mask             ,
    input[3:0]                      wr_point            ,
    input[3:0]                      rd_point            ,
    output[COL*DSIZE-1:0]    rd_data
);

reg [COL-1:0]    wr_ram_point,rd_ram_point;

always@(posedge clock,negedge rst_n)begin:RAM_POINT
integer II;
    if(~rst_n)begin
        wr_ram_point    <= {COL{1'b0}};
        rd_ram_point    <= {COL{1'b0}};
    end else begin
        if(~wr_en)begin
            for(II=0;II<COL;II=II+1)
                wr_ram_point[II]    <= wr_point == II[3:0];
        end else
                wr_ram_point        <= wr_ram_point;

        if(~rd_en)begin
            for(II=0;II<COL;II=II+1)
                rd_ram_point[II]    <= rd_point == II[3:0];
        end else
                rd_ram_point        <= rd_ram_point;
end end

wire [DSIZE-1:0]    rd_ram_data [COL-1:0];

genvar JJ;
generate
for(JJ=0;JJ<COL;JJ=JJ+1)begin
video_shift_ram  #(
    .DSIZE      (DSIZE      ),
    .ASIZE      (ASIZE      )
)video_shift_ram_inst(
/*  input             */  .clock       (clock               ),
/*  input             */  .rst_n       (rst_n               ),
/*  input             */  .wr_en       (wr_en & wr_ram_point[JJ]             ),
/*  input [ASIZE-1:0] */  .wr_addr     (wr_addr             ),
/*  input [DSIZE-1:0] */  .wr_data     (wr_data             ),
/*  input             */  .rd_en       (rd_en               ),
/*  input [ASIZE-1:0] */  .rd_addr     (rd_addr             ),
/*  output[DSIZE-1:0] */  .rd_data     (rd_ram_data[JJ]     )
);
end
endgenerate

//--->> GENERATE INDEX <<-----------
genvar MM;
wire unsigned[COL-1:0] INDEX [15:0][COL-1:0];
generate
for(JJ=0;JJ<16;JJ=JJ+1)begin
    if (DELAY_LINE >= 1)
        for(MM=0;MM<COL;MM=MM+1)begin
            assign INDEX[JJ][MM] =  ( ((JJ%COL+(DELAY_LINE-1))%COL) >=MM)?  ((JJ%COL+(DELAY_LINE-1))%COL)-MM :
                                                                            COL+((JJ%COL+(DELAY_LINE-1))%COL)-MM ;
        end
    else
        for(MM=0;MM<COL;MM=MM+1)begin
            assign INDEX[JJ][MM] =  0;
        end
end
endgenerate
//---<< GENERATE INDEX >>-----------
reg  [DSIZE-1:0]    rd_oder_data [COL-1:0];

always@(posedge clock,negedge rst_n)begin:RD_RAM_POINT
integer KK;
    if(~rst_n) begin
        for(KK=0;KK<COL;KK=KK+1)
            rd_oder_data[KK]    <= {DSIZE{1'b0}};
    end else begin
        for(KK=0;KK<COL;KK=KK+1)begin
            case(rd_point)
            4'd0:rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[0][KK]] : {DSIZE{1'b0}};
            4'd1:rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[1][KK]] : {DSIZE{1'b0}};
            4'd2:rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[2][KK]] : {DSIZE{1'b0}};
            4'd3:rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[3][KK]] : {DSIZE{1'b0}};
            4'd4:rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[4][KK]] : {DSIZE{1'b0}};
            4'd5:rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[5][KK]] : {DSIZE{1'b0}};
            4'd6:rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[6][KK]] : {DSIZE{1'b0}};
            4'd7:rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[7][KK]] : {DSIZE{1'b0}};
            4'd8:rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[8][KK]] : {DSIZE{1'b0}};

            4'd9 :rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[ 9][KK]] : {DSIZE{1'b0}};
            4'd10:rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[10][KK]] : {DSIZE{1'b0}};
            4'd11:rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[11][KK]] : {DSIZE{1'b0}};
            4'd12:rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[12][KK]] : {DSIZE{1'b0}};
            4'd13:rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[13][KK]] : {DSIZE{1'b0}};
            4'd14:rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[14][KK]] : {DSIZE{1'b0}};
            4'd15:rd_oder_data[KK] <= rd_mask[KK]? rd_ram_data[INDEX[15][KK]] : {DSIZE{1'b0}};
            default:
                rd_oder_data[KK]    <= {DSIZE{1'b0}};
            endcase
        end
end end

generate
for(JJ=0;JJ<COL;JJ=JJ+1)begin
    assign rd_data[JJ*DSIZE+:DSIZE] = rd_oder_data[JJ];
end
endgenerate




endmodule
