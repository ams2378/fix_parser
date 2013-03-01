/**
 * @filename		fix_parser_top.sv 
 *
 * @brief     	        Top level: instantiation of other modules. 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com>
 *
 * @dependencies	
 */

module fix_parser_top (

	input			clk,
	input			rst,
	input[7:0]		data_i,

//	output			end_of_body_o,
	output			start_of_header_o,
//	output			start_message_o,
	output			empty_o,
	output			full_o
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

		.start_addr_o(start_addr),
		.end_addr_o(end_addr),
		.store_start_o(store_start),
		.store_end_o(store_end),
		.full_o(full)
		);


message_loc_cntrl #(.NUM_MESSAGE(10), .DATA_WIDTH(5)) (

		.clk,
		.rst,

		.end_message_i (end_message),
		.start_message_i(start_message),

		.start_addr_i(start_addr),
		.end_addr_i(end_addr)
);

value_ram #(.DATA_WIDTH (256), .ADDR_WIDTH (5)) value_ram (
	
		.clk (clk)     		, 		
		.rst (rst)     		, 
		
	//	.address_rd_i ()	,
		.data_i (value)		,
		.cs_i (v_wr_cs)		,
		.we_i (v_wr_en)		
	//	.oe_i ()		,
		
	//	.data_o ()
		
    		
); 
/*
value_fifo_top #(.DATA_WIDTH (256), .ADDR_WIDTH (8)) value_fifo (
	
		.clk (clk)     		, 		
		.rst (rst)     		, 		
		.wr_cs_i (v_wr_cs)    	, 		
		.rd_cs_i (1'b0)    	,	 		
		.data_i  (value)  	, 	// input value		
		.rd_en_i (1'b0)    	, 		
		.wr_en_i (v_wr_en)   	, 		

		.empty_o  		, 		
		.full_o       		
); 
*/

/*
tag_fifo_top #(.DATA_WIDTH (32), .ADDR_WIDTH (8)) tag_fifo (
	
		.clk (clk)     		, 		
		.rst (rst)     		, 		
		.wr_cs_i (t_wr_cs)    	, 		
		.rd_cs_i (1'b0)    	,	 		
		.data_i  (tag)  	, 	// input tag		
		.rd_en_i (1'b0)    	, 		
		.wr_en_i (t_wr_en)   	, 		

		.empty_o  		, 		
		.full_o       		
); 
*/


endmodule
