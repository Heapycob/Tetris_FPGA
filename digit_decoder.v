module digit_decoder(
    input [3:0] number,
    output reg [20:0] display_code
);
    always@(*) begin
        case(number)
            4'd0: display_code <= 21'b111_101_101_101_101_101_111;  // "0"
            4'd1: display_code <= 21'b001_001_001_001_001_001_001;  // "1"
            4'd2: display_code <= 21'b111_100_100_111_001_001_111;  // "2"
            4'd3: display_code <= 21'b111_001_001_111_001_001_111;  // "3"
            4'd4: display_code <= 21'b001_001_001_111_101_101_101;  // "4"
            4'd5: display_code <= 21'b111_001_001_111_100_100_111;  // "5"
            4'd6: display_code <= 21'b111_101_101_111_100_100_111;  // "6"
            4'd7: display_code <= 21'b001_001_001_001_001_001_111;  // "7"
            4'd8: display_code <= 21'b111_101_101_111_101_101_111;  // "8"
            4'd9: display_code <= 21'b001_001_001_111_101_101_111;  // "9"
            default: display_code <= 21'b111_101_101_101_101_101_111; // "0"
        endcase
    end

endmodule