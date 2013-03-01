/*-----------------------------------------------------
Design Name : CAM
File Name   : FF.sv
Function    : Flip flop- modified from basic definition to support matching functionality
*///-----------------------------------------------------

module FF #(parameter WIDTH = 1) (
	input clk,
	input rst,
	
	input writeEn_i,
	input search_i,

	input [WIDTH-1:0] writedat_i,
	input [WIDTH-1:0] searchn_i,

	output match_o
);

reg [WIDTH-1:0] data;
reg match;

/*
 * the write block
 */
always_comb begin
	if (rst)
		data <= '0;
	else if (writeEn_i )
		data <= writedat_i;
	else
		data <=data;		// keep writing the data back
end

/*
 * equality checking block
 */
always_comb begin
	if (search_i) begin
		if (data == searchn_i)
			match <= '1;
		else
			match <= '0;
	end
	else
		match <= '0;
end

assign match_o = match;

endmodule
