module score_recorder(
    input clk,
    input resetn,
    input enable,
    output reg [11:0] score_value
);

always@(posedge clk) begin
    if (!resetn)
        score_value <= 12'd0;
    else if (enable) begin

        if (score_value[3:0] == 4'd9) begin
            score_value[3:0] <= 4'd0;
            score_value[7:4] <= score_value[7:4] + 4'd1;
        end
        else
            score_value[3:0] <= score_value[3:0] + 4'd1;

        if (score_value[7:4] == 4'd10) begin
            score_value[7:4] <= 4'd0;
            score_value[11:8] <= score_value[11:0] + 4'd1;
        end

        if (score_value[11:8] == 4'd10) begin
            score_value[11:8] <= 4'd0;
        end
    end
    else
        score_value[11:0] <= 12'd0;

end

endmodule