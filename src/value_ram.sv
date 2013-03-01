
module value_ram # (parameter ADDR_WIDTH = 5, DATA_0_WIDTH = 256 ) (
	input 				clk       , 		// Clock Input
	input[ADDR_WIDTH-1 : 0]		address_i , 		// address_0 Input
	input[DATA_0_WIDTH-1:0]		data_i    , 		// data_0 bi-directional
	input				cs_i      , 		// Chip Select
	input				we_i      , 		// Write Enable/Read Enable
	input				oe_i      , 		// Output Enable

	output [DATA_0_WIDTH-1 : 0]     data_o
); 

parameter RAM_DEPTH = 1 << ADDR_WIDTH;

logic [DATA_0_WIDTH-1:0] 		data_out ; 
logic [DATA_0_WIDTH-1:0] 		mem [0:RAM_DEPTH-1];


/* Memory Write Block */
 
always_ff @ (posedge clk) begin
  if ( cs_i && we_i ) begin
     mem[address_i] <= data_i;
  end 
end

/* Memory Read Block  */

always_ff @ (posedge clk) begin
  if (cs_i && !we_i && oe_i) begin
    data_out <= mem[address_0]; 
  end else begin
    data_out <= 0; 
  end  
end 

assign data_o 	=	data_out;

endmodule 
