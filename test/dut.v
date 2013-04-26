`timescale 1 ns / 100 ps

module dut (
  input wire  		clk,
  input wire  		reset,
  input wire  		configure_i,
  input wire  		connect_i,
  input wire  		connected_i,
  input wire[5:0] 	connected_host_addr_i,
  input wire  		new_message_i,
  input wire[7:0]  	message_i,

  output reg		connect_req_o,
  output reg[5:0]  	connect_host_addr_o,
  output reg		send_message_o,
  output reg[7:0]	message_o
);

always @ (posedge clk)
  begin
    message_o  <= message_i;
//    valid  <= enable;
  end

endmodule
