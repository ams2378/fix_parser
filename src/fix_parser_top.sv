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
	input[31:0]		data_i,
	
	
//	output[31:0]		tag_o,
//	output[31:0]		value_o,

	output[31:0]		out_o,
	output[3:0] 		tag_valid_o,
	output[3:0] 		value_valid_o

);


wire[2:0]	soh_t;
wire[2:0]	sep_t;
wire 		tag_status_t_1;
wire		body_status_t_1;
wire 		tag_status_t_2;
wire		body_status_t_2;


fix_parser module_1(

		.clk,
		.rst,
		.data_i,
		.tag_status_i(tag_status_t_1),
		.body_status_i(body_status_t_1),
		
		.soh_o(soh_t),
		.sep_o(sep_t),
		.tag_status_o(tag_status_t_2),
		.body_status_o(body_status_t_2)
);


fix_parser_out_module module_2(

		.data_i,
		.soh_i(soh_t),
		.sep_i(sep_t),
		.tag_status_i(tag_status_t_2),
		.value_status_i(body_status_t_2),
		
//		.tag_o,
		.out_o,
		.tag_status_o(tag_status_t_1),
		.value_status_o(body_status_t_1),
		.tag_valid_o,
		.value_valid_o

);

endmodule

