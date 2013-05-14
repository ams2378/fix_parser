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
		input				fifo_full_i,			
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
		input				seq_ready_i,
		input[VALUE_WIDTH-1:0] 		v_bodyLength_i,	
		input[SIZE-1:0] 		s_v_bodyLength_i,

		input[VALUE_WIDTH-1:0] 		v_sendTime_i,			// need to update (internally)	

		input[VALUE_WIDTH-1:0]		v_msgSeqNum_i,			// from seq generator
		input[SIZE-1:0]			s_v_msgSeqNum_i,		// from seq generator

		// outputs	
		output reg			start_chksm_o,			// edit ams	
		output reg[31:0]		tag_o,
		output reg 			tag_valid_o,
		output reg[VALUE_WIDTH-1:0]	val_o,
		output reg			val_valid_o,
		output reg[SIZE-1:0]		v_size_o,
		output reg[4:0]			t_size_o,
		output reg 			checksum_o
//		output reg			msg_creation_done_o,
//		output reg			output_valid_o
	);


// **** bellow 2 moved from port list temp
reg			msg_creation_done_o;
reg			output_valid_o;

// internal variables

parameter 			state0  = 6'b000000;
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
parameter 			state39 = 6'b100111;
parameter 			state40 = 6'b101000;

reg [5:0]			state;
reg [5:0]			next_state;

// function to get value for type 
function [VALUE_WIDTH-1:0] v_msgType;
     	input [3:0] t_type;
      	begin
		case (t_type) 
			4'b0001 : v_msgType = `v_logon;
			4'b0010 : v_msgType = `v_heartbeat;
			4'b0100 : v_msgType = `v_logout;
			default : v_msgType = '0;
      		endcase
      	end
endfunction

// function to get size of value for each type 
function [VALUE_WIDTH-1:0] s_v_msgType;
     	input [3:0] t_type;
      	begin
		case (t_type) 
			4'b0001 : s_v_msgType = `s_v_logon;
			4'b0010 : s_v_msgType = `s_v_heartbeat;
			4'b0100 : s_v_msgType = `s_v_logout;
			default : s_v_msgType = '0;
      		endcase
      	end
endfunction

always @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end

//always @ (state or start_i or done_i or bodyLength_r_i or  message_type_i or end_i or seq_ready_i or fifo_full_i) begin
always @(*) begin
	if (rst) begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
	end

	case (state)
	
		// tag beginstring
	state0: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state0;
		else begin
			if (start_i == 1) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_beginString;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_beginString;	
				v_size_o		= '0;
				msg_creation_done_o 	= 	'0;
				checksum_o		= '0;
				start_chksm_o		= '0;
				output_valid_o	=	'1;
				next_state 	=	state1;
			end else begin
				val_o			=	'0;
				val_valid_o		=	'0;
				tag_o			=	'0;	
				tag_valid_o		=	'0;	
				output_valid_o		= 	'0;
				msg_creation_done_o 	= 	'0;
				t_size_o		=	'0;
				checksum_o		= '0;
				v_size_o		=	'0;
				start_chksm_o		= '0;
				next_state		=	state0;
			end
		end
		end		

		// value beginstring
	state1: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state1;
		else begin
			if (done_i == 1) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	`v_beginString;
				val_valid_o	=	'0;				// 1 to 0		
				v_size_o	=	s_v_beginString_i;	
				start_chksm_o	=	'1;				// edit ams	
				next_state 	=	state20;			// 2 to 20
			end else begin
		//		val_o		=	v_beginString;
				next_state	=	state1;
			end
		end
		end

	state20: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state20;
		else begin
				start_chksm_o	=	'0;				// edit ams	
				tag_o		=	'0;
				output_valid_o	=	'1;
				tag_valid_o	=	'0;
				val_o		=	`v_beginString;
				val_valid_o	=	'1;			
				v_size_o	=	s_v_beginString_i;		
				next_state 	=	state2;
		end
		end

		// tag bodylength
	state2: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state2;
		else begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				output_valid_o	=	'1;
				val_valid_o	=	'0;
				tag_o		=	`t_bodyLength;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_bodyLength;
				next_state 	=	state21;
			end else begin
				val_valid_o	=	'1;			
				val_o		=	`v_beginString;
				next_state	=	state2;
			end
		end
		end

	state21: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state21;
		else begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_bodyLength;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_bodyLength;
				next_state 	=	state3;
		end
		end

		// value bodylength
	state3: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state3;
		else begin
			if (done_i == 1 ) begin
		//		tag_o		=	'0;
		//		tag_valid_o	=	'0;
				next_state	=	state40;
				output_valid_o	=	'1;
		//		val_o		=	`v_bodyLength_i;
		//		val_valid_o	=	'0;
		//		v_size_o	=	`s_v_bodyLength_i;
		//		next_state 	=	state22;
			end else begin
				next_state	=	state3;
			end
		end
		end

	state40: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state40;
		else begin
			if (bodyLength_r_i == 1) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_bodyLength_i;
				val_valid_o	=	'0;
				v_size_o	=	s_v_bodyLength_i;
				next_state 	=	state22;			
			end else begin
				output_valid_o	=	'0;
				next_state	=	state40;		
			end		

		 end
		end

	state22: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state22;
		else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	v_bodyLength_i;		// edit
				val_valid_o	=	'1;			
				v_size_o	=	s_v_bodyLength_i;	// edit	
				next_state 	=	state24;
		end
		end

	// tag message type
	state24: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state24;
		else if (done_i == 1) begin						// from here to
				val_o		=	'0;
				output_valid_o	=	'1;
				val_valid_o	=	'0;
				tag_o		=	`t_msgType;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_msgType;
				next_state 	=	state25;
		end else begin								// here - modified
				tag_o		=	'0;
				output_valid_o	=	'1;
				tag_valid_o	=	'0;
				val_o		=	v_bodyLength_i;		// changed from msgtype
				val_valid_o	=	'1;			// changed to 1			
				v_size_o	=	s_v_bodyLength_i;	// changed from msgtype	
				next_state 	=	state6;
		end
		end

		// tag msgType
	state6: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state6;
		else begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				output_valid_o	=	'1;
				val_valid_o	=	'0;
				tag_o		=	`t_msgType;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_msgType;
				next_state 	=	state25;
			end else begin
				next_state	=	state6;
			end
		end
		end

	state25: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state25;
		else begin
				val_o		=	'0;
				output_valid_o	=	'1;
				val_valid_o	=	'0;
				tag_o		=	`t_msgType;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_msgType;
				next_state 	=	state7;
		end
		end


		// value msgType
	state7: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state7;
		else begin
		if (done_i == 1 ) begin
			tag_o		=	'0;
			output_valid_o	=	'1;
			tag_valid_o	=	'0;
			val_o		=	v_msgType(message_type_i);
			val_valid_o	=	'0;
			v_size_o	=	s_v_msgType(message_type_i);
			next_state 	=	state26;
		end else begin
				val_o		=	'0;
				output_valid_o	=	'1;
				val_valid_o	=	'0;
				tag_o		=	`t_msgType;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_msgType;
				next_state 	=	state7;

			next_state	=	state7;
		end
		end
		end


	state26: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state26;
		else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;	
				output_valid_o	=	'1;
				val_o		=	v_msgType(message_type_i);
				val_valid_o	=	'1;			
				v_size_o	=	s_v_msgType(message_type_i);		
				next_state 	=	state4;
		end
		end

		// tag msgSeqNumber
	state4: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state4;
		else begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_msgSeqNum;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_msgSeqNum;
				next_state 	=	state23;
			end else begin
				next_state	=	state4;
			end
		end
		end

	state23: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state23;
		else begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_msgSeqNum;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_msgSeqNum;
				next_state 	=	state5;
		end
		end

		// value msgSeqNumber
	state5: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state5;
		else begin
			if (done_i == 1 ) begin
				next_state	=	state39;
				output_valid_o	=	'1;
				tag_o		=	`t_msgSeqNum;
				t_size_o	=	`s_t_msgSeqNum;
			//	tag_o		=	'0;
				tag_valid_o	=	'0;
			//	val_o		=	v_msgSeqNum_i;
			//	val_valid_o	=	'0;
			//	v_size_o	=	s_v_msgSeqNum_i;
			//	next_state 	=	state24;
			end else begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_msgSeqNum;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_msgSeqNum;


				next_state	=	state5;
			end
		end
		end

	state39: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state39;
		else begin
			if (seq_ready_i == 1) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_msgSeqNum_i;
				val_valid_o	=	'1;
				v_size_o	=	s_v_msgSeqNum_i;
				next_state 	=	state8;			
			end else begin
				output_valid_o	=	'1;
				tag_o		=	`t_msgSeqNum;
				t_size_o	=	`s_t_msgSeqNum;
				tag_valid_o	=	'0;
				output_valid_o	=	'0;
				next_state	=	state39;		
			end		

		 end
		end


		// tag senderCompId
	state8: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state8;
		else begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_senderCompId;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_senderCompId;
				next_state 	=	state27;
			end else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_msgSeqNum_i;
				val_valid_o	=	'1;
				v_size_o	=	s_v_msgSeqNum_i;
				next_state	=	state8;
			end
		end
		end

	state27: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state27;
		else begin
				val_o		=	'0;
				output_valid_o	=	'1;
				val_valid_o	=	'0;
				tag_o		=	`t_senderCompId;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_senderCompId;
				next_state 	=	state9;
		end
		end

		// value senderComptId
	state9: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state9;
		else begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	v_senderCompId_i;
				val_valid_o	=	'0;
				v_size_o	=	s_v_senderCompId_i;
				next_state 	=	state28;
			end else begin 

				val_o		=	'0;
				output_valid_o	=	'1;
				val_valid_o	=	'0;
				tag_o		=	`t_senderCompId;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_senderCompId;

				next_state	=	state9;
			end
		end
		end

	state28: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state28;
		else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	v_senderCompId_i;
				val_valid_o	=	'1;			
				v_size_o	=	s_v_senderCompId_i;		
				next_state 	=	state10;
		end
		end

		// tag sendTime
	state10: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state10;
		else begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_sendTime;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_sendTime;
				next_state 	=	state29;
			end else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	v_senderCompId_i;
				val_valid_o	=	'1;			
				v_size_o	=	s_v_senderCompId_i;	


				next_state	=	state10;
			end
		end

		end
	state29: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state29;
		else begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_sendTime;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_sendTime;
				next_state 	=	state11;
		end

		end
		// value sendTime
	state11: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state11;
		else begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	v_sendTime_i;
				val_valid_o	=	'0;
				v_size_o	=	`s_v_sendTime;
				next_state 	=	state30;
			end else begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_sendTime;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_sendTime;
				next_state	=	state11;
			end
		end
		end

	state30: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state30;
		else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	v_sendTime_i;
				val_valid_o	=	'1;			
				v_size_o	=	`s_v_sendTime;		
				next_state 	=	state12;
		end
		end

		// tag targetCompId
	state12: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state12;
		else begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_targetCompId;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_targetCompId;
				next_state 	=	state31;
			end else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	v_sendTime_i;
				val_valid_o	=	'1;			
				v_size_o	=	`s_v_sendTime;	
				next_state	=	state12;
			end
		end
		end

	state31: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state31;
		else begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_targetCompId;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_targetCompId;
				next_state 	=	state13;
		end
		end

		// value targetCompId
	state13: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state13;
		else begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	v_targetCompId_i;
				val_valid_o	=	'0;
				v_size_o	=	s_v_targetCompId_i;
				next_state 	=	state32;
			end else begin
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_targetCompId;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_targetCompId;
				next_state	=	state13;
			end
		end
		end

	state32: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state32;
		else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	v_targetCompId_i;
				val_valid_o	=	'1;			
				v_size_o	=	s_v_targetCompId_i;		
				next_state 	=	state14;
		end
		end


		// tag encryptMethod
	state14: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state14;
		else begin
			if (done_i == 1 && (message_type_i == `heartbeat || message_type_i == `logout)) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_checksum;
				output_valid_o	=	'1;
				checksum_o	=	'0;			// from 1
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_checksum;	
				next_state 	=	state34;
			else if (done_i == 1 && (message_type_i == `neworder)) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_clorid;
				output_valid_o	=	'1;
				checksum_o	=	'0;			// from 1
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_clorid;	
				next_state 	=	state41;		// jump to state 41 for neworder
			end else if (done_i == 1) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_encryptMethod;
				output_valid_o	=	'1;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_encryptMethod;
				next_state 	=	state33;
			end else begin 
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	v_targetCompId_i;
				val_valid_o	=	'1;			
				v_size_o	=	s_v_targetCompId_i;		
				next_state	=	state14;
			end
		end
		end

	state33: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state33;
		else begin
				val_o		=	'0;
				output_valid_o	=	'1;
				val_valid_o	=	'0;
				tag_o		=	`t_encryptMethod;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_encryptMethod;
				next_state 	=	state15;
		end
		end

	state34: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state34;
		else begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_checksum;
				output_valid_o	=	'1;
				checksum_o	= 	'1;		// from 0
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_checksum;
				next_state 	=	state19;
		end
		end

		// value encryptMethod
	state15: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state15;
		else begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	`v_encryptMethod_i;
				val_valid_o	=	'0;
				v_size_o	=	`s_v_encryptMethod_i;
				next_state 	=	state35;
			end else begin
				val_o		=	'0;
				output_valid_o	=	'1;
				val_valid_o	=	'0;
				tag_o		=	`t_encryptMethod;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_encryptMethod;

				next_state	=	state15;
			end
		end
		end

	state35: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state35;
		else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	`v_encryptMethod_i;
				val_valid_o	=	'1;			
				v_size_o	=	`s_v_encryptMethod_i;		
				next_state 	=	state16;
		end

		end
		// tag heartBeatInt
	state16: begin
		tag_o		=	'0;
		tag_valid_o	=	'0;
		val_o		=	`v_encryptMethod_i;
		val_valid_o	=	'1;			
		v_size_o	=	`s_v_encryptMethod_i;		
		t_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state16;
		else begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_heartBeatInt;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_heartBeatInt;
				next_state 	=	state36;
			end else begin
				next_state	=	state16;
			end
		end
		end

	state36: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state36;
		else begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_heartBeatInt;
				tag_valid_o	=	'1;
				output_valid_o	=	'1;
				t_size_o	=	`s_t_heartBeatInt;
				next_state 	=	state17;
		end
		end


		// value heartBeatInt
	state17: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state17;
		else begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_heartBeatInt_i;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				v_size_o	=	s_v_heartBeatInt_i;
				next_state 	=	state37;
			end else begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_heartBeatInt;
				tag_valid_o	=	'1;
				output_valid_o	=	'1;
				t_size_o	=	`s_t_heartBeatInt;
				next_state	=	state17;
			end
		end
		end


	state37: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state37;
		else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_heartBeatInt_i;
				val_valid_o	=	'1;			
				output_valid_o	=	'1;
				v_size_o	=	s_v_heartBeatInt_i;		
				next_state 	=	state18;
		end
		end


		// tag checksum
	state18: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state18;
		else begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_checksum;
				checksum_o	=	'0;			//changed to 0
				output_valid_o	=	'1;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_checksum;	
				next_state 	=	state38;
			end else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_heartBeatInt_i;
				val_valid_o	=	'1;			
				output_valid_o	=	'1;
				v_size_o	=	s_v_heartBeatInt_i;	
				next_state	=	state18;
			end
		end
		end

	state38: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state38;
		else begin
				val_o		=	'0;
				output_valid_o	=	'1;
				start_chksm_o	= 	'0;
				checksum_o	= 	'1;
				val_valid_o	=	'0;
				tag_o		=	`t_checksum;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_checksum;
				next_state 	=	state19;
		end

		end
		// end of message creation
	state19:
		begin
				val_o		=	'0;
				output_valid_o	=	'1;
				start_chksm_o	= 	'0;
				checksum_o	= 	'1;
				val_valid_o	=	'0;
				tag_o		=	`t_checksum;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_checksum;
				v_size_o		= '0;
				msg_creation_done_o	=	'0;

		if (fifo_full_i == 1) 
			next_state	=	state19;
		else begin
				checksum_o	=	'0;
				output_valid_o	=	'1;
			if (end_i == 1) begin
				msg_creation_done_o	=	'1;
				next_state 		=	state0;
			end else
				next_state	=	state19;
		end
		end





// ******************************************************************************************
// *********************** N E W O R D E R S E N*********************************************
// ******************************************************************************************
// ******************************************************************************************

// -------- for new order entry -------- starts here ---------
// ----------------------------------------------------------------------------------

		// tag clorid 
	state41: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state41;
		else begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_clorid_i;
				output_valid_o	=	'1;
				checksum_o	=	'0;			// from 1
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_clorid_i;
				next_state	=	state42;	
		end
		end

		// value clorid
	state42: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state42;
		else begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	`v_clorid_i;
				val_valid_o	=	'0;
				v_size_o	=	`s_v_clorid_i;
				next_state 	=	state43;
			end else begin
				val_o		=	'0;
				output_valid_o	=	'1;
				val_valid_o	=	'0;
				tag_o		=	`t_clorid_i;
				tag_valid_o	=	'1;
				t_size_o	=	`s_t_clorid_i;
				next_state	=	state42;
			end
		end
		end

	state42: begin
		tag_o 			= '0;	
		tag_valid_o 		= '0;
		val_o 			= '0;
		val_valid_o 		= '0;
		t_size_o		= '0;
		v_size_o		= '0;
		checksum_o		= '0;
		start_chksm_o		= '0;
		msg_creation_done_o	= '0;
		output_valid_o		= '0;
		if (fifo_full_i == 1) 
			next_state	=	state35;
		else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	`v_clorid_i;
				val_valid_o	=	'1;			
				v_size_o	=	`s_v_clorid_i;		
				next_state 	=	state43;
		end

		// tag account
	state43: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	`v_clorid_i;
				val_valid_o	=	'1;			
				v_size_o	=	`s_v_clorid_i;
				t_size_o		= '0;
				checksum_o		= '0;
				start_chksm_o		= '0;
				msg_creation_done_o	= '0;
		if (fifo_full_i == 1) 
			next_state	=	state43;
		else begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	t_account;
				val_valid_o	=	'0;
				v_size_o	=	s_t_account;
				next_state 	=	state44;
			end else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	`v_clorid_i;
				val_valid_o	=	'1;			
				v_size_o	=	`s_v_clorid_i;	
				next_state	=	state43;
			end
		end
		end


// ----------------------------------------------------------------------------------

	state44: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	t_account;
				val_valid_o	=	'0;
				v_size_o	=	s_t_account;
				t_size_o		= '0;
				checksum_o		= '0;
				start_chksm_o		= '0;
				msg_creation_done_o	= '0;
		if (fifo_full_i == 1) 
			next_state	=	state44;
		else begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_account;
				tag_valid_o	=	'1;
				output_valid_o	=	'1;
				t_size_o	=	`s_t_account;
				next_state 	=	state45;
		end
		end


		// value account 
	state45: begin
				val_o			=	'0;
				val_valid_o		=	'0;
				tag_o			=	`t_account;
				tag_valid_o		=	'1;
				output_valid_o		=	'1;
				t_size_o		=	`s_t_account;
				v_size_o		=	'0;	
				checksum_o		= 	'0;
				start_chksm_o		= 	'0;
				msg_creation_done_o	= 	'0;
		if (fifo_full_i == 1) 
			next_state	=	state17;
		else begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_account;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				v_size_o	=	v_t_account;
				next_state 	=	state46;
			end else begin
				next_state	=	state45;
			end
		end
		end


	state46: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_account;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				v_size_o	=	v_t_account;
				t_size_o	=	'0;
				checksum_o		= 	'0;
				start_chksm_o		= 	'0;
				msg_creation_done_o	= 	'0;
		if (fifo_full_i == 1) 
			next_state	=	state46;
		else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_account;
				val_valid_o	=	'1;			
				output_valid_o	=	'1;
				v_size_o	=	s_v_account;		
				next_state 	=	state47;
		end
		end


	state47: begin
		tag_o			=	'0;
		tag_valid_o		=	'0;
		val_o			=	v_account;
		val_valid_o		=	'1;			
		v_size_o		=	s_v_account;				t_size_o		= '0;
		t_size_o		= 	'0;
		checksum_o		= 	'0;
		start_chksm_o		= 	'0;
		msg_creation_done_o	= 	'0;
		output_valid_o		= 	'0;
		if (fifo_full_i == 1) 
			next_state	=	state47;
		else begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_handinst;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_handinst;
				next_state 	=	state48;
			end else begin
				next_state	=	state47;
			end
		end


// ----------------------------------------------------------------------------------

	state47: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	t_handinst;
				val_valid_o	=	'0;
				v_size_o	=	s_t_handinst;
				t_size_o		= '0;
				checksum_o		= '0;
				start_chksm_o		= '0;
				msg_creation_done_o	= '0;
		if (fifo_full_i == 1) 
			next_state	=	state47;
		else begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_handinst;
				tag_valid_o	=	'1;
				output_valid_o	=	'1;
				t_size_o	=	`s_t_handinst;
				next_state 	=	state48;
		end
		end


		// value account 
	state48: begin
				val_o			=	'0;
				val_valid_o		=	'0;
				tag_o			=	`t_handinst;
				tag_valid_o		=	'1;
				t_size_o		=	`s_t_handinst;
				v_size_o		=	'0;	
				checksum_o		= 	'0;
				start_chksm_o		= 	'0;
				output_valid_o		=	'1;
				msg_creation_done_o	= 	'0;
		if (fifo_full_i == 1) 
			next_state	=	state48;
		else begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_handinst;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				v_size_o	=	s_v_handinst;
				next_state 	=	state49;
			end else begin
				next_state	=	state48;
			end
		end
		end


	state49: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_handinst;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				v_size_o	=	s_v_handinst;
				t_size_o	=	'0;
				checksum_o		= 	'0;
				start_chksm_o		= 	'0;
				msg_creation_done_o	= 	'0;
		if (fifo_full_i == 1) 
			next_state	=	state49;
		else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_handinst;
				val_valid_o	=	'1;			
				output_valid_o	=	'1;
				v_size_o	=	s_v_handinst;		
				next_state 	=	state50;
		end
		end


	state50: begin
				tag_o			=	'0;
				tag_valid_o		=	'0;
				val_o			=	v_handinst;
				val_valid_o		=	'1;			
				output_valid_o		=	'1;
				v_size_o		=	s_v_handinst;	
				t_size_o		= 	'0;
				checksum_o		= 	'0;
				start_chksm_o		= 	'0;
				msg_creation_done_o	= 	'0;
		if (fifo_full_i == 1) 
			next_state	=	state50;
		else begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_side;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_side;
				next_state 	=	state51;
			end else begin
				next_state	=	state50;
			end
		end



// ----------------------------------------------------------------------------------

	state51: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	t_side;
				val_valid_o	=	'0;
				v_size_o	=	s_t_side;
				t_size_o		= '0;
				checksum_o		= '0;
				start_chksm_o		= '0;
				msg_creation_done_o	= '0;
		if (fifo_full_i == 1) 
			next_state	=	state51;
		else begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_side;
				tag_valid_o	=	'1;
				output_valid_o	=	'1;
				t_size_o	=	`s_t_side;
				next_state 	=	state52;
		end
		end


		// value account 
	state52: begin
				val_o			=	'0;
				val_valid_o		=	'0;
				tag_o			=	`t_side;
				tag_valid_o		=	'1;
				t_size_o		=	`s_t_side;
				v_size_o		=	'0;	
				checksum_o		= 	'0;
				start_chksm_o		= 	'0;
				output_valid_o		=	'1;
				msg_creation_done_o	= 	'0;
		if (fifo_full_i == 1) 
			next_state	=	state48;
		else begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_side;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				v_size_o	=	s_v_side;
				next_state 	=	state53;
			end else begin
				next_state	=	state52;
			end
		end
		end


	state53: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_side;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				v_size_o	=	s_v_side;
				t_size_o	=	'0;
				checksum_o		= 	'0;
				start_chksm_o		= 	'0;
				msg_creation_done_o	= 	'0;
		if (fifo_full_i == 1) 
			next_state	=	state53;
		else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_side;
				val_valid_o	=	'1;			
				output_valid_o	=	'1;
				v_size_o	=	s_v_side;		
				next_state 	=	state54;
		end
		end


	state54: begin
				tag_o			=	'0;
				tag_valid_o		=	'0;
				val_o			=	v_side;
				val_valid_o		=	'1;			
				output_valid_o		=	'1;
				v_size_o		=	s_v_side;	
				t_size_o		= 	'0;
				checksum_o		= 	'0;
				start_chksm_o		= 	'0;
				msg_creation_done_o	= 	'0;
		if (fifo_full_i == 1) 
			next_state	=	state54;
		else begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_transacttime;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_transacttime;
				next_state 	=	state54;
			end else begin
				next_state	=	state55;
			end
		end

// --------------------------------------------------------------------------------


	state55: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	t_transacttime;
				val_valid_o	=	'0;
				v_size_o	=	s_t_transacttime;
				t_size_o		= '0;
				checksum_o		= '0;
				start_chksm_o		= '0;
				msg_creation_done_o	= '0;
		if (fifo_full_i == 1) 
			next_state	=	state55;
		else begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_transacttime;
				tag_valid_o	=	'1;
				output_valid_o	=	'1;
				t_size_o	=	`s_t_transacttime;
				next_state 	=	state56;
		end
		end


		// value account 
	state56: begin
				val_o			=	'0;
				val_valid_o		=	'0;
				tag_o			=	`t_transacttime;
				tag_valid_o		=	'1;
				t_size_o		=	`s_t_transacttime;
				v_size_o		=	'0;	
				checksum_o		= 	'0;
				start_chksm_o		= 	'0;
				output_valid_o		=	'1;
				msg_creation_done_o	= 	'0;
		if (fifo_full_i == 1) 
			next_state	=	state56;
		else begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_transacttime;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				v_size_o	=	s_v_transacttime;
				next_state 	=	state57;
			end else begin
				next_state	=	state56;
			end
		end
		end


	state57: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_transacttime;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				v_size_o	=	s_v_transacttime;
				t_size_o	=	'0;
				checksum_o		= 	'0;
				start_chksm_o		= 	'0;
				msg_creation_done_o	= 	'0;
		if (fifo_full_i == 1) 
			next_state	=	state57;
		else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_transacttime;
				val_valid_o	=	'1;			
				output_valid_o	=	'1;
				v_size_o	=	s_v_transacttime;		
				next_state 	=	state58;
		end
		end


	state58: begin
				tag_o			=	'0;
				tag_valid_o		=	'0;
				val_o			=	v_transacttime;
				val_valid_o		=	'1;			
				output_valid_o		=	'1;
				v_size_o		=	s_v_transacttime;	
				t_size_o		= 	'0;
				checksum_o		= 	'0;
				start_chksm_o		= 	'0;
				msg_creation_done_o	= 	'0;
		if (fifo_full_i == 1) 
			next_state	=	state58;
		else begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_ordtype;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_ordtype;
				next_state 	=	state59;
			end else begin
				next_state	=	state58;
			end
		end

// ------------------------------------------------------------------- 

	state58: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				output_valid_o	=	'1;
				val_o		=	t_ordtype;
				val_valid_o	=	'0;
				v_size_o	=	s_t_ordtype;
				t_size_o		= '0;
				checksum_o		= '0;
				start_chksm_o		= '0;
				msg_creation_done_o	= '0;
		if (fifo_full_i == 1) 
			next_state	=	state58;
		else begin
				val_o		=	'0;
				val_valid_o	=	'0;
				tag_o		=	`t_ordtype;
				tag_valid_o	=	'1;
				output_valid_o	=	'1;
				t_size_o	=	`s_t_ordtype;
				next_state 	=	state59;
		end
		end


		// value account 
	state59: begin
				val_o			=	'0;
				val_valid_o		=	'0;
				tag_o			=	`t_ordtype;
				tag_valid_o		=	'1;
				t_size_o		=	`s_t_ordtype;
				v_size_o		=	'0;	
				checksum_o		= 	'0;
				start_chksm_o		= 	'0;
				output_valid_o		=	'1;
				msg_creation_done_o	= 	'0;
		if (fifo_full_i == 1) 
			next_state	=	state59;
		else begin
			if (done_i == 1 ) begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_ordtype;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				v_size_o	=	s_v_ordtype;
				next_state 	=	state60;
			end else begin
				next_state	=	state59;
			end
		end
		end


	state60: begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_ordtype;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				v_size_o	=	s_v_ordtype;
				t_size_o	=	'0;
				checksum_o		= 	'0;
				start_chksm_o		= 	'0;
				msg_creation_done_o	= 	'0;
		if (fifo_full_i == 1) 
			next_state	=	state60;
		else begin
				tag_o		=	'0;
				tag_valid_o	=	'0;
				val_o		=	v_ordtype;
				val_valid_o	=	'1;			
				output_valid_o	=	'1;
				v_size_o	=	s_v_ordtype;		
				next_state 	=	state61;
		end
		end


	state61: begin
				tag_o			=	'0;
				tag_valid_o		=	'0;
				val_o			=	v_ordtype;
				val_valid_o		=	'1;			
				output_valid_o		=	'1;
				v_size_o		=	s_v_ordtype;	
				t_size_o		= 	'0;
				checksum_o		= 	'0;
				start_chksm_o		= 	'0;
				msg_creation_done_o	= 	'0;
		if (fifo_full_i == 1) 
			next_state	=	state61;
		else begin
			if (done_i == 1 ) begin
				val_o		=	'0;
				val_valid_o	=	'0;
				output_valid_o	=	'1;
				tag_o		=	`t_checksum;
				tag_valid_o	=	'0;
				t_size_o	=	`s_t_checksum;
				next_state 	=	state34;
			end else begin
				next_state	=	state61;
			end
		end




	endcase

end





endmodule
