
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
	
	always @ (posedge clk)
	begin
		if (we)
			ram[addr] <= data;
		
		addr_reg <= addr;
	end
		
	assign q = ram[addr_reg];
	
endmodule
