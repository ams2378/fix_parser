
module value_ram # (parameter ADDR_WIDTH = 5, DATA_WIDTH = 256 ) (
	input 				clk       	, 		// Clock Input
	input				rst		,
	input[ADDR_WIDTH-1 : 0]		address_rd_i 	, 		// address_0 Input
	input[DATA_WIDTH-1:0]		data_i    	, 		// data_0 bi-directional
//	input				cs_i      	, 		// Chip Select
	input				we_i      	, 		// Write Enable/Read Enable
	input				oe_i      	, 		// Output Enable

	output [DATA_WIDTH-1 : 0]     	data_o		,
	output				data_out_valid
); 

parameter RAM_DEPTH = 1 << ADDR_WIDTH;

logic [DATA_WIDTH-1:0] 		data_out ; 
reg [DATA_WIDTH-1:0] 		mem [RAM_DEPTH-1 : 0];
logic [ADDR_WIDTH-1:0] 		wr_pointer;

always_ff @ (posedge clk or posedge rst) begin
  if (rst) begin
    wr_pointer <= 0;
  end else if ( we_i ) begin
    wr_pointer <= wr_pointer + 1;
  end
end


ram #(.DATA_WIDTH(256), .ADDR_WIDTH(5)) value_stored_ram (

	.clk,
	.rst,

	.read_i(oe_i),
	.read_index_i(address_rd_i),
	.write_i(we_i),
	.write_index_i(wr_pointer),
	.write_data_i(data_i),
	.read_valid_o(data_out_valid),
	.read_value_o(data_o)
);


endmodule 
