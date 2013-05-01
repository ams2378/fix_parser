

module interface_controller_in #(parameter NUM_HOST = `HOST_ADDR_WIDTH) (

		input			clk,
		input			rst,
		input			full,
		input			empty,
		input			send_message_valid_i,
		input[7:0]		message_i,
		input			connect_req_i,
		input[NUM_HOST-1:0]	connect_host_addr_i,
		input			disconnect_i,
		input[NUM_HOST-1:0]	disconnect_addr_i,
	
		output[7:0]		data_o
	);

parameter		connect		=	3'b000;
parameter		disconnect	=	3'b001;
parameter		send_data	=	3'b010;	


parameter		state0 = 2'b00;
parameter		state1 = 2'b01;
parameter		state2 = 2'b10;
parameter		state3 = 2'b11;

reg[1:0]		state;
reg[1:0]		next_state;


always @ (posedge clk) begin
	if (rst)	state	<=	state0;
	else		state	<=	next_state;
end

always @ (*) begin

	case(state)
		state0:	begin
				if (full = 1) begin
					next_state	=	state1;
				end else begin
					if (connect_req_i == 1) begin
						data_o		= {3'b000, 1'b0, connec_host_addr_i, connect};
						next_state  	=  state0;
					end else if (disconnect_i == 1) begin
						data_o		= {3'b000, 1'b0, disconnect_addr_i, disconnect};
						next_state  	=  state0;
					end else if (send_message_valid == 1) begin
						data_o		= {3'b000, 1'b0, disconnect_addr_i, disconnect};
					end


					new_message_valid   =  '0;
				if (new_message_i == 1) begin
					new_message_valid   =  '1;
					next_state	= state1;
				end else 
					next_state	= state0;		
			end
		state1:	begin
					new_message_valid   =  '1;
					next_state	= state2;
			end
		state2:	begin
					new_message_valid   =  '1;
					next_state	= state0;
			end
	endcase
end


always @ (posedge clk) begin

	if (connect_req_i == 1) begin
		data_o	<=	{3'b000, 1'b0, connec_host_addr_i, connect};
	end



end


