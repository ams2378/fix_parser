// note: have a small state machine between this module and create message
// as long as create message is busy, keep the new crate message order waiting
// TODO : servingResend_logout and servingResend need to be implemented
// status: compiling

`include "defines.vh"

module session_manager # (parameter NUM_HOST = `HOST_ADDR_WIDTH, VALUE_WIDTH = `VALUE_DATA_WIDTH, SIZE = `VALUE_SIZE )(

		input				clk,
		input				rst,
		input				new_message_i,			// from received msg processor
		input[3:0]	 		validity_i,			// from received msg processor
		input 				timeout_i,			// from counter
		input[NUM_HOST-1:0] 		connected_host_i,		// from connection_toe 
		input[3:0]			type_i,				// from received msg processor
		input				connected_i,			// from connection_toe 
		input 				end_session_i,			// *** now hwired to 0  
		input 				resendDone_i,			// *** now hwired to 0
		input[VALUE_WIDTH+SIZE:0]	data_out_2,			// from hostaddress table

		output reg			we_2,				// to hostaddress
		output reg[NUM_HOST-1:0]	addr_2,				// to hostaddress
		output reg[VALUE_WIDTH+SIZE:0]	data_in_2,			// to hostaddress
	
		output reg			disconnect_o,			// to toe***
		output reg[NUM_HOST-1:0] 	disconnect_host_num_o,		// to toe*** 
//		output reg[3:0]			error_type_o,			// to create message
		output reg[VALUE_WIDTH-1:0]	targetCompId_o,			// to create message
		output reg[SIZE-1:0]		s_v_targetCompId_o,		// to create message
		output reg			ignore_o,			// to sequence generator 
//		output reg			doResend_o,			// *** now ignored
//		output reg 			messagereceived_o,		// *** output interface 
		output reg 			updateSeqCounter_o,		// to sequence generator *** 
		output reg[NUM_HOST-1:0] 	seqCounterLoc_o,		// to sequence generator *** 
//		output reg 			end_session_o,			// *** no need- ignored 
		output reg[3:0]			create_message_o,		// to create message
		output reg	 		initiate_msg_o			// to create message

		);

parameter		fatal_need_manual_intervention	=	3'b001;
// need to define default error message when sending reject

// *** bellow temporarily moved from port list above
reg			doResend_o;			// *** now ignored
reg 			end_session_o;			// *** no need- ignored 
reg[3:0]		error_type_o;			// to create message
reg			messagereceived_o;


// internal vairables and reg types
reg			we_1;
reg[NUM_HOST-1:0]	addr_1;
reg[3:0]		data_in_1;
reg[3:0]		data_out_1;

/*
reg			we_2;
reg[VALUE_WIDTH-1:0]	addr_2;
reg[3:0]		data_in_2;
reg[3:0]		data_out_2;
*/

reg			resendReq_o;
reg			sendHeartbeat_o;
reg			sendLogout_o;
reg			sendLogon_o;

reg			acceptor_respond;
reg			new_message_valid;
reg			new_message_valid_1;
reg			new_message_valid_2;


parameter		state0 = 2'b00;
parameter		state1 = 2'b01;
parameter		state2 = 2'b10;

reg[1:0]		state;
reg[1:0]		next_state;

always @ (posedge clk) begin
	if(rst)		state  <= state0;
	else		state  <= next_state;
end


always @(*) begin

	state0	:	begin
					new_message_valid = '0;
				if (new_message_i == 1) begin
					new_message_valid = '1;
					next_state = state1;
				end else
					next_state = state0;
			end

	state1	:	begin
					new_message_valid = '1;
					next_state = state0;
			end
end



// instantiating session table
ram # (.ADDR_WIDTH(NUM_HOST), .DATA_WIDTH(4)) states (
		.clk	(clk),
		.we  	(we_1),
		.data	(data_in_1),
		.addr	(addr_1),
		.q	(data_out_1)
		);

// task and functions- for repeatative codes
 
// updateSessionState (connected_host_i, disconnected)
task updateSessionState;
	input[NUM_HOST-1:0]	connected_host_i; 
	input[3:0]		disconnected;

	begin
		we_1		=	'1;	
		addr_1		=	connected_host_i;
		data_in_1	=	disconnected;
	end

endtask

// readSessionState (connected_host_i)
function [3:0] readSessionState;
	input[NUM_HOST-1:0]	connected_host_i;

	begin
		we_1			=	'0;
		addr_1			=	connected_host_i;
		readSessionState	=	data_out_1;
	end

endfunction

//  getTargetCompId (connected_host_i) from hostaddress.v
function [VALUE_WIDTH-1:0] getTargetCompId;
//task getTargetCompId;
	input[NUM_HOST-1:0]	connected_host_i;

	begin
		we_2			=	'0;
		addr_2			=	connected_host_i;
		getTargetCompId		=	data_out_2 [VALUE_WIDTH-1:0];
	end
endfunction


//  get_s_v_TargetCompId (connected_host_i) from hostaddress.v
function [SIZE-1:0] get_s_v_TargetCompId;
	input[NUM_HOST-1:0]	connected_host_i;

	begin
		get_s_v_TargetCompId	=	data_out_2 [VALUE_WIDTH+SIZE-1:VALUE_WIDTH];
	end
endfunction	

// getType(connected_host_i)
function [1] getType;
	input[NUM_HOST-1:0]	connected_host_i;

	begin
		addr_2			=	connected_host_i;
		getType			=	data_out_2 [VALUE_WIDTH+SIZE];
	end
endfunction

/*
always @ (negedge clk) begin

	new_message_valid <= new_message_i;
	new_message_valid_1 <= new_message_valid;
	new_message_valid_2 <= new_message_valid_1;

end	
*/


// when a new message receiev, interrogate the session state and take proper action
always @ (posedge clk) begin

	if (rst) begin
		ignore_o		<=	'0;	
		disconnect_o		<=	'0;
		error_type_o		<=	'0;
		resendReq_o		<=	'0;
		targetCompId_o		<=	'0;
		ignore_o		<=	'0;
		doResend_o		<=	'0;
		sendHeartbeat_o		<=	'0;
		s_v_targetCompId_o	<=	'0;	
		sendLogout_o		<=	'0;
		messagereceived_o	<=	'0;
		updateSeqCounter_o	<=	'0;
		seqCounterLoc_o		<=	'0;
		disconnect_host_num_o	<=	'0;
		sendLogon_o		<=	'0;
		end_session_o		<=	'0;	
		new_message_valid	<=	'0;
	end
	
	ignore_o		<=	'0;	
	disconnect_o		<=	'0;
	error_type_o		<=	'0;
	resendReq_o		<=	'0;
//	targetCompId_o		<=	'0;
	ignore_o		<=	'0;
	doResend_o		<=	'0;
	sendHeartbeat_o		<=	'0;
//	s_v_targetCompId_o	<=	'0;	
	sendLogout_o		<=	'0;
	messagereceived_o	<=	'0;
	updateSeqCounter_o	<=	'0;
	seqCounterLoc_o		<=	'0;
	disconnect_host_num_o	<=	'0;
	sendLogon_o		<=	'0;
	end_session_o		<=	'0;
	acceptor_respond	<=	'0;

	if (new_message_valid == 1 || acceptor_respond == 1) begin
		if (validity_i == `msgSeqL || validity_i == `invalid)	begin
			disconnect_o		<=	'1;	
			disconnect_host_num_o	<=	connected_host_i;
			error_type_o		<=	fatal_need_manual_intervention;
			updateSessionState (connected_host_i, `disconnected);
		end else begin
			case (readSessionState (connected_host_i))

			`connected: 	begin
							sendLogon_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState(connected_host_i, `normalSession);		// for now keep it like that
					end

			`logonSent: 	begin
						if (type_i == `logon && validity_i == `valid) begin
							updateSessionState(connected_host_i, `normalSession);
						end else if (type_i == `logon && validity_i == `msgSeqH) begin
							resendReq_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState(connected_host_i, `sentResendReq);
						end else begin
							disconnect_o	<=	1;
							disconnect_host_num_o	<=	connected_host_i;
							updateSessionState(connected_host_i, `disconnected);
						end
					end
			`logoutSent:	begin
						if (validity_i == `garbled) begin
							ignore_o	<=	'1;
						end else if (type_i == `logout) begin
							disconnect_o	<=	'1;
							disconnect_host_num_o	<=	connected_host_i;
							updateSessionState (connected_host_i, `disconnected);
						end else if (type_i == `resendReq) begin
							doResend_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState (connected_host_i, `servingResend_logout);
						end else begin
							disconnect_o	<=	'1;
							disconnect_host_num_o	<=	connected_host_i;
							updateSessionState (connected_host_i, `disconnected);
						end
					end
			`sentheartbeat:	begin
						if (validity_i == `garbled) begin
							ignore_o	<=	'1;
						end else if ( validity_i == `msgSeqH) begin
							resendReq_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState (connected_host_i, `sentResendReq);
						//	status_o	<= 	resendReq;
						end else if (type_i == `heartbeat && validity_i == `valid) begin
							sendHeartbeat_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState (connected_host_i, `sentheartbeat);
						end else if (type_i == `logout && validity_i == `valid) begin
							sendLogout_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState (connected_host_i, `disconnected);
						end else if (type_i == `logout && validity_i == `msgSeqH) begin
							resendReq_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState (connected_host_i, `resendReqLogout);
						end else if (type_i == `resendReq) begin
							doResend_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState (connected_host_i, `servingResend);
						//	status_o	<= 	resendReq;
						end else begin
							messagereceived_o	<=	'1;		
							updateSessionState (connected_host_i, `normalSession);
						end
					end				  
			`normalSession:	begin	
						if (validity_i == `garbled) begin
							ignore_o	<=	'1;
						end else if (type_i == `logout && validity_i == `msgSeqH) begin
							resendReq_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState (connected_host_i, `resendReqLogout);
						end else if (type_i == `logout && validity_i == `valid) begin
							sendLogout_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState (connected_host_i, `disconnected);
						end else if (type_i == `resendReq) begin
							doResend_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState (connected_host_i, `servingResend);
						end else if (validity_i == `msgSeqH) begin
							resendReq_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState (connected_host_i, `sentResendReq);
						end else if (type_i == `heartbeat) begin
							sendHeartbeat_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState (connected_host_i, `sentheartbeat);
						end else begin
							messagereceived_o	<=	1;
						end
					end		
			`sentResendReq:	begin	
						if (validity_i == `garbled) begin
							ignore_o	<=	'1;
						end else if (type_i != `reset && validity_i == `msgSeqH) begin
							resendReq_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState (connected_host_i, `sentResendReq);
						end if (type_i == `gapFill || type_i == `reset) begin
							updateSeqCounter_o	<=	'1;
							seqCounterLoc_o		<=	connected_host_i;	
							updateSessionState (connected_host_i, `sentResendReq);
						end if (resendDone_i == 1) begin
							updateSessionState (connected_host_i, `normalSession);
						end else begin	
							updateSessionState (connected_host_i, `sentResendReq);
						end 	
					end
			`resendReqLogout:begin
						if (validity_i == `garbled) begin
							ignore_o	<=	'1;
						end else if (type_i != `reset && validity_i == `msgSeqH) begin
							resendReq_o	<=	'1;
					//		create_message_o <= 	`resendReq;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState (connected_host_i, `resendReqLogout);
						end if (type_i == `gapFill || type_i == `reset) begin
							updateSeqCounter_o	<=	'1;
							seqCounterLoc_o		<=	connected_host_i;	
							updateSessionState (connected_host_i, `resendReqLogout);
						end if (resendDone_i == 1) begin
							sendLogout_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
							updateSessionState (connected_host_i, `logoutSent);
						end else begin	
							updateSessionState (connected_host_i, `resendReqLogout);
						end 	
					end
			endcase
		end
	end
//end

// receive connection status for each session and initiate sending messages- logon, logout, heartbeat
// will incorporate order related message and gap fill later 
//always @ (posedge clk) begin

//	disconnect_o		<=	'0;	
//	disconnect_host_num_o	<=	'0;	
//	sendLogon_o		<=	'0;	

	if (connected_i == 1 && getType(connected_host_i) == '1) begin
		sendLogon_o	<=	'1;
		targetCompId_o	<=	getTargetCompId (connected_host_i);
		s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
		updateSessionState(connected_host_i, `logonSent);
	end else if (connected_i == 1 && getType(connected_host_i) == '0) begin
		acceptor_respond <= '1;
		updateSessionState(connected_host_i, `connected);
	end
		

	if (end_session_i == 1) begin
		sendLogout_o	<=	'1;
		targetCompId_o	<=	getTargetCompId (connected_host_i);
		s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
		updateSessionState(connected_host_i, `logoutSent);
	end


	if (timeout_i == 1) begin				// timeout corresponding to particular session
		if (readSessionState (connected_host_i) == `logonSent  || 
		    readSessionState (connected_host_i) == `logoutSent || 
		    readSessionState (connected_host_i) == `sentheartbeat) begin
			disconnect_o		<=	'1;
			disconnect_host_num_o	<=	connected_host_i;
			updateSessionState(connected_host_i, `disconnected);
		end else begin
			sendHeartbeat_o		<=	'1;
			targetCompId_o		<=	getTargetCompId (connected_host_i);
			s_v_targetCompId_o	<=	get_s_v_TargetCompId (connected_host_i);
			updateSessionState(connected_host_i, `sentheartbeat);
		end
	end

end


always @ (posedge clk) begin

//	create_message_o	<= '0;
	initiate_msg_o		<= '0;

	if (sendLogon_o) begin
		create_message_o	<=	`logon;
		initiate_msg_o		<=	'1;
	end else if (sendLogout_o) begin
		create_message_o	<=	`logout;
		initiate_msg_o		<=	'1;
	end else if (sendHeartbeat_o) begin
		create_message_o	<=	`heartbeat;
		initiate_msg_o		<=	'1;
	end else if (resendReq_o) begin
		create_message_o	<=	`resendReq;
		initiate_msg_o		<=	'1;
	end
//		initiate_msg_o		<=	(create_message_o != 4'b0000)	? 1 : 0;
		
end


endmodule

