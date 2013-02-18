/**
 * @filename		fix_parser.sv 
 *
 * @brief     	        detectes SOH characters 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 */


module fix_parser(

	input 				clk,
	input				rst,

	input[31:0]			data_i,
	input     			tag_status_i,
	input     			body_status_i,
	
	output[2:0]			soh_o,
	output[2:0]			sep_o,
	output   			tag_status_o,
	output   			body_status_o	
);

logic[2:0] 	soh;
logic[2:0] 	sep;
logic 	  	tag_status;
logic		body_status;

logic [7:0] 	soh_c = 7'h01;		// ASCII for "="
logic [7:0] 	sep_c = 7'h3d;		// ASCII for "^"


//always @(posedge clk) begin

always_comb begin

	tag_status = tag_status_i;
	body_status = body_status_i;
	
			
			/* index soh */			
	
			if (data_i[7:0] == soh_c) 
					soh = 3'b000;						
			else if (data_i[15:8] == soh_c)
					soh = 3'b001;
			else if (data_i[23:16] == soh_c)
					soh = 3'b010;			
			else if (data_i[31:24] == soh_c)
					soh = 3'b011;
			else
					soh = 3'b111;

			/* index sep */					
					
			if (data_i[7:0] == sep_c) 
					sep = 3'b000;						
			else if (data_i[15:8] == sep_c)
					sep = 3'b001;
			else if (data_i[23:16] == sep_c)
					sep = 3'b010;			
			else if (data_i[31:24] == sep_c)
					sep = 3'b011;
			else
					sep = 3'b111;						
			
end

assign tag_status_o = tag_status;
assign body_status_o = body_status;
assign sep_o = sep;
assign soh_o = soh;

endmodule
