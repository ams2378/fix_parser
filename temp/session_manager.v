//note: have a small state machine between this module and create message
//as long as create message is busy, keep the new crate message order waiting

module session_manager # (parameter NUM_SESSION = 3, ADDR = 10, ID = 64)(

		input				clk,
		input				rst,
		input				configure_i,
		input				connect_i,
		input[ADDR-1:0]			connectToAddr_i,
		input[2:0]			validity_i,
		input[3:0]			message_type_i,
		input[2:0]			current_session_state_i,
		input[NUM_SESSION-1:0]		timeout_i,
		input[ID-1:0]			myID_i,
	
		output reg			load_config_o,
		output reg[NUM_SESSION-1:0]	connect_o,
		output reg[ADDR-1:0]		connectTo_o,
		output reg[2:0]			create_message_o,			
		output reg			send_message_o,
		output reg[NUM_SESSION-1:0]	disconnect_o,
		output reg			ignore_o,
		output reg			initiate_msg_o
		output reg[ID-1:0]		map_src_o
		output reg			we_o,
		);

parameter		msgSeqH		= 	3'b001;
parameter		garbled		=	3'b010;
parameter		msgSeqL		=	3'b001;
parameter		valid		=	3'b000;

parameter		logon 		= 	4'b0001;
parameter		business 	= 	4'b0111;
parameter		logout 		= 	4'b0100;
parameter		heartbeat	= 	4'b0010;

reg [ID-1:0]		my_ID;

always @ (posedge clk) begin

	if (rst) begin
		connect_o		<=	'0;
		load_configure_o	<=	'0;
		create_message_o	<=	'0;
		send_message_o		<=	'0;
		disconnect_o		<=	'0;
		ignore_o		<=	'0;
		initiate_msg_o		<=	'0;
	end


	if (new_message == 1) begin
		if (validity == garbled) 
			ignore		<= 	'1;
		else if (validity == msgSeqL)
			disconnect	<=	'1;	
		else begin
			case (exp)
			
			logonSent: 	begin
						if (type != logon) begin
							disconnect	<=	1;
							address_o	<=	add...
							we_0		<=	1
							status_o	<= 	disconnected;
						end else if (type == logon) begin
							if (validity == msgSeqH) begin
								resentReq	<=	'1;
								targetId_o	<=	targetId;
								we_0		<=	'1;
								address_o	<=	add...	
								status_o	<=	resendReqestSent;
							end else if (validity == valid) begin
								targetId_o	<=	targetId;
								we_0		<=	addr...
								status_o	<=	normalSession;
							end
						end
					end
			logoutSent:	begin
						if (type == logout && validity == valid) begin
							disconnect	<=	1;
							address_o	<=	add...
							we_0		<=	1
							status_o	<= 	disconnected;
						end else if (type == resendReq) begin
							doResend	<=	;1
							address_o	<=	add...
							we_0		<=	1
							status_o	<= 	servingResendRequest;
						end else if (timeout == 1) begin
							disconnect	<=	'1;
						end else (type == other) 			// other msg types 
							disconnect	<=	'1;
					end		
				   
			normalSession:	begin
						if (validty == msgSeqH && type == logout) begin
							resendReq	<=	'1
							address_o	<=	add...
							we_0		<=	1
							status_o	<= 	resendReqLogout;
						if (validty == msgSeqH) begin
							resendReq	<=	'1
							address_o	<=	add...
							we_0		<=	1
							status_o	<= 	resendReqSent;
						end else if (type == heartbeat) begin
							sendheartbeat	<=	'1;
							address_o	<=	add...
							we_0		<=	1
							status_o	<= 	normalSession;
						end else if (type == resendReq) begin
							doResend	<=	'1;
							address_o	<=	add...
							we_0		<=	1
							status_o	<= 	servingResendRequest;
						end else if (type == testRequest) begin
							reply2testreq	<=	'1;
							address_o	<=	add...
							we_0		<=	1
							status_o	<= 	normalSession;
						end else if (type == logout) begin
							respondLogout	<=	'1;
							address_o	<=	add...
							we_0		<=	1
							status_o	<= 	responded2logout;
						end else if (type == other) begin
							appMessage	<=	1;
					end		
			resendReqSent:	begin
						if (validity == msgSeqH) begin
							resendReq	<=	'1
							address_o	<=	add...
							we_0		<=	1
							status_o	<= 	resendReqSent;
						end if (type == gapFill || type == reset) begin
							updateSeqCounter	<=	'1;
							seqCounterLoc		<=	addr...
							resendReq		<=	'1
							address_o		<=	add...
							we_0			<=	1
							status_o		<= 	resendReqSent;
						end if (resendDone == 1) begin
							address_o	<=	add...
							we_0		<=	1
							status_o	<=	normalSession;
						end else begin	
							address_o	<=	add...
							we_0		<=	1
							status_o	<=	resendReqSent;
						end 	
					end
			resendReqlogout:begin
						if (validity == msgSeqH) begin
							resendReq	<=	'1
							address_o	<=	add...
							we_0		<=	1
							status_o	<= 	resendReqSent;
						end if (type == gapFill || type == reset) begin
							updateSeqCounter	<=	'1;
							seqCounterLoc		<=	addr...
							resendReq		<=	'1
							address_o		<=	add...
							we_0			<=	1
							status_o		<= 	resendReqSent;
						end if (resendDone == 1) begin
							sendLogout	<=	'1
							address_o	<=	add...
							we_0		<=	1
							status_o	<=	logoutSent;
						end else begin	
							address_o	<=	add...
							we_0		<=	1
							status_o	<=	resendReqSent;
						end 	
					end
		end

	end

always @ (posedge clk) begin

	if (connected_i == 1) begin
		sendLogon	<=	'1;
		address_o	<=	add...
		we_0		<=	1
		status_o	<=	logonSent;
	end

	if (end_session == 1) begin
		sendLogout	<=	'1;
		address_o	<=	add...
		we_0		<=	1
		status_o	<=	logoutSent;
	end

/*	if (send_b_a_message == 1) begin
		case (ordertype)
		


	end
*/

end


endmodule

