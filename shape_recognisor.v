module shape_recognisor(
    input [2:0]shape_id,
    output reg [3:0] t0_x,
    output reg [3:0] t1_x,
    output reg [3:0] t2_x,
    output reg [3:0] t3_x,
    output reg [4:0] t0_y,
    output reg [4:0] t1_y,
    output reg [4:0] t2_y,
    output reg [4:0] t3_y
);

always@(*) begin
    case(shape_id)
        3'd0: begin // O
            t0_x <= 4'd4;
            t0_y <= 5'd0;
            t1_x <= 4'd5;
            t1_y <= 5'd0;
            t2_x <= 4'd4;
            t2_y <= 5'd1;
            t3_x <= 4'd5;
            t3_y <= 5'd1;
        end
        3'd1: begin // I
            t0_x <= 4'd5;
            t0_y <= 5'd0;
            t1_x <= 4'd5;
            t1_y <= 5'd1;
            t2_x <= 4'd5;
            t2_y <= 5'd2;
            t3_x <= 4'd5;
            t3_y <= 5'd3;
        end
        3'd2: begin // T
            t0_x <= 4'd4;
            t0_y <= 5'd0;
            t1_x <= 4'd5;
            t1_y <= 5'd0;
            t2_x <= 4'd6;
            t2_y <= 5'd0;
            t3_x <= 4'd5;
            t3_y <= 5'd1;
        end
        3'd3: begin // L
            t0_x <= 4'd4;
            t0_y <= 5'd0;
            t1_x <= 4'd4;
            t1_y <= 5'd1;
            t2_x <= 4'd4;
            t2_y <= 5'd2;
            t3_x <= 4'd5;
            t3_y <= 5'd2;
        end
        3'd4: begin // J
            t0_x <= 4'd5;
            t0_y <= 5'd0;
            t1_x <= 4'd5;
            t1_y <= 5'd1;
            t2_x <= 4'd4;
            t2_y <= 5'd2;
            t3_x <= 4'd5;
            t3_y <= 5'd2;
        end
        3'd5: begin // S
            t0_x <= 4'd4;
            t0_y <= 5'd0;
            t1_x <= 4'd5;
            t1_y <= 5'd0;
            t2_x <= 4'd3;
            t2_y <= 5'd1;
            t3_x <= 4'd4;
            t3_y <= 5'd1;
        end
        3'd6: begin // Z
            t0_x <= 4'd4;
            t0_y <= 5'd0;
            t1_x <= 4'd5;
            t1_y <= 5'd0;
            t2_x <= 4'd5;
            t2_y <= 5'd1;
            t3_x <= 4'd6;
            t3_y <= 5'd1;
        end
        default: begin // I
            t0_x <= 4'd5;
            t0_y <= 5'd0;
            t1_x <= 4'd5;
            t1_y <= 5'd1;
            t2_x <= 4'd5;
            t2_y <= 5'd2;
            t3_x <= 4'd5;
            t3_y <= 5'd3;
        end
    endcase
end

endmodule