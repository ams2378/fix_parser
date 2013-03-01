
module fix_parser_final_out (

	input 		clk,
	input 		rst,

	input[31:0]	data_i,
	input[1:0]	data_type_i,
	input 		tag_status_i,
	input 		body_status_i,

	out[31:0]	tag_o,
	out[31:0]	body_o				

);


ff #(WIDTH(32)) mem (




);

always @(posedge clk) begin

	
	if (data_type == 00 && body_status == 1 && tag_status == 0) begin




	end


end




