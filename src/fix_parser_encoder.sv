/**
 * @filename		fix_parser_encoder.sv 
 *
 * @brief     	        encodes fix message.  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	ascii2int.sv	
 */


module fix_parser_encoder(

	input			clk,
	input			rst,
	
	input[7:0]		data_i,
	input			tag_valid_i,
	input			value_valid_i,
	input			start_i,
	input			end_i,

	output[7:0]		data_o,
	output			data_valid_o
);

parameter 			state0 = 4'b0000;
parameter			state1 = 4'b0001;
parameter			state2 = 4'b0010;
parameter			state3 = 4'b0011;
parameter			state4 = 4'b0100;
parameter			state5 = 4'b0101;
parameter 			state6 = 4'b0110;
parameter			state7 = 4'b0111;
parameter			state8 = 4'b1000;
parameter			state9 = 4'b1001;

logic [7:0] 			first_tag = 8'h38;		// ASCII for "8" - indicates start of a new FIX message
logic [7:0] 			soh = 8'h01;		// ASCII for SOH 
logic [7:0] 			sep = 8'h3d;		// ASCII for "="

logic [7:0]		 	data;
logic [7:0]		 	data_t;
logic				data_valid;

always_ff @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end

always_ff @(state or start_i or end_i ) begin

	if (rst) begin
		data = '0;
		data_valid = '0;
	end

	case(state) 
		
		state0: begin 
				if (start_i == 1 ) begin
					data = first_tag;
					data_valid = '1;
					next_state = state1;
				end else begin
					data_valid = '0;
					next_state = state0;
				end
		end
		state1: begin
				data = sep;
				next_state = state2;
		end
		state2: begin
				if (value_valid_i == 1) begin
					data = data_i;
					next_state = state4;
				end else 
					next_state = state3;
		end
		state3: begin
				if (value_valid_i == 0) begin
					next_state = state3;
				end else begin 
					data = data_i;
					next_state = state4;
				end	
		end
		state4: begin
				if (end_i == 1) begin
					data = soh;
					next_state = state0;
				end else if (value_valid_i == 1) begin 
					data = data_i;
					next_state = state5;
				end end else if (value_valid_i == 0) begin 
					data = soh;
					next_state = state6;
				end
		end
		state5: begin
				if (end_i == 1) begin
					data = soh;
					next_state = state0;
				end else if (value_valid_i == 1) begin 
					data = data_i;
					next_state = state4;
				end end else if (value_valid_i == 0) begin 
					data = soh;
					next_state = state6;
				end
		end
		state6: begin
				if (tag_valid_i == 0) begin
					next_state = state7;
				end else if (tag_valid_i == 1) begin 
					data = data_i;
					next_state = state8;
				end
		end
		state7: begin
				if (tag_valid_i == 0) begin
					next_state = state7;
				end else if (tag_valid_i == 1) begin 
					data = data_i;
					next_state = state8;
				end
		end
		state8: begin
				if (tag_valid_i == 1) begin
					data = data_i;
					next_state = state9;
				end else if (tag_valid_i == 0) begin 
					data = sep;
					next_state = state1;
				end
		end
		state9: begin
				if (tag_valid_i == 1) begin
					data = data_i;
					next_state = state8;
				end else if (tag_valid_i == 0) begin 
					data = sep;
					next_state = state1;
				end
		end
	endcase
end

assign data_o = data;
assign data_valid_o = data_valid; 


endmodule
