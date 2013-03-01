

module message_loc #(parameter DATA_WIDTH = 5, NUM_MESSAGE = 10) (

	input					clk,
	input					rst,

	input [DATA_WIDTH-1 : 0]		start_i,
	input [DATA_WIDTH-1 : 0]		end_i,
	input					store_start_i,
	input					store_end_i,
	input [NUM_MESSAGE-1 : 0]		addr_i,
	input					re_i,
	input					read_start_i,
	input					read_end_i,

	output [DATA_WIDTH-1 : 0]		start_o,
	output [DATA_WIDTH-1 : 0]		end_o

);

logic [  DATA_WIDTH -1:0] 		mem_start [0:NUM_MESSAGE-1];
logic [  DATA_WIDTH -1:0] 		mem_end [0:NUM_MESSAGE-1];

logic [DATA_WIDTH-1 : 0]		start;
logic [DATA_WIDTH-1 : 0]		endd;

/* Memory Write Block */
 
always_ff @ (posedge clk) begin
  if ( store_start_i ) begin
     mem_start[addr_i] <= start_i;
  end else if ( store_end_i) begin 
     mem_end[addr_i] <= end_i;
  end
end

/* Memory Read Block  */

always_ff @ (posedge clk) begin
  if (re_i && read_start_i && !read_end_i) begin
    start <= mem_start[addr_i]; 
  end else if (re_i && read_end_i && !read_start_i) begin
    endd <= mem_end[addr_i]; 
  end  else if (re_i && read_end_i && read_start_i) begin
     endd <= mem_end[addr_i];    
     start <= mem_start[addr_i]; 
  end  
end 

assign start_o = start;
assign end_o = endd;

endmodule