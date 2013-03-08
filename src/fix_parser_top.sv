/**
 * @filename		fix_parser_top.sv 
 *
 * @brief     	        Top level: instantiation of other modules. 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com>
 *
 * @dependencies	fix_parser_out_module.sv fix, cam_cntrl.sv, message_loc_cntrl.sv, read_message_cntrl.sv
 */

module fix_parser_top # (parameter NUM_MESSAGE = 10, ADDR_WIDTH = 5) (

	input				clk,
	input				rst,

	input[7:0]			data_i,

	input[31:0]			find_tag_i,
	input[NUM_MESSAGE-1 :0] 	message_num_i,
	input				read_message_i,


	output[255:0]			output_value_o,
	output				output_value_valid_o,
	output				start_of_header_o,
	output				full_o,
	output				empty_o,

	output[7:0]			checksum_o

);

wire[7:0]		data;
wire			tag_s;
wire			value_s;

wire			t_wr_cs; 		   
wire			t_wr_en; 		   
wire			v_wr_cs;		   
wire			v_wr_en; 
wire[31:0]		tag;
wire[255:0]		value;

wire[2:0]		soh_t;
wire[2:0]		sep_t;
wire 			tag_status_t_1;
wire			body_status_t_1;
wire 			tag_status_t_2;
wire			body_status_t_2;

wire[5-1:0] 		start_addr;
wire[5-1:0] 		end_addr;
wire			store_start;
wire			store_end;
wire			full;

wire			start_message;
wire			end_message;

wire			search_tag;
wire			read_message_loc;
wire			read_start_addr_loc;
wire			read_end_addr_loc;	
wire			tag_match;
wire[ADDR_WIDTH-1:0]	matched_index;

wire[ADDR_WIDTH-1:0]	read_start_index_loc;
wire[ADDR_WIDTH-1:0]	read_end_index_loc;


fix_parser parser(
		.clk,
		.rst,
		.data_i,
		
		.data_o(data),
		.tag_s_o(tag_s),
		.value_s_o(value_s)
);

fix_parser_out_module out_module(

		.clk,
		.rst,
		.data_i(data),
		.start_tag_i(tag_s),
		.start_value_i(value_s),
		
		.t_wr_cs_o (t_wr_cs),
		.t_wr_en_o (t_wr_en),
		.v_wr_cs_o (v_wr_cs),
		.v_wr_en_o (v_wr_en),
		.tag_o 	   (tag),
		.value_o   (value),

		.end_of_body_o (end_message),
		.start_of_header_o,
		.start_message_o (start_message)
);

cam_cntrl #(.DATA_WIDTH (32), .ADDR_WIDTH (5)) tag_cam (

		.clk,
		.rst,
			
		.wr_cs_i (t_wr_cs),
		.data_i(tag),
		.wr_en_i(t_wr_en),
		.start_message_i(start_message),	
		.end_message_i(end_message),	

		.find_tag_i,
		.search_tag_i (search_tag),
		.start_index_i(read_start_index_loc),
		.end_index_i(read_end_index_loc),

		.start_addr_o(start_addr),
		.end_addr_o(end_addr),
		.store_start_o(store_start),
		.store_end_o(store_end),
		.tag_match_o (tag_match),
		.index_value_o(matched_index),
		.full_o(full)
		);

message_loc_cntrl #(.NUM_MESSAGE(10), .DATA_WIDTH(5)) message_locator_controller (

		.clk,
		.rst,

		.end_message_i (end_message),
		.start_message_i(start_message),

		.start_addr_i(start_addr),
		.end_addr_i(end_addr),

		.full_i(full),

		.re_i (read_message_loc),
		.read_start_i(read_start_addr_loc),
		.read_end_i (read_end_addr_loc),

		.read_index_i ( message_num_i ),
	
		.start_o (read_start_index_loc),
		.end_o(read_end_index_loc)

);

read_message_cntrl #(.TAG_WIDTH(32), .NUM_MESSAGE(10)) read_received_msg (

		.clk,
		.rst,

		.read_message_i,

		.search_tag_o(search_tag),
		.read_message_loc_o(read_message_loc),
		.read_start_addr_loc_o (read_start_addr_loc),
		.read_end_addr_loc_o (read_end_addr_loc)

);

value_ram #(.DATA_WIDTH (256), .ADDR_WIDTH (5)) value_ram (
	
		.clk (clk), 		
		.rst (rst), 
		
		.address_rd_i(matched_index),
		.data_i (value),
	//	.cs_i (v_wr_cs),
		.we_i (v_wr_en),	
		.oe_i (search_tag),
		
		.data_out_valid(output_value_valid_o),
		.data_o (output_value_o)
); 


checksum  checksum_calc (
	
		.clk (clk), 		
		.rst (rst), 
	
		.data_i,
		.start_i (start_message),
		.end_i(end_message),
		.checksum_o	

); 

endmodule
