/**
 * @filename		fix_parser.sv 
 *
 * @brief     	        detects tag and value for each 8 bit input data  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	n/a	
 */


module fix_parser(

	input 				clk,
	input				rst,
	input[7:0]			data_i,
	input				new_message_i,
	
	output[7:0]			data_o,
	output				tag_s_o,
	output				value_s_o
);

parameter 			initial_s = 2'b00;
parameter			tag = 2'b01;
parameter			value = 2'b10;

reg [1:0]			state;
reg [1:0]			next_state;
reg [7:0]			data;
reg				tag_s;
//reg   			tag_e;
reg				value_s;
//reg				value_e;

reg [7:0] 			soh_c = 8'h01;		// ASCII for SOH 
reg [7:0] 			sep_c = 8'h3d;		// ASCII for "="

always @(posedge clk) begin

	if (rst)		state <= initial_s;
	else			state <= next_state;
end

always @(state or data_i or new_message_i) begin

	if (rst) begin
		data = '0;	
		tag_s = '0;
		value_s = '0;
	end

	case(state) 
		
		2'b00: begin 
				if (new_message_i == 1) begin
					next_state = tag;
				end else begin
					next_state = initial_s;
				end
		end
		2'b01: begin
				if (data_i != sep_c) begin
					data = data_i;
					tag_s = '1;
					value_s = '0;
					next_state = tag;
				end else if (data_i == sep_c) begin
					tag_s = '0;
					value_s = '0;
					next_state = value;
				end
		end
		2'b10: begin	
				if (data_i != soh_c) begin
					data = data_i;
					tag_s = '0;
					value_s = '1;
					next_state = value;
				end else if (data_i == soh_c) begin
					tag_s = '0;
					value_s = '0;
					next_state = tag;
				end	
		end
	endcase
end

assign data_o = data;
assign value_s_o = value_s;
assign tag_s_o = tag_s;

endmodule
