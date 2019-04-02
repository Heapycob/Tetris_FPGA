module alphabet_decoder(
    input [2:0] alphabet_order,
    output reg [24:0] display_code
);
    always@(*) begin
        case(alphabet_order)
            3'd0: display_code = 25'b01111_10001_10011_10000_01111; // "G"
            3'd1: display_code = 25'b10001_11111_10001_01010_00100; // "A"
            3'd2: display_code = 25'b10001_10001_10101_11011_10001; // "M"
            3'd3: display_code = 25'b11111_10000_11100_10000_11111; // "E"
            3'd4: display_code = 25'b01110_10001_10001_10001_01110; // "O"
            3'd5: display_code = 25'b00100_01010_10001_10001_10001; // "V"
            3'd6: display_code = 25'b10001_10001_11110_10001_11110; // "R"
        endcase
    end

endmodule