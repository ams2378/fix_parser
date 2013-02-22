

module fix_parser_tag_fifo (

	input				clk,
	input				rst,
	input				wr_cs_i, 		   
	input				wr_en_i, 		   
 	input				wr_cs_i, 		   
	input				wr_en_i, 	
	input[31:0]			tag_o

);



fix_parser_out_module tag_parser (

	





)


fifo_top #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 8) tag_fifo (
	input				clk      , 		
	input				rst      , 		
	input				wr_cs_i    , 		
	input 				rd_cs_i    , 		
	input[DATA_WIDTH-1:0]		data_i  , 		
	input				rd_en_i    , 		
	input				wr_en_i    , 		

	output[DATA_WIDTH-1:0]		data_o   , 		
	output				empty_o  , 		
	output				full_o       		
); 


