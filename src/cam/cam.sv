/*-----------------------------------------------------
Design Name : CAM
File Name   : cam.sv
Function    : Top level file which instantiate every other modules and represents overall microarchitecture
*///-----------------------------------------------------

module cam #(parameter DATA_WIDTH = 32, CAM_DEPTH = 32, ADDR_WIDTH = 5 ) (
	input clk,
	input rst,


	input [ADDR_WIDTH-1:0] start_i,
	input [ADDR_WIDTH-1:0] end_i,
	input write_i,
	input [ADDR_WIDTH-1:0] write_index_i,
	input [DATA_WIDTH-1:0] write_data_i,

	input search_i,
	input [DATA_WIDTH-1:0] search_data_i,

	output search_valid_o,
	output [ADDR_WIDTH-1:0] search_index_o
	);

wire [ADDR_WIDTH-1:0] write_addr;
wire [ADDR_WIDTH-1:0] match_addr;

/*
 * instantiate the write decoder
 */
decoder write_decoder (
	.decoder_i (write_index_i),
	.decoder_o (write_addr)
	);

/*
 * instantiate the memory arrays
 */
camreg #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH), .CAM_DEPTH(CAM_DEPTH) ) mem_array (
	.clk,
	.rst,

	.write_i,
	.write_addr_i (write_addr),
	.write_data_i,
	
	.search_i,
	.search_data_i,

	.match_o (match_addr)
	);

/*
 * instantiate the priority encoder
 */
priorityencoder #(.MEM_DEPTH(CAM_DEPTH), .INDEX_WIDTH(ADDR_WIDTH)) match_encode (
	.inp_i (match_addr),
	.start_i,
	.end_i,
	.out_o (search_index_o),
	.valid_o (search_valid_o)
	);

endmodule
