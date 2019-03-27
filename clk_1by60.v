// all the control clocks
module clk_1by60 (clk, resetn, enable, delayed_clk0);
    input clk, resetn, enable;
    output delayed_clk0;
    reg [19:0]delay_counter;

    assign delayed_clk0 = (delay_counter == 20'd833333);
    always@(posedge clk) begin
        if (!resetn)
            delay_counter <= 20'd0;
        else if (enable) begin
            delay_counter <= delay_counter + 1'd1;
            if (delay_counter == 20'd833333)
                delay_counter <= 20'd0;
        end
        else
            delay_counter <= 20'd0;
    end
endmodule

module clk_1sec (clk, resetn, delayed_clk1);
    input clk, resetn;
    output delayed_clk1;
    reg [25:0] delay_counter;

    assign delayed_clk1 = (delay_counter == 26'd49999999);
    always@(posedge clk) begin
        if (!resetn)
            delay_counter <= 26'd0;
        else if (delay_counter == 26'd49999999)
            delay_counter <= 26'd0;
        else
            delay_counter <= delay_counter + 1'd1;
    end
endmodule

module clk_quater_sec (clk, resetn, enable, delayed_clk2);
    input clk, resetn, enable;
    output delayed_clk2;
    reg [23:0] delay_counter;

    assign delayed_clk2 = (delay_counter == 24'd12499999);
    always@(posedge clk) begin
        if (!resetn)
            delay_counter <= 24'd0;
        else if (enable) begin
            delay_counter <= 24'd0 + 1'd1;
            if (delay_counter == 24'd12499999)
                delay_counter <= 24'd0;
        end
    end
endmodule