/*-----------------------------------------------------
Design Name : CAM
File Name   : camreg.v
Function    : Instantiate FF to construct memory module
*///-----------------------------------------------------

module camreg #(parameter ADDR_WIDTH = 5, DATA_WIDTH = 32) (
	input clk,
	input rst,

	input write_i,
	input [ADDR_WIDTH-1:0] write_addr_i,
	input [DATA_WIDTH-1:0] write_data_i,

	input search_i,
	input [DATA_WIDTH-1:0] search_data_i,
	output [(1 << ADDR_WIDTH) -1:0] match_o
	);

parameter CAM_DEPTH = (1 << ADDR_WIDTH);

generate
	for (genvar iter = 0; iter < CAM_DEPTH ; iter++) begin
		FF #(.WIDTH(32)) array
			(.clk,
			 .rst,

			 .writeEn_i (write_addr_i[iter] & write_i),
			 .writedat_i (write_data_i),

			 .search_i,
			 .searchn_i (search_data_i),

			 .match_o (match_o[iter]) // set match output MSB to LSB for priority encoder
			);
	end
endgenerate

endmodule
