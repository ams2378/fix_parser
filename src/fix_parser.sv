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
	input				ctrl,

	input[7:0]			data_i,
	
	output[7:0]			data_o,
	output				tag_s_o,
	output   			tag_e_o,
	output				value_s_o,
	output				value_e_o
);


parameter 			initial_s = 0;
parameter			tag = 1;
parameter			value = 2;
logic				state, next_state;
logic[7:0]			data;
logic				tag_s;
logic   			tag_e;
logic				value_s;
logic				value_e;

logic [7:0] 	soh_c = 7'h01;		// ASCII for "^"
logic [7:0] 	sep_c = 7'h3d;		// ASCII for "="

always @(posedge data_i) begin

	case(state) 

		initial_s: begin
				if (data_i == soh_c) 
					next_state = tag;
						
				else	next_state = initial_s;
		end
		
		tag:	begin
				if (data_i != sep_c) begin
					data = data_i;
					tag_s = '1;
					tag_e = '0;
					value_s = '0;
					value-e = '0;
					next_state = tag;
				end else if (data_i == sep_c) begin
					tag_s = '0;
					tag_e = '1;
					value_s = '0;
					value-e = '0;
					next_state = value;
				end
		end

		value:	begin
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
					value-e = '1;
					next_state = tag;
				end	
		end

	endcase
end

always @(posedge clk) begin

	if (rst)		state <= initial_s;
	else			state <= next_state;
end


assign data_o = data;
assign value_s_o = value_s;
assign valus_e_o = value_e;
assign tag_s_o = tag_s;
assign tag_e_o = tag_e;

endmodule
