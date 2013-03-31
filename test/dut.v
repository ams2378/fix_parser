module dut (
  input wire clk,enable,
  input wire  reset;
  input wire  start;
  input wire  configure;
  input wire [7:0] din,
  output reg [7:0] dout,
  output reg       valid
);

always @ (posedge clk)
  begin
    dout  <= din;
    valid  <= enable;
  end

endmodule
             
