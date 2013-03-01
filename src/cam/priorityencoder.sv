/**
 * @filename		priorityencoder.sv 
 *
 * @brief     	        priority encoder module for CAM output. Selects first matched output. 
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	n/a	
 */

module priorityencoder # (parameter INDEX_WIDTH = 5)(
	input [(1 << INDEX_WIDTH) -1:0]	 	inp_i,
	input [INDEX_WIDTH-1:0] 		start_i,
	input [INDEX_WIDTH-1:0] 		end_i,
	output[INDEX_WIDTH-1:0] 		out_o,
	output  				valid_o
	);

logic valid;
logic [INDEX_WIDTH-1:0] 		out;

parameter MEM_DEPTH = (1 << INDEX_WIDTH);

always_comb begin
	for (int i = start_i; i<=end_i; i++) begin
			if (inp_i[i] == '1)
				out = i;
	end
end

assign out_o = out;
assign valid_o = inp_i ? 1 : 0;

endmodule
