
`include "defines.vh"

module connection_toe #(parameter HOST_ADDR = `HOST_ADDR_WIDTH) (
	
		input				clk,
		input				rst,
		input				connect_i,		// from api 
		input[HOST_ADDR-1:0]		connect_addr_i,		// from api
		input				connect_status_i,	// from toe
		input[HOST_ADDR-1:0]		connected_addr_i,	// from toe		


		output reg			connected_o,
		output reg [HOST_ADDR-1:0]	connected_host_addr_o
		);


always @ (posedge clk) begin
	
	if (rst) begin
		connected_o		<= '0;
		connected_host_addr_o 	<= '0;
	end else begin
		connected	




	end



end


