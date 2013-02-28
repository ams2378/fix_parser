
module cam_cntrl #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 5) (
	input				clk      , 		// Clock input
	input				rst      , 		// Active high reset

	input				wr_cs_i    , 		// Write chip select
	input[DATA_WIDTH-1:0]		data_i  , 		// Data input
	input				wr_en_i     		// Write Enable

//	output[ADDR_WIDTH-1:0] 		wr_pointer_o,
//	output[ADDR_WIDTH-1:0] 		rd_pointer_o,
//	output[ADDR_WIDTH-1:0] 		status_cnt_o,
//	output[DATA_WIDTH-1:0] 		data_out_o 
);    
 
parameter CAM_DEPTH = (1 << ADDR_WIDTH);

logic [ADDR_WIDTH-1:0] 			wr_pointer;

/* write pointer */

always_ff @ (posedge clk or posedge rst) begin
  if (rst) begin
    wr_pointer <= 0;
  end else if (wr_cs_i && wr_en_i ) begin
    wr_pointer <= wr_pointer + 1;
  end
end


cam #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) (
		.clk,
		.rst,

		.start_i(0),
		.end_i(5'b11111),

		.write_i(wr_en_i),
		.write_index_i(wr_pointer),
		.write_data_i(data_i),

		.search_i(0),
		.search_data_i('0)

//		.search_valid_o()
//		.search_index_o
		);


//assign wr_pointer_o = wr_pointer;
//assign rd_pointer_o = rd_pointer;
//assign status_cnt_o = status_cnt;
//asign data_out_o   = data_out; 

endmodule

