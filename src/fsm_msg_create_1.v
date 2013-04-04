parameter 			state0  = 5'b00000;
parameter 			state1  = 5'b00001;
parameter 			state2  = 5'b00010;
parameter 			state3  = 5'b00011;
parameter 			state4  = 5'b00100;
parameter 			state5  = 5'b00101;
parameter 			state6  = 5'b00110;
parameter 			state7  = 5'b00111;
parameter 			state8  = 5'b01000;
parameter 			state9  = 5'b01001;
parameter 			state10 = 5'b01010;
parameter 			state11 = 5'b01011;
parameter 			state12 = 5'b01100;
parameter 			state13 = 5'b01101;
parameter 			state14 = 5'b01110;
parameter 			state15 = 5'b01111;
parameter 			state16 = 5'b10000;
parameter 			state17 = 5'b10001;
parameter 			state18 = 5'b10010;
parameter 			state19 = 5'b10011;

reg [4:0]			state;
reg [4:0]			next_state;



always @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end


always @ (state or start_i or type_i or done_i or bodylen_ready) begin

	if (rst) begin
		tag_o 		= '0;	
		tag_valid_o 	= '0;
		val_o 		= '0;
		val_valid_o 	= '0;
		size_o		= '0;
		checksum_o	= '0;
		end_o		= '0;
	end

	case (state)

	state0: begin
		if (start_i == 1) begin
			val_o		=	'0;
			end_o		=	'0;
			val_valid_o	=	'0;
			tag_o		=	t_beginString;
			tag_valid_o	=	'1;
			t_size_o	=	s_t_beginString;	
			next_state 	=	state1;
		end else begin
			next_state	=	state0;
		end

	state1: begin
		if (done_i == 1) begin
			tag_o		=	'0;
			end_o		=	'0;
			tag_valid_o	=	'0;
			val_o		=	v_beginString_i;
			val_valid_o	=	'1;
			v_size_o	=	s_v_beginString;		
			next_state 	=	state2;
		end else begin
			next_state	=	state1;
		end

	state2: begin
		if (done_i == 1 ) begin
			val_o		=	'0;
			end_o		=	'0;
			val_valid_o	=	'0;
			tag_o		=	t_bodyLength;
			tag_valid_o	=	'1;
			t_size_o	=	s_t_bodyLength;
			next_state 	=	state3;
		end else begin
			next_state	=	state2;
		end

	state3: begin
		if (done_i == 1 && bodyLength_r == 1) begin
			tag_o		=	'0;
			end_o		=	'0;
			tag_valid_o	=	'0;
			val_o		=	v_bodyLength;
			val_valid_o	=	'1;
			v_size_o	=	s_v_bodyLength;
			next_state 	=	state4;
		end else begin
			next_state	=	state3;
		end

	state4: begin
		if (done_i == 1 ) begin
			val_o		=	'0;
			val_valid_o	=	'0;
			end_o		=	'0;
			tag_o		=	t_msgSeqNum;
			tag_valid_o	=	'1;
			t_size_o	=	s_t_msgSeqNum;
			next_state 	=	state5;
		end else begin
			next_state	=	state4;
		end

	state5: begin
		if (done_i == 1 ) begin
			tag_o		=	'0;
			tag_valid_o	=	'0;
			end_o		=	'0;
			val_o		=	v_msgSeqNum;
			val_valid_o	=	'1;
			v_size_o	=	s_v_msgSeqNum;
			next_state 	=	state6;
		end else begin
			next_state	=	state5;
		end

	state6: begin
		if (done_i == 1 ) begin
			val_o		=	'0;
			val_valid_o	=	'0;
			end_o		=	'0;
			tag_o		=	t_msgType;
			tag_valid_o	=	'1;
			t_size_o	=	s_t_msgType;
			next_state 	=	state7;
		end else begin
			next_state	=	state6;
		end

	state7: begin
		if (done_i == 1 ) begin
			tag_o		=	'0;
			end_o		=	'0;
			tag_valid_o	=	'0;
			val_o		=	v_msgType;
			val_valid_o	=	'1;
			v_size_o	=	s_v_msgType;
			next_state 	=	state6;
		end else begin
			next_state	=	state7;
		end

	state8: begin
		if (done_i == 1 ) begin
			val_o		=	'0;
			val_valid_o	=	'0;
			end_o		=	'0;
			tag_o		=	t_senderCompId;
			tag_valid_o	=	'1;
			t_size_o	=	s_t_senderCompId;
			next_state 	=	state9;
		end else begin
			next_state	=	state8;
		end

	state9: begin
		if (done_i == 1 ) begin
			tag_o		=	'0;
			end_o		=	'0;
			tag_valid_o	=	'0;
			val_o		=	v_senderCompId_i;
			val_valid_o	=	'1;
			v_size_o	=	s_v_senderCompId;
			next_state 	=	state10;
		end else begin
			next_state	=	state9;
		end

	state10: begin
		if (done_i == 1 ) begin
			val_o		=	'0;
			val_valid_o	=	'0;
			end_o		=	'0;
			tag_o		=	t_sendTime;
			tag_valid_o	=	'1;
			t_size_o	=	s_t_sendTime;
			next_state 	=	state11;
		end else begin
			next_state	=	state10;
		end

	state11: begin
		if (done_i == 1 ) begin
			tag_o		=	'0;
			tag_valid_o	=	'0;
			end_o		=	'0;
			val_o		=	v_sendTime;
			val_valid_o	=	'1;
			v_size_o	=	s_v_sendTime;
			next_state 	=	state12;
		end else begin
			next_state	=	state11;
		end

	state12: begin
		if (done_i == 1 ) begin
			val_o		=	'0;
			val_valid_o	=	'0;
			end_o		=	'0;
			tag_o		=	t_targetCompId;
			tag_valid_o	=	'1;
			t_size_o	=	s_t_targetCompId;
			next_state 	=	state13;
		end else begin
			next_state	=	state12;
		end

	state13: begin
		if (done_i == 1 ) begin
			tag_o		=	'0;
			end_o		=	'0;
			tag_valid_o	=	'0;
			val_o		=	v_targetCompId_i;
			val_valid_o	=	'1;
			v_size_o	=	s_v_targetCompId;
			next_state 	=	state14;
		end else begin
			next_state	=	state14;
		end

	state14: begin
		if (done_i == 1 ) begin
			val_o		=	'0;
			val_valid_o	=	'0;
			end_o		=	'0;
			tag_o		=	t_encryptMethod;
			tag_valid_o	=	'1;
			t_size_o	=	s_t_encryptMethod;
			next_state 	=	state15;
		end else begin
			next_state	=	state14;
		end

	state15: begin
		if (done_i == 1 ) begin
			tag_o		=	'0;
			end_o		=	'0;
			tag_valid_o	=	'0;
			val_o		=	v_encryptMethod;
			val_valid_o	=	'1;
			v_size_o	=	s_v_encryptMethod;
			next_state 	=	state16;
		end else begin
			next_state	=	state15;
		end

	state16: begin
		if (done_i == 1 ) begin
			val_o		=	'0;
			val_valid_o	=	'0;
			end_o		=	'0;
			tag_o		=	t_heartBeatInt;
			tag_valid_o	=	'1;
			t_size_o	=	s_t_heartBeatInt;
			next_state 	=	state17;
		end else begin
			next_state	=	state16;
		end

	state17: begin
		if (done_i == 1 ) begin
			tag_o		=	'0;
			end_o		=	'0;
			tag_valid_o	=	'0;
			val_o		=	v_heartBeatInt_i;
			val_valid_o	=	'1;
			v_size_o	=	s_v_heartBeatInt;
			next_state 	=	state17;
		end else begin
			next_state	=	state18;
		end

	state18: begin
		if (done_i == 1 ) begin
			val_o		=	'0;
			end_o		=	'0;
			val_valid_o	=	'0;
			tag_o		=	t_checksum;
			size_o		=	s_t_checksum;
			checksum_o	=	'1;
			tag_valid_o	=	'1;
			t_size_o	=	s_t_checksum;	
			next_state 	=	state19;
		end else begin
			next_state	=	state18;
		end

	state19:
		begin
		if (done_i == 1) begin
			end_o		=	'1;
			next_state 	=	state0;
		end else
			next_state	=	state19;
		end
	endcase

end

