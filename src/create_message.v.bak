/**
 * @filename		create_message.v 
 *
 * @brief     	        module create fix message as specified  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies		
 *
 * @status		compiling- need to verify
 *			update bodylength, encryptmethod input type (need sep module...)
 *
 *
 *
 */


module create_message #(parameter VALUE_WIDTH = 256, SIZE = 64) (
		// inputs
		input				clk,
		input				rst,
		input				start_i,
		input				done_i,
		input				end_i,				// from create message
	//	input[2:0]			type_i,				// need to update
		input				bodyLength_r_i,			// now: 001 - logon
	//	input   			create_message_i,		// 	010 - hb	
		input[2:0]			message_type_i,			//	011 - logout
	//	input[23:0]			checksum_i,
		input[VALUE_WIDTH-1:0] 		v_beginString_i,			
		input[SIZE-1:0] 		s_v_beginString_i,			
		input[VALUE_WIDTH-1:0] 		v_senderCompId_i,		
		input[SIZE-1:0] 		s_v_senderCompId_i,		
		input[VALUE_WIDTH-1:0] 		v_targetCompId_i,		
		input[SIZE-1:0] 		s_v_targetCompId_i,		
		input[VALUE_WIDTH-1:0] 		v_heartBeatInt_i,	
		input[SIZE-1:0] 		s_v_heartBeatInt_i,
	
	//	input[VALUE_WIDTH-1:0] 		v_encryptMethod_i,	
	//	input[SIZE-1:0] 		s_v_encryptMethod_i,	
	//	input[VALUE_WIDTH-1:0] 		v_bodyLength_i,	
	//	input[SIZE-1:0] 		s_v_bodyLength_i,	

	//	input[VALUE_WIDTH-1:0] 		v_msgType_i,			// need to update (internally)	
	//	input[SIZE-1:0] 		s_v_msgType_i,			// generated from type

		input[VALUE_WIDTH-1:0] 		v_sendTime_i,			// need to update (internally)	
	//	input[SIZE-1:0] 		s_v_sendTime_i,			// generated from type

		input[VALUE_WIDTH-1:0]		v_msgSeqNum_i,
		input[SIZE-1:0]			s_v_msgSeqNum_i,

		// outputs		
		output reg[31:0]		tag_o,
		output reg 			tag_valid_o,
		output reg[VALUE_WIDTH-1:0]	val_o,
		output reg			val_valid_o,
		output reg[SIZE-1:0]		v_size_o,
		output reg[4:0]			t_size_o,
		output reg 			checksum_o,
		output reg			msg_creation_done_o
	);


// internal variables

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

// include define 
reg [2:0]			logon 		= 3'b001;
reg [2:0]			business 	= 3'b111;
reg [2:0]			logout 		= 3'b100;
reg [2:0]			heartbeat	= 3'b010;


reg[VALUE_WIDTH-1:0] 		v_encryptMethod_i 	=	8'h30;	
reg[SIZE-1:0] 			s_v_encryptMethod_i	=	8'h00000001;	

reg[VALUE_WIDTH-1:0] 		v_bodyLength_i		=	24'h313233;	
reg[SIZE-1:0] 			s_v_bodyLength_i	=	8'h00000111;	


reg[7:0]		t_beginString 		=	8'h38;
reg[7:0]		t_bodyLength 		=	8'h39;
reg[15:0]		t_msgSeqNum		=	16'h3334;
reg[15:0]		t_msgType		=	16'h3334;
reg[15:0]		t_senderCompId		=	16'h3439;
reg[15:0]		t_sendTime		=	16'h3532;
reg[15:0]		t_targetCompId		=	16'h3536;
reg[15:0]		t_encryptMethod		=	16'h3536;
reg[23:0]		t_heartBeatInt		=	24'h313038;
reg[15:0]		t_checksum		=	16'h3130;
reg[4:0]		s_t_beginString 	=	5'b00001;
reg[4:0]		s_t_bodyLength 		=	5'b00001;
reg[4:0]		s_t_msgSeqNum 		=	5'b00011;
reg[4:0]		s_t_msgType 		=	5'b00011;
reg[4:0]		s_t_checksum 		=	5'b00011;
reg[4:0]		s_t_senderCompId	=	5'b00011;
reg[4:0]		s_t_targetCompId	=	5'b00011;
reg[4:0]		s_t_sendTime		=	5'b00011;
reg[4:0]		s_t_heartBeatInt	=	5'b00111;
reg[4:0]		s_t_encryptMethod	=	5'b00011;
reg[20:0]		s_v_sendTime		=	'1;

reg [4:0]		state;
reg [4:0]		next_state;

// value for various types of message
reg[7:0]		v_logon			=	8'h61;
reg[7:0]		v_heartbeat		=	8'h30;
reg[7:0]		v_logout		=	8'h35;

// size of value for each types of message defied above
reg			s_v_logon		=	1'b1;
reg			s_v_heartbeat		=	1'b1;
reg			s_v_logout		=	1'b1;

// function to get value for type 
function [VALUE_WIDTH-1:0] v_msgType;
     	input [2:0] type;
      	begin
		case (type) 
			0 : v_msgType = v_logon;
			1 : v_msgType = v_heartbeat;
			2 : v_msgType = v_logout;
			default : v_msgType = '0;
      		endcase
      	end
endfunction

// function to get size of value for each type 
function [VALUE_WIDTH-1:0] s_v_msgType;
     	input [2:0] type;
      	begin
		case (type) 
			0 : s_v_msgType = s_v_logon;
			1 : s_v_msgType = s_v_heartbeat;
			2 : s_v_msgType = s_v_logout;
			default : s_v_msgType = '0;
      		endcase
      	end
endfunction

always @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end


always @ (state or start_i or done_i or bodyLength_r_i or  message_type_i) begin

	if (rst) begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		msg_creation_done_o	= '0;
	end

	case (state)
		
		// tag beginstring
	state0: begin
			if (start_i == 1) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	t_beginString;
				tag_valid_o	=	'1;
				t_size_o	=	s_t_beginString;	
				next_state 	=	state1;
			end else begin
				next_state	=	state0;
			end
		end		

		// value beginstring
	state1: begin
			if (done_i == 1) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_beginString_i;
				val_valid_o	=	'1;
				v_size_o	=	s_v_beginString_i;		
				next_state 	=	state2;
			end else begin
				next_state	=	state1;
			end
		end
	
		// tag bodylength
	state2: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	t_bodyLength;
				tag_valid_o	=	'1;
				t_size_o	=	s_t_bodyLength;
				next_state 	=	state3;
			end else begin
				next_state	=	state2;
			end
		end

		// value bodylength
	state3: begin
			if (done_i == 1 && bodyLength_r_i == 1) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_bodyLength_i;
				val_valid_o	=	'1;
				v_size_o	=	s_v_bodyLength_i;
				next_state 	=	state4;
			end else begin
				next_state	=	state3;
			end
		end

		// tag msgSeqNumber
	state4: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	t_msgSeqNum;
				tag_valid_o	=	'1;
				t_size_o	=	s_t_msgSeqNum;
				next_state 	=	state5;
			end else begin
				next_state	=	state4;
			end
		end


		// value msgSeqNumber
	state5: begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_msgSeqNum_i;
				val_valid_o	=	'1;
				v_size_o	=	s_v_msgSeqNum_i;
				next_state 	=	state6;
			end else begin
				next_state	=	state5;
			end
		end

		// tag msgType
	state6: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	t_msgType;
				tag_valid_o	=	'1;
				t_size_o	=	s_t_msgType;
				next_state 	=	state7;
			end else begin
				next_state	=	state6;
			end
		end

		// value msgType
	state7: begin
		if (done_i == 1 ) begin
			tag_o		=	'0;
			tag_valid_o	=	'0;
			val_o		=	v_msgType(message_type_i);
			val_valid_o	=	'1;
			v_size_o	=	s_v_msgType(message_type_i);
			next_state 	=	state6;
		end else begin
			next_state	=	state7;
		end
		end

		// tag senderCompId
	state8: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	t_senderCompId;
				tag_valid_o	=	'1;
				t_size_o	=	s_t_senderCompId;
				next_state 	=	state9;
			end else begin
				next_state	=	state8;
			end
		end

		// value senderComptId
	state9: begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_senderCompId_i;
				val_valid_o	=	'1;
				v_size_o	=	s_v_senderCompId_i;
				next_state 	=	state10;
			end else begin
				next_state	=	state9;
			end
		end

		// tag sendTime
	state10: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	t_sendTime;
				tag_valid_o	=	'1;
				t_size_o	=	s_t_sendTime;
				next_state 	=	state11;
			end else begin
				next_state	=	state10;
			end
		end

		// value sendTime
	state11: begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_sendTime_i;
				val_valid_o	=	'1;
				v_size_o	=	s_v_sendTime;
				next_state 	=	state12;
			end else begin
				next_state	=	state11;
			end
		end

		// tag targetCompId
	state12: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	t_targetCompId;
				tag_valid_o	=	'1;
				t_size_o	=	s_t_targetCompId;
				next_state 	=	state13;
			end else begin
				next_state	=	state12;
			end
		end

		// value targetCompId
	state13: begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_targetCompId_i;
				val_valid_o	=	'1;
				v_size_o	=	s_v_targetCompId_i;
				next_state 	=	state14;
			end else begin
				next_state	=	state14;
			end
		end

		// tag encryptMethod
	state14: begin
			if (done_i == 1 && (message_type_i == heartbeat || message_type_i == logout)) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	t_checksum;
				checksum_o	=	'1;
				tag_valid_o	=	'1;
				t_size_o	=	s_t_checksum;	
				next_state 	=	state19;
			end else if (done_i == 1 && message_type_i == logout) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	t_encryptMethod;
				tag_valid_o	=	'1;
				t_size_o	=	s_t_encryptMethod;
				next_state 	=	state15;
			end else begin
				next_state	=	state14;
			end
		end

		// value encryptMethod
	state15: begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_encryptMethod_i;
				val_valid_o	=	'1;
				v_size_o	=	s_v_encryptMethod_i;
				next_state 	=	state16;
			end else begin
				next_state	=	state15;
			end
		end

		// tag heartBeatInt
	state16: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	t_heartBeatInt;
				tag_valid_o	=	'1;
				t_size_o	=	s_t_heartBeatInt;
				next_state 	=	state17;
			end else begin
				next_state	=	state16;
			end
		end

		// value heartBeatInt
	state17: begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_heartBeatInt_i;
				val_valid_o	=	'1;
				v_size_o	=	s_v_heartBeatInt_i;
				next_state 	=	state17;
			end else begin
				next_state	=	state18;
			end
		end

		// tag checksum
	state18: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	t_checksum;
				checksum_o	=	'1;
				tag_valid_o	=	'1;
				t_size_o	=	s_t_checksum;	
				next_state 	=	state19;
			end else begin
				next_state	=	state18;
			end
		end

		// end of message creation
	state19:
		begin
			if (end_i == 1) begin
				msg_creation_done_o	=	'1;
				next_state 		=	state0;
			end else
				next_state	=	state19;
		end
	endcase

end





endmodule
