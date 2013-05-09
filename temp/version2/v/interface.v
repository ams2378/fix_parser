

module interface  (

		input			clk,
		input			rst,

		input			full_i,
		input			error_i,
		input[63:0]		data_i,
		input			empty_i,

		output reg		readreq_o,
		output reg		valid_o,
		output reg[7:0]		data_o,
		output reg[1:0]		id_o

	);

parameter		connect		=	3'b000;
parameter		disconnect	=	3'b001;
parameter		send_data	=	3'b010;	


parameter		state0 = 3'b000;
parameter		state1 = 3'b001;
parameter		state2 = 3'b010;

reg[2:0]		state;
reg[2:0]		next_state;

reg[3:0]		var_1;
reg[15:0]		var_2;
reg[15:0]		length;
reg			incr_var_1;
reg			incr_var_2;

reg			latch_length;
reg			last_byte;
reg			end_message;

always @ (posedge clk) begin
	if (rst)	state	<=	state0;
	else		state	<=	next_state;
end

always @ (*) begin

	if (rst) begin
		readreq_o	=	'0;
		valid_o		=	'0;
		data_o		=	'0;
		id_o		=	'0;
	end

	case(state)
		state0:	begin
				readreq_o	=	'0;
				valid_o		=	'0;
				data_o		=	'0;
				id_o		=	'0;
				latch_length	= 	'0; 
				incr_var_1	=	'0;
				incr_var_2	=	'0;
				if (empty_i == 1 ) begin
					next_state	=	state0;
				end else begin
						readreq_o	= '1;
						next_state	=  state1;
				end
			end

		state1: begin
				data_o		= '0;
				readreq_o	= '1;
				id_o		= data_i[1:0];
				valid_o		= '1; 
				incr_var_1	= '0;
				incr_var_2	= '1;
				latch_length	= '1;
				next_state  	=  state2;
			end
		state2:	begin
				valid_o		=	'0;
				if (last_byte == 0 ) begin
						readreq_o	=   '0;
						data_o		=   data_i[var_1*8 +: 8];					
						incr_var_1  	=   '1;
						incr_var_2	=   '0;
					if (end_message == 1) begin
						next_state	=   state0;
					end else
						next_state	=   state2;
				end else begin 
					readreq_o	=   '1;
					data_o		=   data_i[var_1*8 +: 8];					
					incr_var_1	=   '0;
					incr_var_2	=   '1;
					next_state	=   state2;
				end
			end
	endcase
end

always @ (posedge clk) begin

	last_byte	<=	'0;
	end_message	<=	'0;
	
	if (latch_length == 1) begin
		length		<=	data_i[18:4];
	
	end

	if (incr_var_1 == 1) begin
		var_1	<=	var_1  +  1;	
	end

	if (incr_var_2 == 1) begin
		var_2	<=	var_2  +  1;	
	end

	if (var_1 ==  8'd7) begin
		last_byte	<=	'1;
		var_1		<=	'0;
	end

	if (var_2 ==  length - 1) begin
		end_message	<=	'1;
	end
end

endmodule
