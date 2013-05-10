

module interface_controller_in #(parameter NUM_HOST = `HOST_ADDR_WIDTH) (

		input			clk,
		input			rst,
		input			full_i,
		input			send_message_valid_i,
		input[7:0]		message_i,
		input			connect_req_i,
		input[NUM_HOST-1:0]	connect_host_addr_i,
		input			disconnect_i,
		input[NUM_HOST-1:0]	disconnect_addr_i,
		input[7:0]		message_length_i,
		input			all_sent_i,
		input			initiate_msg_i,
//		input			client_type_i,
	
		output reg[7:0]		data_o,
		output wire		writereq_o
	);

parameter		connect		=	3'b000;
parameter		disconnect	=	3'b001;
parameter		send_data	=	3'b010;	


parameter		state0 = 3'b000;
parameter		state1 = 3'b001;
parameter		state2 = 3'b010;
parameter		state3 = 3'b011;
parameter		state4 = 3'b100;
parameter		state5 = 3'b101;
parameter		state6 = 3'b110;
parameter		state7 = 3'b111;

reg			writereq_temp;
reg			send_message_valid_temp1;
reg			send_message_valid_temp2;
reg[2:0]		state;
reg[2:0]		next_state;

reg			data_t_1;
reg			data_t_2;
reg[7:0]		data_temp_1;
reg[7:0]		data_temp_2;

always @ (posedge clk) begin
		send_message_valid_temp1	<=	send_message_valid_i;
		send_message_valid_temp2	<=	send_message_valid_temp1;
end


always @ (posedge clk) begin
	if (rst)	state	<=	state0;
	else		state	<=	next_state;
end

always @ (*) begin

	if (rst) begin
		writereq_temp	=	'0;
		data_o	=	'0;
	end


	case(state)
		state0:	begin
				data_o	=	'0;
				if (full_i == 1 ) begin
					data_t_1 	= '0;
					data_t_2 	= '0;
					writereq_temp	= '0;
					next_state	=	state0;
				end else begin
			//		if (connect_req_i == 1 && client_type_i == '1 ) begin
					if (connect_req_i == 1) begin
						writereq_temp	= '1;
						data_o		= {3'b000, 1'b0, connect_host_addr_i, connect};
						next_state  	=  state0;
					end else if (disconnect_i == 1) begin
						writereq_temp	= '1;
						data_o		= {3'b000, 1'b0, disconnect_addr_i, disconnect};
						next_state  	=  state0;
					end else if ( initiate_msg_i == 1 ) begin
						writereq_temp	= '1;		//
						data_t_1 	= '1;
						data_t_2 	= '0;
						data_o		= {3'b000, 1'b0, connect_host_addr_i, send_data};
						next_state  	=  state1;
					end else begin
						writereq_temp	= '0;
						next_state	=  state0;
					end
				end
			end
		state1:	begin
				data_o	=	'0;
				if (full_i == 1 ) begin
					data_t_1 	= '0;
					data_t_2 	= '0;
					writereq_temp	= '0;
					writereq_temp	= '0;
					next_state	= state1;
				end else begin	
					data_t_1 	= '0;
					data_t_2 	= '1;
					writereq_temp	= '1;		//
					data_o		= message_length_i + 8'd21;		// length of payload
					next_state	= state2;
				end
			end
		state2:	begin
				data_o	=	'0;
				if (full_i == 1 ) begin
					data_t_1 	= '0;
					data_t_2 	= '0;
					writereq_temp	= '0;
					writereq_temp	= '0;
					next_state	= state2;
				end else if ( all_sent_i != 1) begin	
					data_t_1 	= '1;
					data_t_2 	= '0;
					writereq_temp	= '0;		//
					data_o		= data_temp_1;		// length of payload
					next_state	= state3;
				end else begin
					data_t_1 	= '1;
					data_t_2 	= '0;
					writereq_temp	= '0;		//
					data_o		= data_temp_1;		// length of payload
					next_state	= state4;
				end
			end
		state3:	begin
				data_o	=	'0;
				if (full_i == 1 ) begin
					data_t_1 	= '0;
					data_t_2 	= '0;
					writereq_temp	= '0;
					writereq_temp	= '0;
					next_state	= state3;
				end else begin
				if (all_sent_i != 1) begin	
					data_t_1 	= '0;
					data_t_2 	= '1;
					writereq_temp	= '0;		//
					data_o		= data_temp_2;		// length of payload
					next_state	= state2;
				end else begin
					data_t_1 	= '0;
					data_t_2 	= '1;
					writereq_temp	= '0;		//
					data_o		= data_temp_2;		// length of payload
					next_state	= state5;
				end
				end
			end
		state4:	begin
				data_o	=	'0;
				if (full_i == 1 ) begin
					data_t_1 	= '0;
					data_t_2 	= '0;
					writereq_temp	= '0;
					writereq_temp	= '0;
					next_state	= state4;
				end else begin
					data_t_1 	= '0;
					data_t_2 	= '1;
					writereq_temp	= '0;		//
					data_o		= data_temp_2;		// length of payload
					next_state	= state6;
				end
			end
		state5:	begin
				data_o	=	'0;
				if (full_i == 1 ) begin
					data_t_1 	= '0;
					data_t_2 	= '0;
					writereq_temp	= '0;
					next_state	= state5;
				end else begin
					data_t_1 	= '0;
					data_t_2 	= '0;
					writereq_temp	= '0;		//
					data_o		= data_temp_1;		// length of payload
					next_state	= state7;
				end
			end
		state6:	begin
				data_o	=	'0;
				if (full_i == 1 ) begin
					data_t_1 	= '0;
					data_t_2 	= '0;
					writereq_temp	= '0;
					writereq_temp	= '0;
					next_state	= state6;
				end else begin
					data_t_1 	= '0;
					data_t_2 	= '0;
					writereq_temp	= '0;		//
					data_o		= data_temp_1;		// length of payload
					next_state	= state0;
				end
			end
		state7:	begin
				data_o	=	'0;
				if (full_i == 1 ) begin
					data_t_1 	= '0;
					data_t_2 	= '0;
					writereq_temp	= '0;
					next_state	= state7;
				end else begin
					data_t_1 	= '0;
					data_t_2 	= '0;
					writereq_temp	= '0;		//
					data_o		= data_temp_2;		// length of payload
					next_state	= state0;
				end
			end
	endcase
end

always @ (posedge clk) begin

	if (data_t_1 == 1) begin
		data_temp_1	<=	message_i;
	end

	if (data_t_2 == 1) begin
		data_temp_2	<=	message_i;
	end
end

assign	writereq_o	=	writereq_temp | send_message_valid_temp2;


endmodule
