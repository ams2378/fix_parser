
module priorityencoder # (parameter INDEX_WIDTH = 5)(
	input [(1 << INDEX_WIDTH) -1:0]	 	inp_i,
	input [INDEX_WIDTH-1:0] 		start_i,
	input [INDEX_WIDTH-1:0] 		end_i,
	output[INDEX_WIDTH-1:0] 		out_o,
	output  				valid_o
	);

logic valid;
logic out;

parameter MEM_DEPTH = (1 << INDEX_WIDTH);


always_comb begin
	for (int i = start_i; i<=end_i; i++) begin
			out[i] = inp_i[i] & '1;
	end
end

assign out_o = out;
assign valid_o = inp_i ? 1 : 0;

endmodule
