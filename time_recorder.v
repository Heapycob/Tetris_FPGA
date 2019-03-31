module time_recorder(
    input clk,
    input resetn,
    input enable,
    output reg [15:0] time_value
);
    reg [25:0] time_counter;
    always@(posedge clk) begin
        if (!resetn) begin
            time_value <= 16'd0;
            time_counter <= 26'd0;
        end
        else if (time_counter == 26'd49999999) begin
            if (enable) begin
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
            else begin
                time_value[15:0] <= 16'd0;
            end
            time_counter <= 26'd0;
        end
        else
            time_counter <= time_counter + 26'd1;

    end
endmodule