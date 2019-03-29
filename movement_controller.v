module movement_controller(
    input up, // rotate
    input down, // speed up
    input left, // move left
    input right, // move right
    input [2:0] cur_shape_id,
    input [2:0] nx_shape_id,
    input ld_cur,
    input ld_next,
    input clk_1_by_60, 
    input clk_quarter,
    input clk_1s,
    input resetn,
    output [15:0] to_nx_shape_display,
    output reg [3:0] t0_x_out,
    output reg [3:0] t1_x_out,
    output reg [3:0] t2_x_out,
    output reg [3:0] t3_x_out,
    output reg [4:0] t0_y_out,
    output reg [4:0] t1_y_out,
    output reg [4:0] t2_y_out,
    output reg [4:0] t3_y_out,
);

endmodule