
`include "defines.vh"

module hostaddress # (parameter ADDR_WIDTH = `HOST_ADDR_WIDTH, DATA_WIDTH = `VALUE_DATA_WIDTH + `VALUE_SIZE)
	(
		input [DATA_WIDTH-1:0] data,
		input [ADDR_WIDTH-1:0] addr,
		input we, clk,
		output [DATA_WIDTH-1:0] q
	);

	parameter RAM_DEPTH = 1 << ADDR_WIDTH;

	reg [DATA_WIDTH-1:0] ram[RAM_DEPTH-1:0];
	
	reg [ADDR_WIDTH-1:0] addr_reg;

	initial begin
		ram[0][`VALUE_DATA_WIDTH-1:0]	= 80'h6f726465726d61746368;	
		ram[1][`VALUE_DATA_WIDTH-1:0]	= 80'h63686f726465726d6174;	
		ram[2][`VALUE_DATA_WIDTH-1:0]	= 80'h6f726465726d61746368;	
		ram[3][`VALUE_DATA_WIDTH-1:0]	= 80'h6f726465726d61746368;

		ram[0][DATA_WIDTH-1: `VALUE_DATA_WIDTH]	= 10'b1111111111;	
		ram[1][DATA_WIDTH-1: `VALUE_DATA_WIDTH]	= 10'b1111111111;	
		ram[2][DATA_WIDTH-1: `VALUE_DATA_WIDTH]	= 10'b1111111111;	
		ram[3][DATA_WIDTH-1: `VALUE_DATA_WIDTH]	= 10'b1111111111;
	end

	
	always @ (posedge clk)
	begin
		if (we)
			ram[addr] <= data;
		
		addr_reg <= addr;
	end
		
	assign q = ram[addr_reg];
	
endmodule
