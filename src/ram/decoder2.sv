/*-----------------------------------------------------
Design Name : CAM
File Name   : decoder_5_32.sv
Function    : decoder to decode read and write address
*///-----------------------------------------------------
module decoder2 #(parameter ADDR_WIDTH = 5) ( 

	input [ADDR_WIDTH-1:0] decoder_i,
	output [(1 << ADDR_WIDTH)-1:0] decoder_o
	);

	parameter CAM_DEPTH = (1 << ADDR_WIDTH);
	logic [CAM_DEPTH-1:0] decoder_out;

	always_comb begin

		for (int i=0; i<CAM_DEPTH; i++ ) begin
			decoder_out [i] = (i==decoder_i) ? 1 : 0;	
		end
	end
	
	assign decoder_o = decoder_out;	

endmodule
