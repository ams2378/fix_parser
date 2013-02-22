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
	input[7:0]			data_i,
//	input				end_of_body_i,
	
	output[7:0]			data_o,
	output				tag_s_o,
	output   			tag_e_o,
	output				value_s_o,
	output				value_e_o
);

parameter 			initial_s = 2'b00;
parameter			tag = 2'b01;
parameter			value = 2'b10;

logic [1:0]			state;
logic [1:0]			next_state;
logic [7:0]			data;
logic				tag_s;
logic   			tag_e;
logic				value_s;
logic				value_e;

logic [7:0] 			soh_c = 8'h7c;		// ASCII for "^"
logic [7:0] 			sep_c = 8'h3d;		// ASCII for "="

always_ff @(posedge clk) begin

	if (rst)		state <= initial_s;
	else			state <= next_state;
end

always_ff @(state or data_i) begin

	if (rst) begin
		data = '0;	
		tag_s = '0;
		value_s = '0;
	end

	case(state) 
		
		2'b00: begin 
				if (data_i == soh_c) begin
					next_state = tag;
				end else begin
					next_state = initial_s;
				end
		end
		2'b01: begin
				if (data_i != sep_c) begin
					data = data_i;
					tag_s = '1;
					tag_e = '0;
					value_s = '0;
					value_e = '0;
					next_state = tag;
				end else if (data_i == sep_c) begin
					tag_s = '0;
					tag_e = '1;
					value_s = '0;
					value_e = '0;
					next_state = value;
				end
		end
		2'b10: begin	
				if (data_i != soh_c) begin
					data = data_i;
					tag_s = '0;
					tag_e = '0;
					value_s = '1;
					value_e = '0;
					next_state = value;
				end else if (data_i == soh_c) begin
					tag_s = '0;
					tag_e = '0;
					value_s = '0;
					value_e = '1;
					next_state = tag;
				end	
		end
	endcase
end

assign data_o = data;
assign value_s_o = value_s;
assign value_e_o = value_e;
assign tag_s_o = tag_s;
assign tag_e_o = tag_e;

endmodule
