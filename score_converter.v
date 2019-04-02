module score_converter(
    num_in,
    num_out
);
    input [9:0] num_in;
    output [11:0] num_out;

    assign num_out[11:8] = num_in[9:0] / 100;
    assign num_out[7:4] = (num_in[9:0] - num_out[11:8]) / 10;
    assign num_out[3:0] = num_in[9:0] - num_out[11:8]*100 - num_out[7:4]*10;

endmodule