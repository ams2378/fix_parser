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

	output			t_wr_cs_o, 		   
	output			t_wr_en_o, 		   
 	output			v_wr_cs_o, 		   
	output			v_wr_en_o, 
	output[31:0]		tag_o,
	output[255:0]		value_o,
	output			end_of_body_o,
	output			start_of_header_o

);


wire[7:0]	data;
wire		tag_s;
wire		value_s;


wire[2:0]	soh_t;
wire[2:0]	sep_t;
wire 		tag_status_t_1;
wire		body_status_t_1;
wire 		tag_status_t_2;
wire		body_status_t_2;


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
		
		.t_wr_cs_o,
		.t_wr_en_o,
		.v_wr_cs_o,
		.v_wr_en_o,
		.tag_o,
		.value_o,
		.end_of_body_o,
		.start_of_header_o
);

endmodule
