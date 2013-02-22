/**
 * @filename		fix_parser_top.sv 
 *
 * @brief     	        Top level: instantiation of other modules. 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 */


module fix_parser_top (


	input			clk,
	input			rst,
	input[7:0]		data_i,

/*
	output			t_wr_cs_o, 		   
	output			t_wr_en_o, 		   
 	output			v_wr_cs_o, 		   
	output			v_wr_en_o, 
	output[31:0]		tag_o,
	output[255:0]		value_o,
*/

	output			end_of_body_o,
	output			start_of_header_o,

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
		.v_wr_en_o (v_wr_cs),
		.tag_o 	   (tag),
		.value_o   (value),

		.end_of_body_o,
		.start_of_header_o
);


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

value_fifo_top #(.DATA_WIDTH (256), .ADDR_WIDTH (8)) value_fifo (
	
		.clk (clk)     		, 		
		.rst (rst)     		, 		
		.wr_cs_i (v_wr_cs)    	, 		
		.rd_cs_i (1'b0)    	,	 		
		.data_i  (value)  	, 	// input tag		
		.rd_en_i (1'b0)    	, 		
		.wr_en_i (v_wr_en)   	, 		

		.empty_o  		, 		
		.full_o       		
); 

endmodule
