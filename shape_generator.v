// randomly generate 3 bit value from 0 to 7 based on LFSR.
module shape_generator(
    clk,
    resetn,
    shape_id
);

    input clk;
    input resetn;
    output [2:0] shape_id;

    reg [4:0] r;
    reg [4:0] nx_r;
    assign shape_id = r[2:0];
    
    always@(*) begin
        nx_r[4] = r[4]^r[1];
        nx_r[3] = r[3]^r[0];
        nx_r[2] = r[2]^nx_r[4];
        nx_r[1] = r[1]^nx_r[3];
        nx_r[0] = r[0]^nx_r[2];
    end

always @(posedge clk, negedge resetn)
  if(!resetn)
    r <= 5'd31;
  else
    r <= nx_r;

endmodule