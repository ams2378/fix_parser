
module fifo #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 8) (
	input				clk      , 		// Clock input
	input				rst      , 		// Active high reset
	input				wr_cs    , 		// Write chip select
	input 				rd_cs    , 		// Read chipe select
	input[DATA_WIDTH-1:0]		data_in  , 		// Data input
	input				rd_en    , 		// Read enable
	input				wr_en    , 		// Write Enable
	output[DATA_WIDTH-1:0]		data_out , 		// Data Output
	output				empty    , 		// FIFO empty
	output				full       		// FIFO full
);    
 
parameter RAM_DEPTH = (1 << ADDR_WIDTH);

logic [ADDR_WIDTH-1:0] 			wr_pointer;
logic [ADDR_WIDTH-1:0] 			rd_pointer;
logic [ADDR_WIDTH :0] 			status_cnt;
logic [DATA_WIDTH-1:0] 			data_out ;
logic [DATA_WIDTH-1:0] 			data_ram ;

/* write pointer */

always_ff @ (posedge clk or posedge rst) begin
  if (rst) begin
    wr_pointer <= 0;
  end else if (wr_cs && wr_en ) begin
    wr_pointer <= wr_pointer + 1;
  end
end

/* read pointer */

always_ff @ (posedge clk or posedge rst) begin
  if (rst) begin
    rd_pointer <= 0;
  end else if (rd_cs && rd_en ) begin
    rd_pointer <= rd_pointer + 1;
  end
end

/* read data */

always_ff  @ (posedge clk or posedge rst) begin
  if (rst) begin
    data_out <= 0;
  end else if (rd_cs && rd_en ) begin
    data_out <= data_ram;
  end
end

/* status pointer */

always_ff @ (posedge clk or posedge rst) begin
  if (rst) begin
    status_cnt <= 0;
  end else if ((rd_cs && rd_en) && !(wr_cs && wr_en) && (status_cnt != 0)) begin
    status_cnt <= status_cnt - 1;
  end else if ((wr_cs && wr_en) && !(rd_cs && rd_en) && (status_cnt != RAM_DEPTH)) begin
    status_cnt <= status_cnt + 1;
  end
end 
   
assign full = (status_cnt == (RAM_DEPTH-1));
assign empty = (status_cnt == 0);

ram #(DATA_WIDTH,ADDR_WIDTH) FIFO_RAM (
	.address_0 (wr_pointer) , 		 
	.data_0    (data_in)    , 		
	.cs_0      (wr_cs)      , 
	.we_0      (wr_en)      , 
	.oe_0      (1'b0)       , 
	.address_1 (rd_pointer) , 
	.data_1    (data_ram)   , 
	.cs_1      (rd_cs)      , 
	.we_1      (1'b0)       , 
	.oe_1      (rd_en)        
);     

endmodule
