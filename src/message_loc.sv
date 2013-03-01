/**
 * @filename		message_loc.sv 
 *
 * @brief     	        memory modules to store start and end index of each tag in the tag_cam 
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	ram/FF2.sv ram/decoder2.sv ram/ramreg.sv	
 */

module message_loc #(parameter DATA_WIDTH = 5, NUM_MESSAGE = 10) (

	input					clk,
	input					rst,

	input [DATA_WIDTH-1 : 0]		start_i,
	input [DATA_WIDTH-1 : 0]		end_i,
	input					store_start_i,
	input					store_end_i,
	input [NUM_MESSAGE-1 : 0]		addr_i,
	input					re_i,
	input					read_start_i,
	input					read_end_i,

	input [NUM_MESSAGE-1 : 0]		read_index_i,


	output [DATA_WIDTH-1 : 0]		start_o,
	output [DATA_WIDTH-1 : 0]		end_o
);

logic [  DATA_WIDTH -1:0] 		mem_start [0:NUM_MESSAGE-1];
logic [  DATA_WIDTH -1:0] 		mem_end [0:NUM_MESSAGE-1];

logic [DATA_WIDTH-1 : 0]		start;
logic [DATA_WIDTH-1 : 0]		endd;


ram #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(NUM_MESSAGE)) start_locator_ram (

	.clk,
	.rst,

	.read_i(re_i & read_start_i ),
	.read_index_i,

	.write_i(store_start_i),
	.write_index_i(addr_i),
	.write_data_i(start_i),
//	.read_valid_o(data_out_valid),
	.read_value_o(start)
);

ram #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(NUM_MESSAGE)) end_locator_ram (

	.clk,
	.rst,

	.read_i(re_i & read_end_i),
	.read_index_i,

	.write_i(store_end_i),
	.write_index_i(addr_i),
	.write_data_i(end_i),
//	.read_valid_o(data_out_valid),
	.read_value_o(endd)
);

assign start_o = start;
assign end_o = endd;



endmodule


