
`ifndef _my_const_param
`define _my_const_param

`define			NUMBER_OF_HOST			4
`define			HOST_ADDR_WIDTH			2
`define			VALUE_DATA_WIDTH		256
`define			COUNTER_RANGE			10
`define			VALUE_SIZE			64
`define			SEQ_NUM_DEPTH			80	


`define			supportedVersion  	  	24'h342e33 
`define			seqResetMsg  		  	16'h0034 
`define			logonMsg		  	8'h41 
`define			logoutMsg		  	8'h35 
`define			heartBeatMsg		  	8'h30 	
`define			resendReqMsg		  	8'h32 	

`define			msgSeqH			  	4'b0001 
`define			garbled			 	4'b0010 
`define			msgSeqL			 	4'b0001 		// low and posdupflag not set
`define			valid			 	4'b0000 
`define			invalid			 	4'b0100 		// sender/comp does'nt match...
`define			unsupportedVersion	 	4'b0011 
`define			invalidMsgType		 	4'b0110 
`define			requiredTagMissing	 	4'b0111 

// message types
`define			logon 			  	4'b0001 
`define			heartbeat		  	4'b0010 
`define			resendReq		  	4'b0011 
`define			logout 			  	4'b0100 
`define			reset			  	4'b0101 
`define			gapFill			  	4'b0110 
`define			business 		  	4'b0111 


`define			possDupFlag		 	32'h00003433 
`define			msgSeqNum		 	32'h00003334 
`define			targetCompId		 	32'h00003536 
`define			sourceCompId		 	32'h00003439 
`define			beginSeqNum		 	32'h00000037 
`define			endSeqNum		 	32'h00003136 
`define			gapFillFlag		 	32'h00313233 
`define			newSeqNum		 	32'h00003336 	
`define			heartbeatInt		 	32'h00313038 
`define			sendtime		 	32'h00003532 

// session states
`define			normalSession		 	4'b0000 
`define			disconnected		 	4'b0001 
`define			servingResend_logout	 	4'b0010 
`define			sentResendReq		 	4'b0011 
`define			sentheartbeat		 	4'b0100 
`define			resendReqLogout		 	4'b0101 
`define			servingResend		 	4'b0110 
`define			logoutSent		 	4'b0111 
`define			logonSent		 	4'b1000 


`define 		v_encryptMethod_i 	 	8'h30 	
`define 		s_v_encryptMethod_i	 	8'b00000001 	

`define 		v_senderCompId			48'h746e65696c63
`define			s_v_senderCompId		6'b111111

`define 		v_bodyLength_i		 	24'h313233 	
`define 		s_v_bodyLength_i	 	8'b00000111 	
`define 		v_beginString		 	56'h322e342e584946 	

//`define		t_beginString 		 	8'h38 			//8
//`define		t_msgType		 	16'h3533 		//35

`define			t_beginString		 	32'h00000038 
`define			t_bodylength		 	32'h00000039 
`define			t_msgType		 	32'h00003533 
`define			t_bodyLength 		 	8'h39 			//9
`define			t_msgSeqNum		 	16'h3433 		//34
`define			t_senderCompId		 	16'h3934 		//49
`define			t_sendTime		 	16'h3235 		//52
`define			t_targetCompId		 	16'h3635 		//56
`define			t_encryptMethod		 	16'h3839 		//98
`define			t_heartBeatInt		 	24'h383031 		//108
`define			t_checksum		 	16'h3031 		//10
`define			s_t_beginString 	 	5'b00001 
`define			s_t_bodyLength 		 	5'b00001 
`define			s_t_msgSeqNum 		 	5'b00011 
`define			s_t_msgType 		 	5'b00011 
`define			s_t_checksum 		 	5'b00011 
`define			s_t_senderCompId	 	5'b00011 
`define			s_t_targetCompId	 	5'b00011 
`define			s_t_sendTime		 	5'b00011 
`define			s_t_heartBeatInt	 	5'b00111 
`define			s_t_encryptMethod	 	5'b00011 
`define			s_v_sendTime		 	24'hffffff 


`define			c_t_beginString		 	32'h00000038 
`define			c_t_bodylength 		 	8'h39 			//9
`define			c_t_msgSeqNum		 	16'h3334 		//34
`define			c_t_msgType		 	32'h00003335 

`define			l_t_beginString 	 	3'b001		 
`define			l_t_bodyLength 		 	3'b001		 
`define			l_t_msgSeqNum 		 	3'b010		 
`define			l_t_msgType 		 	3'b010		
`define			l_t_checksum 		 	3'b010	 
`define			l_t_senderCompId	 	3'b010	
`define			l_t_targetCompId	 	3'b010	 
`define			l_t_sendTime		 	3'b010		 
`define			l_t_heartBeatInt	 	3'b011		
`define			l_t_encryptMethod	 	3'b010	

`define			l_v_logon		 	1'b1 
`define			l_v_logout		 	1'b1 
`define 		l_v_encryptMethod	 	1'b1 	
`define			l_v_heartbeat		 	1'b1 		// configure s_v_heartbeat with this

`define 		l_v_senderCompId	 	3'b110		// client 	
`define			l_v_sendTime		 	5'b11000		// 21- sendtimeval-const 

// value for various types of message
`define			v_logon			 	8'h61 
`define			v_heartbeat		 	8'h30 
`define			v_logout		 	8'h35 

// size of value for each types of message defied above
`define			s_v_logon		 	1'b1 
`define			s_v_heartbeat		 	1'b1 
`define			s_v_logout		 	1'b1 


`endif
