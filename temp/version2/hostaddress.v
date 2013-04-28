
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
		ram[0]	= 80'h6f726465726d61746368;	
		ram[1]	= 80'h6f726465726d61746368;	
		ram[2]	= 80'h6f726465726d61746368;	
		ram[3]	= 80'h6f726465726d61746368;	
	end

	
	always @ (posedge clk)
	begin
		if (we)
			ram[addr] <= data;
		
		addr_reg <= addr;
	end
		
	assign q = ram[addr_reg];
	
endmodule
