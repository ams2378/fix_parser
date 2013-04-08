//note: have a small state machine between this module and create message
//as long as create message is busy, keep the new crate message order waiting
// TODO : servingResend_logout and servingResend need to be implemented
// status: compiling

module session_manager # (parameter NUM_HOST = 10, VALUE_WIDTH = 256 )(

		input				clk,
		input				rst,
		input				new_message_i,
		input[2:0]	 		validity_i,
		input 				timeout_i,
		input[NUM_HOST-1:0] 		connected_host_i,
		input[2:0]			type_i,
		input				connected_i,
		input 				end_session_i,
		input 				resendDone_i,

		output reg			ignore_o,	
		output reg			disconnect_o,
		output reg[2:0]			error_type_o,
		output reg[VALUE_WIDTH-1:0]	targetCompId_o,
		output reg			igonre_o,
		output reg			doResend_o,	
		output reg 			messagereceived_o,	
		output reg 			updateSeqCounter_o,
		output reg[NUM_HOST-1:0] 	seqCounterLoc_o,
		output reg[NUM_HOST-1:0] 	disconnect_host_num_o,
		output reg 			end_session_o,
		output reg[3:0]			create_message_o,
		output reg	 		initiate_msg_o

		);

// valid status
parameter		msgSeqH		= 	3'b001;
parameter		garbled		=	3'b010;
parameter		msgSeqL		=	3'b001;		// low and posdupflag not set
parameter		valid		=	3'b000;
parameter		invalid		=	3'b100;		// sender/comp does'nt match...

// error types
parameter		fatal_need_manual_intervention	=	3'b001;


// message types
parameter		logon 		= 	4'b0001;
parameter		heartbeat	= 	4'b0010;
parameter		resendReq	= 	4'b0011;
parameter		logout 		= 	4'b0100;
parameter		reset		= 	4'b0101;
parameter		gapFill		= 	4'b0110;
parameter		business 	= 	4'b0111;

// session states
parameter		normalSession		=	4'b0000;
parameter		disconnected		=	4'b0001;
parameter		servingResend_logout	=	4'b0010;
parameter		sentResendReq		=	4'b0011;
parameter		sentheartbeat		=	4'b0100;
parameter		resendReqLogout		=	4'b0101;
parameter		servingResend		=	4'b0110;
parameter		logoutSent		=	4'b0111;
parameter		logonSent		=	4'b1000;

// internal vairables and reg types
reg			we_1;
reg[NUM_HOST-1:0]	addr_1;
reg[3:0]		data_in_1;
reg[3:0]		data_out_1;
reg			we_2;
reg[VALUE_WIDTH-1:0]	addr_2;
reg[3:0]		data_in_2;
reg[3:0]		data_out_2;

reg			resendReq_o;
reg			sendHeartbeat_o;
reg			sendLogout_o;
reg			sendLogon_o;

// instantiating session table
ram # (.ADDR_WIDTH(NUM_HOST), .DATA_WIDTH(4)) states (
		.clk	(clk),
		.we  	(we_1),
		.data	(data_in_1),
		.addr	(addr_1),
		.q	(data_out_1)
		);

ram # (.ADDR_WIDTH(NUM_HOST), .DATA_WIDTH(VALUE_WIDTH)) compid (
		.clk	(clk),
		.we  	(we_2),
		.data	(data_in_2),
		.addr	(addr_2),
		.q	(data_out_2)
		);

// task and functions- for repeatative codes 
// updateSessionState (connected_host_i, disconnected)
task updateSessionState;
	input[NUM_HOST-1:0]	connected_host_i; 
	input[3:0]		disconnected;

	begin
		we_1		<=	'1;	
		addr_1		<=	connected_host_i;
		data_in_1	<=	disconnected;
	end

endtask


// readSessionState (connected_host_i)
function readSessionState;
	input[NUM_HOST-1:0]	connected_host_i;

	begin
		we_1			=	'0;
		addr_1			=	connected_host_i;
		readSessionState	=	data_out_2;
	end

endfunction

//  getTargetCompId (connected_host_i)
function getTargetCompId;
	input[NUM_HOST-1:0]	connected_host_i;

	begin
		we_2			=	'0;
		addr_2			=	connected_host_i;
		getTargetCompId		=	data_out_2;
	end
endfunction	

// when a new message receiev, interrogate the session state and take proper action
always @ (posedge clk) begin
	
	ignore_o		<=	'0;	
	disconnect_o		<=	'0;
	error_type_o		<=	'0;
	resendReq_o		<=	'0;
	targetCompId_o		<=	'0;
	igonre_o		<=	'0;
	doResend_o		<=	'0;
	sendHeartbeat_o		<=	'0;
	sendLogout_o		<=	'0;
	messagereceived_o	<=	'0;
	updateSeqCounter_o	<=	'0;
	seqCounterLoc_o		<=	'0;
	disconnect_host_num_o	<=	'0;
	sendLogon_o		<=	'0;
	end_session_o		<=	'0;

	if (new_message_i == 1) begin
		if (validity_i == msgSeqL || validity_i == invalid)	begin
			disconnect_o		<=	'1;	
			disconnect_host_num_o	<=	connected_host_i;
			error_type_o		<=	fatal_need_manual_intervention;
			updateSessionState (connected_host_i, disconnected);
		end else begin
			case (readSessionState (connected_host_i))
			logonSent: 	begin
						if (type_i == logon && validity_i == valid) begin
							updateSessionState(connected_host_i, normalSession);
						end else if (type_i == logon && validity_i == msgSeqH) begin
							resendReq_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							updateSessionState(connected_host_i, sentResendReq);
						end else begin
							disconnect_o	<=	1;
							disconnect_host_num_o	<=	connected_host_i;
							updateSessionState(connected_host_i, disconnected);
						end
					end
			logoutSent:	begin
						if (validity_i == garbled) begin
							ignore_o	<=	'1;
						end else if (type_i == logout) begin
							disconnect_o	<=	'1;
							disconnect_host_num_o	<=	connected_host_i;
							updateSessionState (connected_host_i, disconnected);
						end else if (type_i == resendReq) begin
							doResend_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							updateSessionState (connected_host_i, servingResend_logout);
						end else begin
							disconnect_o	<=	'1;
							disconnect_host_num_o	<=	connected_host_i;
							updateSessionState (connected_host_i, disconnected);
						end
					end
			sentheartbeat:	begin
						if (validity_i == garbled) begin
							ignore_o	<=	'1;
						end else if ( validity_i == msgSeqH) begin
							resendReq_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							updateSessionState (connected_host_i, sentResendReq);
						//	status_o	<= 	resendReq;
						end else if (type_i == heartbeat && validity_i == valid) begin
							sendHeartbeat_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							updateSessionState (connected_host_i, sentheartbeat);
						end else if (type_i == logout && validity_i == valid) begin
							sendLogout_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							updateSessionState (connected_host_i, disconnected);
						end else if (type_i == logout && validity_i == msgSeqH) begin
							resendReq_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							updateSessionState (connected_host_i, resendReqLogout);
						end else if (type_i == resendReq) begin
							doResend_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							updateSessionState (connected_host_i, servingResend);
						//	status_o	<= 	resendReq;
						end else begin
							messagereceived_o	<=	'1;		
							updateSessionState (connected_host_i, normalSession);
						end
					end				  
			normalSession:	begin	
						if (validity_i == garbled) begin
							ignore_o	<=	'1;
						end else if (type_i == logout && validity_i == msgSeqH) begin
							resendReq_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							updateSessionState (connected_host_i, resendReqLogout);
						end else if (type_i == logout && validity_i == valid) begin
							sendLogout_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							updateSessionState (connected_host_i, disconnected);
						end else if (type_i == resendReq) begin
							doResend_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							updateSessionState (connected_host_i, servingResend);
						end else if (validity_i == msgSeqH) begin
							resendReq_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							updateSessionState (connected_host_i, sentResendReq);
						end else if (type_i == heartbeat) begin
							sendHeartbeat_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							updateSessionState (connected_host_i, sentheartbeat);
						end else begin
							messagereceived_o	<=	1;
						end
					end		
			sentResendReq:	begin	
						if (validity_i == garbled) begin
							ignore_o	<=	'1;
						end else if (type_i != reset && validity_i == msgSeqH) begin
							resendReq_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							updateSessionState (connected_host_i, sentResendReq);
						end if (type_i == gapFill || type_i == reset) begin
							updateSeqCounter_o	<=	'1;
							seqCounterLoc_o		<=	connected_host_i;	
							updateSessionState (connected_host_i, sentResendReq);
						end if (resendDone_i == 1) begin
							updateSessionState (connected_host_i, normalSession);
						end else begin	
							updateSessionState (connected_host_i, sentResendReq);
						end 	
					end
			resendReqLogout:begin
						if (validity_i == garbled) begin
							ignore_o	<=	'1;
						end else if (type_i != reset && validity_i == msgSeqH) begin
							resendReq_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							updateSessionState (connected_host_i, resendReqLogout);
						end if (type_i == gapFill || type_i == reset) begin
							updateSeqCounter_o	<=	'1;
							seqCounterLoc_o		<=	connected_host_i;	
							updateSessionState (connected_host_i, resendReqLogout);
						end if (resendDone_i == 1) begin
							sendLogout_o	<=	'1;
							targetCompId_o	<=	getTargetCompId (connected_host_i);
							updateSessionState (connected_host_i, logoutSent);
						end else begin	
							updateSessionState (connected_host_i, resendReqLogout);
						end 	
					end
			endcase
		end
	end
end

// receive connection status for each session and initiate sending messages- logon, logout, heartbeat
// will incorporate order related message and gap fill later 
always @ (posedge clk) begin

	disconnect_o		<=	'0;	
	targetCompId_o		<=	'0;	
	sendHeartbeat_o		<=	'0;	
	sendLogout_o		<=	'0;	
	disconnect_host_num_o	<=	'0;	
	sendLogon_o		<=	'0;	

	if (connected_i == 1) begin
		sendLogon_o	<=	'1;
		targetCompId_o	<=	getTargetCompId (connected_host_i);
		updateSessionState(connected_host_i, logonSent);
	end

	if (end_session_i == 1) begin
		sendLogout_o	<=	'1;
		targetCompId_o	<=	getTargetCompId (connected_host_i);
		updateSessionState(connected_host_i, logoutSent);
	end


	if (timeout_i == 1) begin				// timeout corresponding to particular session
		if (readSessionState (connected_host_i) == logonSent  || 
		    readSessionState (connected_host_i) == logoutSent || 
		    readSessionState (connected_host_i) == sentheartbeat) begin
			disconnect_o		<=	'1;
			disconnect_host_num_o	<=	connected_host_i;
			updateSessionState(connected_host_i, disconnected);
		end else begin
			sendHeartbeat_o		<=	'1;
			targetCompId_o		<=	getTargetCompId (connected_host_i);
			updateSessionState(connected_host_i, sentheartbeat);
		end
	end

end


always @ (posedge clk) begin

	if (sendLogon_o)
		create_message_o	<=	logon;
	else if (sendLogout_o)
		create_message_o	<=	logout;
	else if (sendHeartbeat_o)
		create_message_o	<=	heartbeat;
	else if (resendReq_o)
		create_message_o	<=	resendReq;

	initiate_msg_o		<=	(create_message_o != 4'b0000)	? 1 : 0;

end


endmodule

