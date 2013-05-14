/**
 * @filename		checksum.sv 
 *
 * @brief     	        computes checksum of the received message  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	ascii2int.sv	
 */


module create_checksum(

	input			clk,
	input			rst,	
	input[7:0]		data_i,
	input			start_i,
	input			end_i,
	input			data_valid_i,

	output reg[7:0]		checksum_o
);

parameter 			state0 = 3'b000;
parameter			state1 = 3'b001;
parameter			state2 = 3'b010;
parameter			state3 = 3'b011;
parameter			state4 = 3'b100;
parameter			state5 = 3'b101;
parameter			state6 = 3'b110;
parameter			state7 = 3'b111;

reg [2:0]			state;
reg [2:0]			next_state;
reg [8:0]			temp;
reg [8:0]			temp2;
reg [8:0]			temp3 = 8'd117;

reg [7:0]			q_10;
reg [7:0]			r_10;
reg [7:0]			q_100;
reg [7:0]			r_100;

reg				add_t1;
reg				sub;
reg				calc_r_100;
reg				calc_r_10;
reg				calc_q_10;
reg				set_temp3;

always @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end

always @(*) begin

	if (rst) begin
		checksum_o 	= '0;
		add_t1		= '0;
		sub		= '0;
		calc_r_100	=	'0;
		calc_r_10	=	'0;
		calc_q_10	=	'0;
		set_temp3	=	'0;
	end

	case(state) 
		
		state0: begin
				checksum_o 	= '0;
				calc_r_100	=	'0;
				calc_r_10	=	'0;
				calc_q_10	=	'0;
			 	add_t1	=	'0;
				sub	=	'0;
				set_temp3	=	'0;
				if (start_i == 1 && data_valid_i == 1) begin
					next_state = state1;
				end else begin
					next_state = state0;
				end
		end
		state1: begin
				checksum_o 	= '0;
				calc_r_100	=	'0;
				calc_r_10	=	'0;
				calc_q_10	=	'0;
				add_t1	=	'0;
				sub	=	'0;
				set_temp3	=	'0;
				if (data_valid_i == 0) begin
					next_state  =  state1;
				end else begin 
					if (end_i != 1) begin
						add_t1	=	'1;
						next_state = state1;
					end else begin
						sub	=	'1;
						next_state = state3;
					end
				end
		end

		state3: begin
				checksum_o 	= '0;
				calc_r_100	=	'0;
				calc_r_10	=	'0;
				calc_q_10	=	'0;
			 	add_t1	=	'0;
				sub	=	'0;
				set_temp3	=	'0;
				if (data_valid_i == 0) begin
					next_state  =  state3;
				end else begin				
					if (temp3[7:0] < 100) begin
						checksum_o	= 	8'h30;		// out is 0
						calc_q_10	=	'1;
						calc_r_10	=	'1;
						next_state = state4;
					end else begin
						if (temp3[7:0] > 199) begin
							checksum_o = 8'h32;
							calc_r_100 =	'1;
						end else begin
							checksum_o = 8'h31;
							calc_r_100 =	'1;
						end
						next_state = state6;
					end	
				end				
		end


		state4: begin
				calc_r_100	=	'0;
				calc_r_10	=	'0;
				calc_q_10	=	'0;
			 	add_t1	=	'0;
				sub	=	'0;
				set_temp3	=	'0;
				checksum_o	=	8'h30 + q_10;
				next_state	=	state5;
			end
		state5: begin
				calc_r_100	=	'0;
				calc_r_10	=	'0;
				calc_q_10	=	'0;
			 	add_t1	=	'0;
				sub	=	'0;
				checksum_o	=	8'h30 + r_10;
				set_temp3	=	'1;
				next_state	=	state0;
			end
		state6: begin
				calc_r_100	=	'0;
				calc_r_10	=	'0;
				calc_q_10	=	'0;
			 	add_t1	=	'0;
				sub	=	'0;
				set_temp3	=	'0;
				checksum_o	=	8'h30 + (r_100 / 8'd10);
				next_state	=	state7;
			end
		state7: begin
				calc_r_100	=	'0;
				calc_r_10	=	'0;
				calc_q_10	=	'0;
			 	add_t1	=	'0;
				sub	=	'0;
				set_temp3	=	'1;
				checksum_o	=	8'h30 + (r_100 % 8'd10);
				next_state	=	state0;
			end
	endcase
end

always @ (posedge clk) begin

if (calc_r_100 == 1) begin
	r_100	<=	temp3[7:0] % 8'd100;
end

if (calc_r_10 == 1) begin
	r_10	<=	temp3[7:0] % 8'd10;
end

if (calc_q_10 == 1) begin
	q_10	<=	temp3[7:0] / 8'd10;
end

if (sub == 1) begin
	temp3	<=	temp3[7:0] - 8'd48;
end

if (add_t1 == 1) begin
	temp3	<=	temp3 + data_i;
	if (temp3 + data_i >= 9'd256) begin
		temp3 <= temp3 + data_i - 9'd256;
	end
end

if (set_temp3 == 1) begin 
	temp3	<=	8'd117;
end


end

endmodule

