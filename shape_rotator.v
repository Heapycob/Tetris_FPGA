module shape_rotator(
    input [2:0] shape_id,
    input [3:0] t0_x,
    input [3:0] t1_x,
    input [3:0] t2_x,
    input [3:0] t3_x,
    input [4:0] t0_y,
    input [4:0] t1_y,
    input [4:0] t2_y,
    input [4:0] t3_y,
    output reg [3:0] t0_x_out,
    output reg [3:0] t1_x_out,
    output reg [3:0] t2_x_out,
    output reg [3:0] t3_x_out,
    output reg [4:0] t0_y_out,
    output reg [4:0] t1_y_out,
    output reg [4:0] t2_y_out,
    output reg [4:0] t3_y_out
);
    
    always@(*) begin
        t0_x_out <= t0_x;
        t1_x_out <= t1_x;
        t2_x_out <= t2_x;
        t3_x_out <= t3_x;
        t0_y_out <= t0_y;
        t1_y_out <= t1_y;
        t2_y_out <= t2_y;
        t3_y_out <= t3_y;
        case(shape_id)
            3'd0: begin // "O" -- 1 state
                t0_x_out <= t0_x;
                t0_y_out <= t0_y;
                t1_x_out <= t1_x;
                t1_y_out <= t1_y;
                t2_x_out <= t2_x;
                t2_y_out <= t2_y;
                t3_x_out <= t3_x;
                t3_y_out <= t3_y;
            end
            3'd1: begin // "I" -- 2 states
                if (t1_y == t0_y + 1'd1 && t2_y == t1_y + 1'd1 && t3_y == t2_y + 1'd1 && t0_x == t1_x && t1_x == t2_x && t2_x == t3_x) begin
                    t0_x_out <= t0_x - 1'd1;
                    t0_y_out <= t0_y + 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x + 1'd1;
                    t2_y_out <= t2_y - 1'd1;
                    t3_x_out <= t3_x + 2'd2;
                    t3_y_out <= t3_y - 2'd2;
                end
                else if (t0_y == t1_y && t1_y == t2_y && t2_y == t3_y && t1_x == t0_x + 1'd1 && t2_x == t1_x + 1'd1 && t3_x == t2_x + 1'd1) begin
                    t0_x_out <= t0_x + 1'd1;
                    t0_y_out <= t0_y - 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x - 1'd1;
                    t2_y_out <= t2_y + 1'd1;
                    t3_x_out <= t3_x - 2'd2;
                    t3_y_out <= t3_y + 2'd2;
                end
            end
            3'd2: begin // "T" -- 4 states
                if (t1_x == t0_x + 1'd1 && t2_x == t1_x + 1'd1 && t3_x == t1_x && t0_y == t1_y && t1_y == t2_y && t3_y == t1_y + 1'd1) begin
                    t0_x_out <= t0_x + 1'd1;
                    t0_y_out <= t0_y - 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x - 1'd1;
                    t2_y_out <= t2_y + 1'd1;
                    t3_x_out <= t3_x - 1'd1;
                    t3_y_out <= t3_y - 1'd1;
                end
                else if (t0_x == t1_x && t1_x == t2_x && t3_x == t1_x - 1'd1 && t1_y == t0_y + 1'd1 && t2_y == t1_y + 1'd1 && t3_y == t1_y) begin
                    t0_x_out <= t0_x + 1'd1;
                    t0_y_out <= t0_y + 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x - 1'd1;
                    t2_y_out <= t2_y - 1'd1;
                    t3_x_out <= t3_x + 1'd1;
                    t3_y_out <= t3_y - 1'd1;
                end
                else if (t1_y == t2_y && t2_y == t0_y && t3_y == t1_y - 1'd1 && t1_x == t2_x + 1'd1 && t0_x == t1_x + 1'd1 && t3_x == t1_x) begin
                    t0_x_out <= t0_x - 1'd1;
                    t0_y_out <= t0_y + 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x + 1'd1;
                    t2_y_out <= t2_y - 1'd1;
                    t3_x_out <= t3_x + 1'd1;
                    t3_y_out <= t3_y + 1'd1;
                end
                else if (t2_x == t1_x && t1_x == t0_x && t3_x == t1_x + 1'd1 && t1_y == t2_y + 1'd1 && t0_y == t1_y + 1'd1 && t3_y == t1_y) begin
                    t0_x_out <= t0_x - 1'd1;
                    t0_y_out <= t0_y - 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x + 1'd1;
                    t2_y_out <= t2_y + 1'd1;
                    t3_x_out <= t3_x - 1'd1;
                    t3_y_out <= t3_y + 1'd1;
                end
            end
            3'd3: begin // "L" -- 4 states
                if (t0_x == t1_x && t1_x == t2_x && t3_x == t2_x + 1'd1 && t1_y == t0_y + 1'd1 && t2_y == t1_y + 1'd1 && t3_y == t2_y) begin
                    t0_x_out <= t0_x + 1'd1;
                    t0_y_out <= t0_y + 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x - 1'd1;
                    t2_y_out <= t2_y - 1'd1;
                    t3_x_out <= t3_x - 2'd2;
                    t3_y_out <= t3_y;
                end
                else if (t2_y == t1_y && t1_y == t0_y && t3_y == t2_y + 1'd1 && t1_x == t2_x + 1'd1 && t0_x == t1_x + 1'd1 && t3_x == t2_x) begin
                    t0_x_out <= t0_x - 1'd1;
                    t0_y_out <= t0_y + 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x + 1'd1;
                    t2_y_out <= t2_y - 1'd1;
                    t3_x_out <= t3_x;
                    t3_y_out <= t3_y - 2'd2;
                end
                else if (t3_x == t2_x - 1'd1 && t2_x == t1_x && t1_x == t0_x && t3_y == t2_y && t1_y == t2_y + 1'd1 && t0_y == t1_y + 1'd1) begin
                    t0_x_out <= t0_x - 1'd1;
                    t0_y_out <= t0_y - 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x + 1'd1;
                    t2_y_out <= t2_y + 1'd1;
                    t3_x_out <= t3_x + 2'd2;
                    t3_y_out <= t3_y;
                end
                else if (t0_x == t1_x - 1'd1 && t1_x == t2_x - 1'd1 && t2_x == t3_x && t0_y == t1_y && t1_y == t2_y && t2_y == t3_y + 1'd1) begin
                    t0_x_out <= t0_x + 1'd1;
                    t0_y_out <= t0_y - 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x - 1'd1;
                    t2_y_out <= t2_y + 1'd1;
                    t3_x_out <= t3_x;
                    t3_y_out <= t3_y + 2'd2;
                end
            end
            3'd4: begin // "J" -- 4 states
                if (t0_x == t1_x && t1_x == t3_x && t2_x == t3_x - 1'd1 && t1_y == t0_y + 1'd1 && t3_y == t1_y + 1'd1 && t2_y == t3_y) begin
                    t0_x_out <= t0_x + 1'd1;
                    t0_y_out <= t0_y + 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x;
                    t2_y_out <= t2_y - 2'd2;
                    t3_x_out <= t3_x - 1'd1;
                    t3_y_out <= t3_y - 1'd1;
                end
                else if (t3_y == t1_y && t1_y == t0_y && t2_y == t3_y - 1'd1 && t2_x == t3_x && t1_x == t3_x + 1'd1 && t0_x == t1_x + 1'd1) begin
                    t0_x_out <= t0_x - 1'd1;
                    t0_y_out <= t0_y + 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x + 2'd2;
                    t2_y_out <= t2_y;
                    t3_x_out <= t3_x + 1'd1;
                    t3_y_out <= t3_y - 1'd1;
                end
                else if (t3_x == t1_x && t1_x == t0_x && t2_x == t3_x + 1'd1 && t3_y == t2_y && t1_y == t3_y + 1'd1 && t0_y == t1_y + 1'd1) begin
                    t0_x_out <= t0_x - 1'd1;
                    t0_y_out <= t0_y - 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x;
                    t2_y_out <= t2_y + 2'd2;
                    t3_x_out <= t3_x + 1'd1;
                    t3_y_out <= t3_y + 1'd1;
                end
                else if (t0_y == t1_y && t1_y == t3_y && t2_y == t3_y + 1'd1 && t1_x == t0_x + 1'd1 && t3_x == t1_x + 1'd1 && t2_x == t3_x) begin
                    t0_x_out <= t0_x + 1'd1;
                    t0_y_out <= t0_y - 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x - 2'd2;
                    t2_y_out <= t2_y;
                    t3_x_out <= t3_x - 1'd1;
                    t3_y_out <= t3_y + 1'd1;
                end
            end
            3'd5: begin // "S" -- 2 states
                if (t0_x == t3_x && t3_x == t2_x + 1'd1 && t1_x == t0_x + 1'd1 && t0_y == t1_y && t2_y == t3_y && t3_y == t0_y + 1'd1) begin
                    t0_x_out <= t0_x;
                    t0_y_out <= t0_y;
                    t1_x_out <= t1_x - 1'd1;
                    t1_y_out <= t1_y + 1'd1;
                    t2_x_out <= t2_x;
                    t2_y_out <= t2_y - 2'd2;
                    t3_x_out <= t3_x - 1'd1;
                    t3_y_out <= t3_y - 1'd1;
                end
                else if (t2_x == t3_x && t0_x == t1_x && t0_x == t3_x + 1'd1 && t3_y == t2_y + 1'd1 && t3_y == t0_y && t1_y == t0_y + 1'd1) begin
                    t0_x_out <= t0_x;
                    t0_y_out <= t0_y;
                    t1_x_out <= t1_x + 1'd1;
                    t1_y_out <= t1_y - 1'd1;
                    t2_x_out <= t2_x;
                    t2_y_out <= t2_y + 2'd2;
                    t3_x_out <= t3_x + 1'd1;
                    t3_y_out <= t3_y + 1'd1;
                end
            end
            3'd6: begin // "Z" -- 2 states
                if (t1_x == t0_x + 1'd1 && t2_x == t1_x && t3_x == t2_x + 1'd1 && t0_y == t1_y && t2_y == t3_y && t2_y == t1_y + 1'd1) begin
                    t0_x_out <= t0_x + 1'd1;
                    t0_y_out <= t0_y - 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x - 1'd1;
                    t2_y_out <= t2_y - 1'd1;
                    t3_x_out <= t3_x - 2'd2;
                    t3_y_out <= t3_y;
                end
                else if(t0_x == t1_x && t2_x == t3_x && t0_x == t2_x + 1'd1 && t2_y == t1_y && t2_y == t0_y + 1'd1 && t3_y == t2_y + 1'd1) begin
                    t0_x_out <= t0_x - 1'd1;
                    t0_y_out <= t0_y + 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x + 1'd1;
                    t2_y_out <= t2_y + 1'd1;
                    t3_x_out <= t3_x + 2'd2;
                    t3_y_out <= t3_y;
                end
            end
            default: begin // same as "I"
                if (t1_y == t0_y + 1'd1 && t2_y == t1_y + 1'd1 && t3_y == t2_y + 1'd1 && t0_x == t1_x && t1_x == t2_x && t2_x == t3_x) begin
                    t0_x_out <= t0_x - 1'd1;
                    t0_y_out <= t0_y + 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x + 1'd1;
                    t2_y_out <= t2_y - 1'd1;
                    t3_x_out <= t3_x + 2'd2;
                    t3_y_out <= t3_y - 2'd2;
                end
                else if (t0_y == t1_y && t1_y == t2_y && t2_y == t3_y && t1_x == t0_x + 1'd1 && t2_x == t1_x + 1'd1 && t3_x == t2_x + 1'd1) begin
                    t0_x_out <= t0_x + 1'd1;
                    t0_y_out <= t0_y - 1'd1;
                    t1_x_out <= t1_x;
                    t1_y_out <= t1_y;
                    t2_x_out <= t2_x - 1'd1;
                    t2_y_out <= t2_y + 1'd1;
                    t3_x_out <= t3_x - 2'd2;
                    t3_y_out <= t3_y + 2'd2;
                end
            end
        endcase
    end


endmodule