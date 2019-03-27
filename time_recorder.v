module time_recorder(
    input clk,
    input resetn,
    input enable,
    output reg [15:0] time_value
);

always@(posedge clk) begin
    if (!resetn)
        time_value <= 16'd0;
    else if (enable) begin
        if (time_value[3:0] == 4'd9) begin
            time_value[3:0] <= 4'd0;
            time_value[7:4] <= time_value[7:4] + 4'd1;
        end
        else
            time_value[3:0] <= time_value[3:0] + 4'd1;

        if (time_value[7:4] == 4'd5 && time_value[3:0] == 4'd9) begin
            time_value[7:4] <= 4'd0;
            time_value[3:0] <= 4'd0;
            time_value[11:8] <= time_value[11:8] + 4'd1;
        end

        if (time_value[11:8] == 4'd10) begin
            time_value[11:8] <= 4'd0;
            time_value[15:12] <= time_value[15:12] + 4'd1;
        end

        if (time_value[15:12] == 4'd5 && time_value[11:8] == 4'd9) begin
            time_value[15:12] <= 4'd0;
            time_value[11:8] <= 4'd0;
        end
    end
    else
        time_value[15:0] <= 16'd0;

end

endmodule