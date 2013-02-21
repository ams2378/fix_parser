/**
 * @filename		fix_parser_out_module.sv 
 *
 * @brief     	        strip out tag and value from the message 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 */

module fix_parser_out_module(

	input 				clk,
	input				rst,
	input[7:0]			data_i,
	input				start_tag_i,
	input				start_value_i,
	
	output[31:0]			tag_o,
	output[255:0]			value_o,
	output				end_of_body_o,
	output				start_of_header_o
);

parameter 			state0 = 3'b000;
parameter			state1 = 3'b001;
parameter			state2 = 3'b010;
parameter 			state3 = 3'b011;
//parameter			state4 = 3'b101;

logic [2:0]			state;
logic [2:0]			next_state;

logic[31:0]			tag;
logic[255:0]			value;
logic				end_of_body;
logic				start_of_header;

logic [7:0] 			first_tag = 8'h38;		// ASCII for "8"
logic [15:0] 			last_tag = 16'h3130;		// ASCII for "10"

int 	i = 1;
bit	last_tag_valid;

logic	incr_i;
 
always_ff @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end

always_ff @(state or start_tag_i or start_value_i) begin
		
	case(state) 
		state0: begin 
				if (start_tag_i == 1) begin
					tag [7:0] = data_i;
					next_state = state1;
				end else begin
					start_of_header = '0;
					end_of_body = '0;
					next_state = state0;
				end
		end
		state1: begin
				if (start_tag_i == 1) begin
					tag  <<= 8;
					tag[7:0] = data_i;
				//	i = i + 1;	
					next_state = state1;
				end else if (start_tag_i == 0) begin
					if (tag == first_tag) begin
				//		i = 1;
						start_of_header = '1;
						next_state = state2;
					end else if (tag == last_tag) begin
				//		i = 1;
						end_of_body = 1;
						next_state = state2;
					end else 
						next_state = state2;
				end
		end
		state2: begin	
				if (start_value_i == 1) begin
					value[7:0] = data_i;
					next_state = state3;
				end else 
					next_state = state2;
		end
		state3: begin
				if (start_value_i == 1) begin
					value << 8;
					value [7:0] = data_i;
				//	value[8*i +: 8] = data_i;
					incr_i = 1;
				//	i = i + 1;	
					next_state = state3;
				end else begin
					incr_i = 0;
				//	i = 1; 
			 		if (end_of_body == 1) 		next_state = state0;
					else 				next_state = state1;
				end

		end
	endcase
end

/*
always_ff @( posedge clk ) begin
	if (incr_i == 1)		i <= i + 1;
	else				i <= 1;
end
*/


assign tag_o = tag;
assign value_o = value;
assign start_of_header_o = start_of_header;
assign end_of_body_o = end_of_body;

endmodule

