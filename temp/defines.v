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

f_possDupFlag
f_msgSeqNum
f_targetCompId
f_srcCompId
f_beginSeqNum
f_endSeqNum
f_gapFillFlag
f_nextSeqNum
f_heartbeatInt
f_sendTime
f_default

buffer_pdf
buffer_msgSeqN
buffer_tcompid
buffer_srcompid
buffer_bgsn
buffer_endsn
buffer_gff
buffer_nextsqn
buffer_hrtbtint
buffer_sendtime
default_val


expectedIncomingSeqNum_i


unsupportedVersion
garbled -
invalidMsgType
msgSeeqL -
requiredTagMissing
msgSeqH -
