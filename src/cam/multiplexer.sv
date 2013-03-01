/**
 * @filename		multiplexer.sv 
 *
 * @brief     	        multiplexer for final data out.  
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	n/a 
 *
 * @note		Not used as a part of fix_parser projects. However for full CAM functionality this module is essential.
 */

module multiplexer ( input[32*32-1 : 0] data_i, input[4:0] read_address_i,  output [31:0] data_o );

logic [31:0] data_out;

always_comb begin
	for (int i = 0; i< 32; i++) begin
		if (read_address_i [4:0] == i)
			data_out [31:0] = data_i[ i*32 +: 32];
	end
end

assign data_o = data_out;

endmodule 

