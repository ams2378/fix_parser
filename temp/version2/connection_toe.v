
`include "defines.vh"

module connection_toe #(parameter HOST_ADDR = `HOST_ADDR_WIDTH) (
	
		input				clk,
		input				rst,
		input				connect_i,			// from api 
		input[HOST_ADDR-1:0]		connect_addr_i,			// from api
//		input				connect_status_i,		// from toe
//		input[HOST_ADDR-1:0]		connect_status_addr_i,		// from toe		

		output reg			connect_o,
		output reg [HOST_ADDR-1:0]	connect_host_addr_o
		);


always @ (posedge clk) begin
	
	if (rst) begin
		connect_o		<= '0;
		connect_host_addr_o 	<= '0;
	end else begin
		connect_o		<= connect_i;
		connect_host_addr_o 	<= connect_addr_i;
	end
end

endmodule
