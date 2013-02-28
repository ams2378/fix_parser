/*-----------------------------------------------------
Design Name : CAM
File Name   : decoder_5_32.sv
Function    : decoder to decode read and write address
*///-----------------------------------------------------
module decoder #(parameter ADDR_WIDTH = 5, CAM_DEPTH = 32) ( 

	input [ADDR_WIDTH:0] decoder_i,
	output [CAM_DEPTH-1:0] decoder_o
	);

	logic [CAM_DEPTH-1:0] decoder_out;
	
	always_comb begin

		for (int i=0; i<CAM_DEPTH; i++ ) begin
			decoder_out [i] = (i==decoder_i) ? 1 : 0;	
		end
	end
	
	assign decoder_o = decoder_out;	

endmodule
