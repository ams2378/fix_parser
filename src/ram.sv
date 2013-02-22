
module ram # (parameter ADDR_WIDTH = 8, DATA_0_WIDTH = 32 ) (
	input 				clk       , 		// Clock Input
	input[ADDR_WIDTH-1 : 0]		address_0 , 		// address_0 Input
	input[DATA_0_WIDTH-1:0]		data_0    , 		// data_0 bi-directional
	input				cs_0      , 		// Chip Select
	input				we_0      , 		// Write Enable/Read Enable
	input				oe_0      , 		// Output Enable

	inout[ADDR_WIDTH-1:0]		address_1 , 		// address_1 Input
	inout[DATA_0_WIDTH-1:0]		data_1    , 		// data_1 bi-directional
	input				cs_1      , 		// Chip Select
	input				we_1      , 		// Write Enable/Read Enable
	input				oe_1        		// Output Enable
); 

parameter RAM_DEPTH = 1 << ADDR_WIDTH;

logic [DATA_0_WIDTH-1:0] 		data_0_out ; 
logic [DATA_0_WIDTH-1:0] 		data_1_out ;
logic [DATA_0_WIDTH-1:0] 		mem [0:RAM_DEPTH-1];


/* PORT # 1	*/
/* Memory Write Block */
 
always_ff @ (posedge clk) begin
  if ( cs_0 && we_0 ) begin
     mem[address_0] <= data_0;
  end else if (cs_1 && we_1) begin 
     mem[address_1] <= data_1;
  end
end

/* Memory Read Block  */

always_ff @ (posedge clk) begin
  if (cs_0 && !we_0 && oe_0) begin
    data_0_out <= mem[address_0]; 
  end else begin
    data_0_out <= 0; 
  end  
end 

if ( cs_0 && !we_0 && oe_0)	assign	data_0 = data_0_out;

//assign data_0 = (cs_0 && oe_0 && !we_0) ? data_0_out : 8'bz; 

/* PORT # 2	*/

always_ff @ (posedge clk) begin
  if (cs_1 && !we_1 && oe_1) begin
    data_1_out <= mem[address_1]; 
  end else begin
    data_1_out <= 0;
  end
end

assign data_1 = (cs_1 && oe_1 && !we_1) ? data_1_out : 8'bz; 

endmodule 
