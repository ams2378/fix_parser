
module fifo #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 8) (
	input				clk      , 		// Clock input
	input				rst      , 		// Active high reset
	input				wr_cs_i    , 		// Write chip select
	input 				rd_cs_i    , 		// Read chipe select
	input[DATA_WIDTH-1:0]		data_i  , 		// Data input
	input				rd_en_i    , 		// Read enable
	input				wr_en_i    , 		// Write Enable
	input[DATA_WIDTH-1:0] 		data_ram_i , 

	output[ADDR_WIDTH-1:0] 		wr_pointer_o,
	output[ADDR_WIDTH-1:0] 		rd_pointer_o,
	output[ADDR_WIDTH-1:0] 		status_cnt_o,
	output[DATA_WIDTH-1:0] 		data_out_o 
);    
 
parameter RAM_DEPTH = (1 << ADDR_WIDTH);

logic [ADDR_WIDTH-1:0] 			wr_pointer;
logic [ADDR_WIDTH-1:0] 			rd_pointer;
logic [ADDR_WIDTH-1:0] 			status_cnt;
logic [DATA_WIDTH-1:0] 			data_out ;
logic [DATA_WIDTH-1:0] 			data_ram ;

/* write pointer */

always_ff @ (posedge clk or posedge rst) begin
  if (rst) begin
    wr_pointer <= 0;
  end else if (wr_cs_i && wr_en_i ) begin
    wr_pointer <= wr_pointer + 1;
  end
end

/* read pointer */

always_ff @ (posedge clk or posedge rst) begin
  if (rst) begin
    rd_pointer <= 0;
  end else if (rd_cs_i && rd_en_i ) begin
    rd_pointer <= rd_pointer + 1;
  end
end

/* read data */

always_ff  @ (posedge clk or posedge rst) begin
  if (rst) begin
    data_out <= 0;
  end else if (rd_cs_i && rd_en_i ) begin
    data_out <= data_ram;
  end
end

/* status pointer */

always_ff @ (posedge clk or posedge rst) begin
  if (rst) begin
    status_cnt <= 0;
  end else if ((rd_cs_i && rd_en_i) && !(wr_cs_i && wr_en_i) && (status_cnt != 0)) begin
    status_cnt <= status_cnt - 1;
  end else if ((wr_cs_i && wr_en_i) && !(rd_cs_i && rd_en_i) && (status_cnt != RAM_DEPTH)) begin
    status_cnt <= status_cnt + 1;
  end
end 
   
assign wr_pointer_o = wr_pointer;
assign rd_pointer_o = rd_pointer;
assign status_cnt_o = status_cnt;
assign data_out_o   = data_out; 

endmodule
