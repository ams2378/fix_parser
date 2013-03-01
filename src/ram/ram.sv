/*-----------------------------------------------------
Design Name : CAM
File Name   : cam.sv
Function    : Top level file which instantiate every other modules and represents overall microarchitecture
*///-----------------------------------------------------

module ram   #(parameter DATA_WIDTH = 256, ADDR_WIDTH = 5 ) (
	input clk,
	input rst,

	input read_i,
	input [ADDR_WIDTH-1:0] read_index_i,

	input write_i,
	input [ADDR_WIDTH-1:0] write_index_i,
	input [DATA_WIDTH:0] write_data_i,

	output read_valid_o,
	output [DATA_WIDTH-1:0] read_value_o

	);


parameter CAM_DEPTH = (1 << ADDR_WIDTH);

wire [ CAM_DEPTH -1 :0] read_addr;
wire [CAM_DEPTH -1 :0] write_addr;

wire [DATA_WIDTH*CAM_DEPTH-1:0] read_out;

/*
 * instantiate the read decoder
 */
decoder2 read_decoder (
        .decoder_i (read_index_i),  
        .decoder_o (read_addr)
        );

/*
 * instantiate the write decoder
 */
decoder2 write_decoder (
	.decoder_i (write_index_i),
	.decoder_o (write_addr)
	);

/*
 * instantiate the memory arrays
 */
ramreg mem_array2 (
	.clk,
	.rst,

	.read_i,
	.read_addr_i (read_addr),

	.write_i,
	.write_addr_i (write_addr),
	.write_data_i,

	.read_valid_o,
	.read_out_o (read_out)

	);

/*
 * instantiate the mux
 */
multiplexer mux (
	.data_i (read_out),
	.read_address_i (read_index_i),
	.data_o (read_value_o)
	);


endmodule
