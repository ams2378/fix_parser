/**
 * @filename		fifo_top.sv 
 *
 * @brief     	        Top level file for FIFO. RAM and unit FIFO module is instantiated.	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 */


module tag_fifo_top #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 8) (
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


parameter RAM_DEPTH = (1 << ADDR_WIDTH);


wire [ADDR_WIDTH-1:0] 			address_0_ram;
wire [ADDR_WIDTH-1:0] 			address_1_ram;
wire [DATA_WIDTH-1:0] 			data_ram_t;
wire [ADDR_WIDTH-1:0] 			status_cnt;
wire					empty, full;

ram #( .ADDR_WIDTH(8), .DATA_WIDTH(32)) FIFO_RAM (
	.address_0 (address_0_ram) ,  
	.data_0    (data_i)    , 
	.cs_0      (wr_cs_i)      , 
	.we_0      (wr_en_i)      , 
	.oe_0      (1'b0)       , 
	.address_1 (address_1_ram) , 
	.data_1    (data_ram_t)   ,
	.cs_1      (rd_cs_i)      , 
	.we_1      (1'b0)       , 
	.oe_1      (rd_en_i)        
);   

fifo #( .DATA_WIDTH(32), .ADDR_WIDTH(8)) fifo_1 (

		.clk,
		.rst,
		.wr_cs_i,
		.rd_cs_i,
		.data_i,
		.rd_en_i,
		.wr_en_i,
		.data_ram_i(data_ram_t),

		.wr_pointer_o(address_0_ram),
		.rd_pointer_o(address_1_ram),
		.status_cnt_o(status_cnt),
		.data_out_o(data_o)
);   

assign full_o = (status_cnt == (RAM_DEPTH-1));
assign empty_o = (status_cnt == 0);

endmodule
