module msm_test_connection(
    clk,
    resetn,
    start,
    ok
);
    input clk, resetn, start;
    output ok;

    wire [3:0] t0_x, t1_x, t2_x, t3_x;
    wire [4:0] t0_y, t1_y, t2_y, t3_y;
    wire up, down, left, right;
    wire [229:0] bdv;
    wire [15:0] tndp;
    wire g_over;

    //
    tetris tt(up, down, left, right, clk, resetn, start, bdv, tndp, t0_x, t1_x, t2_x, t3_x, t0_y, t1_y, t2_y, t3_y, g_over);
    //

endmodule
