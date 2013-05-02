
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


//		connected_o		<= '0;
		connect_o		<= '0;
	
	if (rst) begin
		connect_o		<= '0;
		connect_host_addr_o 	<= '0;
	end 

//	if (connect_status_i == 1) begin
//		connected_i		<=	1;
//	end

		connect_o		<= connect_i;
		connect_host_addr_o 	<= connect_addr_i;
end

endmodule
