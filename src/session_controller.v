/**
 * @filename		session_controller.v 
 *
 * @brief     	        main controller of the engine  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies		
 *
 * @status		currently only handles a single session 
 *			configure-connect-logon-ht-logout-disconnect cycle	
 *
 */

module session_controller (

		input 			clk,
		input			rst,
		
		input			configure_i,
		input			start_i,
		input			end_session_i,
		input			connected_i,
		input			response_received_i,
		input[2:0]		packet_status_i,		// good or bad? i.e. msgSeqNum_H
		input			timeout_i,
		input			message_created_i,
		input			new_message_r_i,
		input			send_b_a_message_i,
		input[2:0]		received_msg_type_i,

		output reg		load_configure_o,
		output reg		connect_o,
		output reg[2:0]		create_message_o,		// session level- logon, logout
		output reg		send_message_o,
		output reg		disconnect_o,
		output reg		ignore_o,
		output reg		initiate_msg_o
		);


parameter 			state0  = 8'b00000001;
parameter 			state1  = 8'b00000010;
parameter 			state2  = 8'b00001000;
parameter 			state3  = 8'b00010000;
parameter 			state4  = 8'b00100000;
parameter 			state5  = 8'b00100000;
parameter 			state6  = 8'b01000000;
parameter 			state7  = 8'b10000000;


reg [7:0]			state;
reg [7:0]			next_state;

reg [2:0]			mem_state;	// 001-logon, 111-business, 100-logout, 010-hb
reg [2:0]			logon 		= 3'b001;
reg [2:0]			business 	= 3'b111;
reg [2:0]			logout 		= 3'b100;
reg [2:0]			heartbeat	= 3'b010;


always @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end


always @ (state or configure_i or start_i or connected_i or message_created_i or 
	  response_received_i or timeout_i or message_created_i or new_message_r_i) begin

	if (rst) begin
		connect_o		<=	'0;
		create_message_o	<=	'0;
		send_message_o		<=	'0;
		disconnect_o		<=	'0;
		ignore_o		<=	'0;
		initiate_msg_o		<=	'0;
		mem_state		<=	'0;
	end

	case (state)

	// wait for configuration
	state0: begin
			if (configure_i == 1) begin 
				load_configure_o	<=	'1;
				next_state		=	state1;
			end else	
				next_state		= 	state0;
		end

	// signal to initiate a new connection after configuration
	state1:	begin
			if (start_i == 1) begin
				connect_o		<=	'1;
				next_state		=	state2;
			end else 
				next_state		=	state1;
		end
	
	// if connected send logon or wait
	state2: begin
			if (connected_i == 1) begin
				create_message_o	<=	3'b001;			// 001 - logon
				mem_state		<=	3'b001;
				initiate_msg_o		<=	'1;
				next_state		=	state3;
			end else
				next_state		=	state2;
		end

	// wait until message is created- if done send message
	state3:	begin
			if (message_created_i == 1) begin
				send_message_o		<=	'1;
				case (mem_state)
					logon	:	next_state = state4; 
					logout	:	next_state = state7; 
					heartbeat:	next_state = state6;
					business:	next_state = state7;		// dc need to update later 
					default :	next_state = state0;
				endcase
			end else 
				next_state		=	state3;
		end

	// wait for LOGON response- if received, handle it properly
	state4: begin
			if (response_received_i == 1) begin
				if (packet_status_i == 000) begin			// 000 - invalid
					disconnect_o	<=	'1;		
					next_state	=	state7;			// jump to DC 
				end else if (packet_status_i == 001) 			// 001 - valid
					next_state	=	state5;			// goto Normal Session
			end else if (timeout_i == 1) begin
				disconnect_o		<=	'1;
				next_state		=	state5;			// jump to DC
			end else
				next_state		=	state4;
		end

	// session established
	state5:	begin
			if (send_b_a_message_i == 1) begin				// send non-session level msg
				create_message_o	<=	business;			// 111- business/app
				mem_state		<=	business;			
				initiate_msg_o		<=	'1;
				next_state		=	state3;			// wait for msg done
			end else if (end_session_i == 1) begin
				create_message_o	<=	logout;			// 100 - logout
				mem_state		<=	logout;			
				initiate_msg_o		<=	'1;	
				next_state		=	state3;
			end else if (new_message_r_i == 1) begin			// new msg received from outside
				if ( received_msg_type_i == 3'b010) begin		// 010- HB
					create_message_o	<=	heartbeat;	// res with HB reply
					mem_state		<=	heartbeat;		
					initiate_msg_o		<=	'1;
					next_state		=	state3;		// go to state-HB response handle
				end else if (received_msg_type_i == 3'b100) begin	// 011 - logout
					create_message_o	<=	logout;
					mem_state		<=	logout;
					initiate_msg_o		<=	'1;
					next_state		=	state3;		// wait for msg done	
				end
			end
		end

	// wait for response (HB)- if received, handle it properly
	state6: begin
			if (response_received_i == 1) begin
				if (packet_status_i == 000) begin			// 000 - invalid
					create_message_o	<=	logout;		
					initiate_msg_o		<=	'1;
					mem_state		<=	logout;
					next_state		=	state3;		// jump to DC 
				end else if (packet_status_i == 001) 			// 001 - valid
					next_state	=	state5;			// goto Normal Session
			end else if (timeout_i == 1) begin
				initiate_msg_o		<=	'1;
				mem_state		<=	logout;
				next_state		=	state3;			// jump to DC
			end else
				next_state		=	state6;
		end

	// disconnect
	state7: begin
				disconnect_o		<=	'1;
				next_state		=	state0;
		end

	endcase

end 

endmodule


