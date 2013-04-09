

module received_msg_processor # (parameter VALUE_WIDTH = 256, COUNTER_DEPTH = 10) (

		input				clk,
		input				rst,
		input				tag_valid_i,
		input[31:0]			tag_i,
		input[VALUE_WIDTH-1:0]		val_valid_i,
		input				val_i,
		input				start_of_message_i,
		input				end_of_message_i,
		input[COUNTER_DEPTH-1:0]	expectedSeqNum_i,
		input				checksum_validity_i,
		input				bodylength_validity_i,

		output				new_message_o,
		output[2:0]			validity_o,
		output[3:0]			type_o,
		output				resendDone_o
		)

parameter 			state0  = 8'b00000001;
parameter 			state1  = 8'b00000010;
parameter 			state2  = 8'b00000100;
parameter 			state3  = 8'b00001000;
parameter 			state4  = 8'b00010000;
parameter 			state5  = 8'b00100000;
parameter 			state6  = 8'b01000000;
parameter 			state7  = 8'b10000000;


reg[7:0]			state;
reg[7:0]			next_state;
reg[VALUE_WIDTH-1:0]		messageType;
reg[VALUE_WIDTH-1:0]		sequenceNumber;
reg[VALUE_WIDTH-1:0]		senderCompId;
reg[VALUE_WIDTH-1:0]		targetCompId;

reg[2:0]			headerOrderStatus = 3'b000;
reg[23:0]			supportedVersion  = 24'h342e33;
reg				versionNotSupported; 
 

always @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end


always @ (state or tag_valid_i or val_valid_i or start_of_message_i or end_of_message_i
	  checksum_validity_i or bodylenth_validity_i ) begin


	if (rst) begin
		
		// fill in- all zero

	end 

	case (state)
	
	state0	: begin
			if ({start_of_message, tag_valid_i} == 2'b11 ) begin
				headerOrderStatus[0] <= (tag == t_beginString) ? '1 : '0;
				next_state	=	state1;	
			end else
				next_state	=	state0;
		  end	
	state1	: begin
			if (val_valid_i == 1 ) begin
				temp_beginstring <= val_i;
				next_state	 =	state2;	
			end else
				next_state	=	state1;
		  end	
	state2	: begin
			if (tag_valid_i == 1 ) begin
				headerOrderStatus[1] <= (tag == t_bodylength) ? '1 : '0;
				next_state	=	state3;	
			end else
				next_state	=	state2;
		  end	
	state3	: begin
			if (val_valid_i == 1 ) begin
				temp_bodylength <= 	val_i;	
				next_state	=	state4;	
			end else
				next_state	=	state3;
		  end


	state4	: begin
			if (tag_valid_i == 1 ) begin
				headerOrderStatus[2] <= (tag == t_msgType) ? '1 : '0;
				next_state	=	state5;	
			end else
				next_state	=	state4;
		  end	
	state5	: begin
			if (val_valid_i == 1 ) begin
				temp_msgType    <= 	val_i;	
				next_state	=	state6;	
			end else
				next_state	=	state5;
		  end
	
	state6	: begin
			if (tag_valid_i == 1 ) begin
				case (tag_i)
				t_senderCompId : temp_senderId	<= 				



				headerOrderStatus[2] = (tag == t_msgType) ? '1 : '0;
				next_state	=	state5;	
			end else
				next_state	=	state4;
		  end	
	state7	: begin
			if (val_valid_i == 1 ) begin
				temp_msgType    = 	val_i;	
				next_state	=	state6;	
			end else
				next_state	=	state5;
		  end
	











	
	endcase







end


