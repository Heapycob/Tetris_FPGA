module shape_id_decoder(
    input [2:0] shape_id,
    output reg [15:0] display_code
);

always@(*) begin
    case(shape_id)
        3'd0: display_code = 16'b0000_0110_0110_0000; // "O"
        3'd1: display_code = 16'b0000_0000_1111_0000; // "I"
        3'd2: display_code = 16'b0000_0100_1110_0000; // "T"
        3'd3: display_code = 16'b0000_0110_0100_0100; // "L"
        3'd4: display_code = 16'b0000_0110_0010_0010; // "J"
        3'd5: display_code = 16'b0000_1100_0110_0000; // "S"
        3'd6: display_code = 16'b0000_0110_1100_0000; // "Z"
        default: display_code = 16'b0000_0000_1111_0000; // default : "I" since random number generator will produce 7 as well
    endcase
end

endmodule