
`include "defines.vh"

module hostaddress # (parameter ADDR_WIDTH = `HOST_ADDR_WIDTH, DATA_WIDTH = `VALUE_DATA_WIDTH + `VALUE_SIZE + 1, SIZE = 6)
	(
		input [DATA_WIDTH-1:0] data,
		input [ADDR_WIDTH-1:0] addr,
		input we, clk,
		output [SIZE-1:0]	host_size,
		output [DATA_WIDTH-1:0] q
	);

	parameter RAM_DEPTH = 1 << ADDR_WIDTH;

	reg [DATA_WIDTH-1:0] ram[RAM_DEPTH-1:0];
	reg [SIZE-1:0] 	     ram_s[RAM_DEPTH-1:0];
	
	reg [ADDR_WIDTH-1:0] addr_reg;

	initial begin
		ram[0][`VALUE_DATA_WIDTH-1:0]	= 80'h686374616d726564726f;	
//		ram[1][`VALUE_DATA_WIDTH-1:0]	= 80'h686374616d;	
		ram[1][`VALUE_DATA_WIDTH-1:0]	= 80'h484354414d524544524f;	
		ram[2][`VALUE_DATA_WIDTH-1:0]	= 80'h6f726465726d61746368;	
		ram[3][`VALUE_DATA_WIDTH-1:0]	= 80'h6f726465726d61746368;


		ram[0][DATA_WIDTH-2: `VALUE_DATA_WIDTH]	= 10'b1111111111;	
//		ram[1][DATA_WIDTH-2: `VALUE_DATA_WIDTH]	= 10'b0000011111;	
		ram[1][DATA_WIDTH-2: `VALUE_DATA_WIDTH]	= 10'b1111111111;	
		ram[2][DATA_WIDTH-2: `VALUE_DATA_WIDTH]	= 10'b1111111111;	
		ram[3][DATA_WIDTH-2: `VALUE_DATA_WIDTH]	= 10'b1111111111;

		ram[0][DATA_WIDTH-1]	= 1'b0;			// 1 - initiator	
		ram[1][DATA_WIDTH-1]	= 1'b1;			// 0 - acceptor
		ram[2][DATA_WIDTH-1]	= 1'b1;	
		ram[3][DATA_WIDTH-1]	= 1'b1;

		ram_s[0][SIZE-1:0]	= 6'd10;	
		ram_s[1][SIZE-1:0]	= 6'd5;	
		ram_s[2][SIZE-1:0]	= 6'd10;	
		ram_s[3][SIZE-1:0]	= 6'd10;
	end

	
	always @ (posedge clk)
	begin
		if (we)
			ram[addr] <= data;
		
		addr_reg <= addr;
	end
		
	assign q = ram[addr_reg];
	assign host_size = ram_s[addr];
	
endmodule
