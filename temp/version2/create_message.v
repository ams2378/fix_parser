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

`include "defines.vh"

module create_message #(parameter VALUE_WIDTH = `VALUE_DATA_WIDTH, SIZE = 64) (
		// inputs
		input				clk,
		input				rst,
		input				start_i,
		input				done_i,
		input				end_i,				
		input				bodyLength_r_i,			
		input[3:0]			message_type_i,			
		input[VALUE_WIDTH-1:0] 		v_beginString_i,			
		input[SIZE-1:0] 		s_v_beginString_i,			
		input[VALUE_WIDTH-1:0] 		v_senderCompId_i,		// will be hardcoded		
		input[SIZE-1:0] 		s_v_senderCompId_i,		// will be hardcoded		
		input[VALUE_WIDTH-1:0] 		v_targetCompId_i,		
		input[SIZE-1:0] 		s_v_targetCompId_i,		
		input[VALUE_WIDTH-1:0] 		v_heartBeatInt_i,	
		input[SIZE-1:0] 		s_v_heartBeatInt_i,
	
		input[VALUE_WIDTH-1:0] 		v_sendTime_i,			// need to update (internally)	

		input[VALUE_WIDTH-1:0]		v_msgSeqNum_i,			// from seq generator
		input[SIZE-1:0]			s_v_msgSeqNum_i,		// from seq generator

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
parameter 			state1  = 6'b000001;
parameter 			state2  = 6'b000010;
parameter 			state3  = 6'b000011;
parameter 			state4  = 6'b000100;
parameter 			state5  = 6'b000101;
parameter 			state6  = 6'b000110;
parameter 			state7  = 6'b000111;
parameter 			state8  = 6'b001000;
parameter 			state9  = 6'b001001;
parameter 			state10 = 6'b001010;
parameter 			state11 = 6'b001011;
parameter 			state12 = 6'b001100;
parameter 			state13 = 6'b001101;
parameter 			state14 = 6'b001110;
parameter 			state15 = 6'b001111;
parameter 			state16 = 6'b010000;
parameter 			state17 = 6'b010001;
parameter 			state18 = 6'b010010;
parameter 			state19 = 6'b010011;
parameter 			state20 = 6'b010100;
parameter 			state21 = 6'b010101;
parameter 			state22 = 6'b010110;
parameter 			state23 = 6'b010111;
parameter 			state24 = 6'b011000;
parameter 			state25 = 6'b011001;
parameter 			state26 = 6'b011010;
parameter 			state27 = 6'b011011;
parameter 			state28 = 6'b011100;
parameter 			state29 = 6'b011101;
parameter 			state30 = 6'b011110;
parameter 			state31 = 6'b011111;
parameter 			state32 = 6'b100000;
parameter 			state33 = 6'b100001;
parameter 			state34 = 6'b100010;
parameter 			state35 = 6'b100011;
parameter 			state36 = 6'b100100;
parameter 			state37 = 6'b100101;
parameter 			state38 = 6'b100110;

reg [5:0]			state;
reg [5:0]			next_state;

// function to get value for type 
function [VALUE_WIDTH-1:0] v_msgType;
     	input [3:0] t_type;
      	begin
		case (t_type) 
			3'b001 : v_msgType = `v_logon;
			3'b010 : v_msgType = `v_heartbeat;
			3'b100 : v_msgType = `v_logout;
			default : v_msgType = '0;
      		endcase
      	end
endfunction

// function to get size of value for each type 
function [VALUE_WIDTH-1:0] s_v_msgType;
     	input [3:0] t_type;
      	begin
		case (t_type) 
			3'b001 : s_v_msgType = `s_v_logon;
			3'b010 : s_v_msgType = `s_v_heartbeat;
			3'b100 : s_v_msgType = `s_v_logout;
			default : s_v_msgType = '0;
      		endcase
      	end
endfunction

always @(posedge clk or rst) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end

always @ (state or start_i or done_i or bodyLength_r_i or  message_type_i or end_i) begin

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
				tag_o		=	`t_beginString;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_beginString;	
				msg_creation_done_o 	= 	'0;
				next_state 	=	state1;
			end else begin
				val_o			=	'0;
				val_valid_o		=	'0;
				tag_o			=	'0;	
				tag_valid_o		=	'0;	
				msg_creation_done_o 	= 	'0;
				t_size_o		=	'0;
				v_size_o		=	'0;
				next_state		=	state0;
			end
		end		

		// value beginstring
	state1: begin
			if (done_i == 1) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	`v_beginString;
				val_valid_o	=	'0;				// 1 to 0		
				v_size_o	=	s_v_beginString_i;		
				next_state 	=	state20;			// 2 to 20
			end else begin
		//		val_o		=	v_beginString;
				next_state	=	state1;
			end
		end

	state20: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	`v_beginString;
				val_valid_o	=	'1;			
				v_size_o	=	s_v_beginString_i;		
				next_state 	=	state2;
		end

		// tag bodylength
	state2: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_bodyLength;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_bodyLength;
				next_state 	=	state21;
			end else begin
		//		val_valid_o	=	'1;			
		//		val_o		=	v_beginString;
				next_state	=	state2;
			end
		end

	state21: begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_bodyLength;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_bodyLength;
				next_state 	=	state3;
		end

		// value bodylength
	state3: begin
			if (done_i == 1 && bodyLength_r_i == 1) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	`v_bodyLength_i;
				val_valid_o	=	'0;
				v_size_o	=	`s_v_bodyLength_i;
				next_state 	=	state22;
			end else begin
				next_state	=	state3;
			end
		end

	state22: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	`v_bodyLength_i;
				val_valid_o	=	'1;			
				v_size_o	=	`s_v_bodyLength_i;		
				next_state 	=	state4;
		end

		// tag msgSeqNumber
	state4: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_msgSeqNum;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_msgSeqNum;
				next_state 	=	state23;
			end else begin
				next_state	=	state4;
			end
		end

	state23: begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_msgSeqNum;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_msgSeqNum;
				next_state 	=	state5;
		end

		// value msgSeqNumber
	state5: begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_msgSeqNum_i;
				val_valid_o	=	'0;
				v_size_o	=	s_v_msgSeqNum_i;
				next_state 	=	state24;
			end else begin
				next_state	=	state5;
			end
		end

	state24: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_msgSeqNum_i;
				val_valid_o	=	'1;			
				v_size_o	=	s_v_msgSeqNum_i;		
				next_state 	=	state6;
		end

		// tag msgType
	state6: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_msgType;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_msgType;
				next_state 	=	state25;
			end else begin
				next_state	=	state6;
			end
		end

	state25: begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_msgType;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_msgType;
				next_state 	=	state7;
		end


		// value msgType
	state7: begin
		if (done_i == 1 ) begin
			tag_o		=	'0;
			tag_valid_o	=	'0;
			val_o		=	v_msgType(message_type_i);
			val_valid_o	=	'0;
			v_size_o	=	s_v_msgType(message_type_i);
			next_state 	=	state26;
		end else begin
			next_state	=	state7;
		end
		end


	state26: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_msgType(message_type_i);
				val_valid_o	=	'1;			
				v_size_o	=	s_v_msgType(message_type_i);		
				next_state 	=	state8;
		end

		// tag senderCompId
	state8: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_senderCompId;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_senderCompId;
				next_state 	=	state27;
			end else begin
				next_state	=	state8;
			end
		end

	state27: begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_senderCompId;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_senderCompId;
				next_state 	=	state9;
		end

		// value senderComptId
	state9: begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_senderCompId_i;
				val_valid_o	=	'0;
				v_size_o	=	s_v_senderCompId_i;
				next_state 	=	state28;
			end else begin
				next_state	=	state9;
			end
		end

	state28: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_senderCompId_i;
				val_valid_o	=	'1;			
				v_size_o	=	s_v_senderCompId_i;		
				next_state 	=	state10;
		end

		// tag sendTime
	state10: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_sendTime;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_sendTime;
				next_state 	=	state29;
			end else begin
				next_state	=	state10;
			end
		end

	state29: begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_sendTime;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_sendTime;
				next_state 	=	state11;
		end

		// value sendTime
	state11: begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_sendTime_i;
				val_valid_o	=	'0;
				v_size_o	=	`s_v_sendTime;
				next_state 	=	state30;
			end else begin
				next_state	=	state11;
			end
		end

	state30: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_sendTime_i;
				val_valid_o	=	'1;			
				v_size_o	=	`s_v_sendTime;		
				next_state 	=	state12;
		end

		// tag targetCompId
	state12: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_targetCompId;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_targetCompId;
				next_state 	=	state31;
			end else begin
				next_state	=	state12;
			end
		end

	state31: begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_targetCompId;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_targetCompId;
				next_state 	=	state13;
		end

		// value targetCompId
	state13: begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_targetCompId_i;
				val_valid_o	=	'0;
				v_size_o	=	s_v_targetCompId_i;
				next_state 	=	state32;
			end else begin
				next_state	=	state13;
			end
		end

	state32: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_targetCompId_i;
				val_valid_o	=	'1;			
				v_size_o	=	s_v_targetCompId_i;		
				next_state 	=	state14;
		end


		// tag encryptMethod
	state14: begin
			if (done_i == 1 && (message_type_i == `heartbeat || message_type_i == `logout)) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_checksum;
				checksum_o	=	'1;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_checksum;	
				next_state 	=	state34;
			end else if (done_i == 1) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_encryptMethod;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_encryptMethod;
				next_state 	=	state33;
			end else begin
				next_state	=	state14;
			end
		end

	state33: begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_encryptMethod;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_encryptMethod;
				next_state 	=	state15;
		end

	state34: begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_checksum;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_checksum;
				next_state 	=	state19;
		end

		// value encryptMethod
	state15: begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	`v_encryptMethod_i;
				val_valid_o	=	'0;
				v_size_o	=	`s_v_encryptMethod_i;
				next_state 	=	state35;
			end else begin
				next_state	=	state15;
			end
		end

	state35: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	`v_encryptMethod_i;
				val_valid_o	=	'1;			
				v_size_o	=	`s_v_encryptMethod_i;		
				next_state 	=	state16;
		end

		// tag heartBeatInt
	state16: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_heartBeatInt;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_heartBeatInt;
				next_state 	=	state36;
			end else begin
				next_state	=	state16;
			end
		end

	state36: begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_heartBeatInt;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_heartBeatInt;
				next_state 	=	state17;
		end


		// value heartBeatInt
	state17: begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_heartBeatInt_i;
				val_valid_o	=	'0;
				v_size_o	=	s_v_heartBeatInt_i;
				next_state 	=	state37;
			end else begin
				next_state	=	state17;
			end
		end


	state37: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_heartBeatInt_i;
				val_valid_o	=	'1;			
				v_size_o	=	s_v_heartBeatInt_i;		
				next_state 	=	state18;
		end


		// tag checksum
	state18: begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_checksum;
				checksum_o	=	'1;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_checksum;	
				next_state 	=	state38;
			end else begin
				next_state	=	state18;
			end
		end

	state38: begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_checksum;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_checksum;
				next_state 	=	state19;
		end

		// end of message creation
	state19:
		begin
				checksum_o	=	'0;
			if (end_i == 1) begin
				msg_creation_done_o	=	'1;
				next_state 		=	state0;
			end else
				next_state	=	state19;
		end
	endcase

end





endmodule
