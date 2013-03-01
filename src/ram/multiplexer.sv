/**
 * @filename		multiplexer.sv 
 *
 * @brief     	        multiplexer for final read output 
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	n/a 	
 */

module multiplexer # (parameter DATA_WIDTH = 256, ADDR_WIDTH = 5) ( 

	input	[DATA_WIDTH*(1<<ADDR_WIDTH)-1 : 0] 	data_i, 
	input	[ADDR_WIDTH-1:0] 			read_address_i, 
	output 	[DATA_WIDTH-1:0] 			data_o 
	);

logic [31:0] data_out;

parameter RAM_DEPTH = 1 << ADDR_WIDTH;

always_comb begin
	for (int i = 0; i< RAM_DEPTH ; i++) begin
		if (read_address_i [ADDR_WIDTH-1:0] == i)
			data_out [DATA_WIDTH-1:0] = data_i[ i*DATA_WIDTH +: DATA_WIDTH];
	end
end

assign data_o = data_out;

endmodule 

