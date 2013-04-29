// status: compiling- need to verify

`include "defines.vh"

module received_msg_processor # (parameter VALUE_WIDTH = `VALUE_DATA_WIDTH, COUNTER_DEPTH = `COUNTER_RANGE) (

		input				clk,
		input				rst,
		input				tag_valid_i,			// from parser
		input[31:0]			tag_i,				// from parser
		input				val_valid_i,			// from parser
		input[VALUE_WIDTH-1:0]		val_i,				// from parser
		input				start_of_message_i,		// from parser
		input				end_of_message_i,		// from parser
		input[COUNTER_DEPTH-1:0]	expectedIncomingSeqNum_i,	// from sequence generator
		input				checksum_validity_i,		// from checksum calc	

		output reg			new_message_o,			// to session manager
		output reg[2:0]			error_type_o,			// to session manager
		output reg[3:0]			type_o				// to session manager
		);

reg[31:0]			buffer_t;
reg                   		f_possDupFlag;
reg                   	   	f_msgSeqNum;
reg                      	f_targetCompId;
reg                      	f_srcCompId;
reg                      	f_beginSeqNum;
reg                      	f_endSeqNum;
reg                      	f_gapFillFlag;
reg                      	f_newSeqNum;
reg                      	f_heartbeatInt;
reg                      	f_sendTime;
reg                      	f_default;
reg[VALUE_WIDTH-1:0]            buffer_pdf;
reg[VALUE_WIDTH-1:0]            buffer_msgSeqN;
reg[VALUE_WIDTH-1:0]            buffer_tcompid;
reg[VALUE_WIDTH-1:0]            buffer_srcompid;
reg[VALUE_WIDTH-1:0]            buffer_bgsn;
reg[VALUE_WIDTH-1:0]            buffer_endsn;
reg[VALUE_WIDTH-1:0]            buffer_gff;
reg[VALUE_WIDTH-1:0]            buffer_newsqn;
reg[VALUE_WIDTH-1:0]            buffer_hrtbtint;
reg[VALUE_WIDTH-1:0]            buffer_sendtime;
reg[VALUE_WIDTH-1:0]		buffer_msgType;
reg[VALUE_WIDTH-1:0]		default_val;
reg[VALUE_WIDTH-1:0]		temp_bodylength;
reg[VALUE_WIDTH-1:0]		buffer_msgSeqNum;

reg				exit;
reg				done;
reg				end_processing;
reg				checksum_valid;

// state related variables
parameter 			state0   = 12'b000000000001;
parameter 			state1   = 12'b000000000010;
parameter 			state2   = 12'b000000000100;
parameter 			state3   = 12'b000000001000;
parameter 			state4   = 12'b000000010000;
parameter 			state5   = 12'b000000100000;
parameter 			state6   = 12'b000001000000;
parameter 			state7   = 12'b000010000000;
parameter 			state8   = 12'b000100000000;
parameter 			state9   = 12'b001000000000;
parameter 			state10  = 12'b010000000000;
parameter 			state11  = 12'b100000000000;

reg[7:0]			state;
reg[7:0]			next_state;


// checkvalidity(val_i)
function checkvalidity;
	input[VALUE_WIDTH-1:0] val;
	
	begin
		checkvalidity = '1;
	end

endfunction


// task and functions
task bufferval;
	input[VALUE_WIDTH-1:0]	val_i;
	input[31:0]		buffer_t;
		case(buffer_t) 
			`possDupFlag	: begin	
						buffer_pdf	=	val_i;
						f_possDupFlag	=	'1;
					  end
			`msgSeqNum  	: begin	
						buffer_msgSeqN	=	val_i;
						f_msgSeqNum	=	'1;
					  end
			`targetCompId	: begin
						buffer_tcompid	=	val_i;
						f_targetCompId	=	'1;
					  end
			`sourceCompId	: begin
						buffer_srcompid	=	val_i;
						f_srcCompId	=	'1;
					  end
			`beginSeqNum	: begin	
						buffer_bgsn	=	val_i;
						f_beginSeqNum	=	'1;
					  end
			`endSeqNum  	: begin	
						buffer_endsn	=	val_i;
						f_endSeqNum	=	'1;
					  end
			`gapFillFlag	: begin
						buffer_gff	=	val_i;
						f_gapFillFlag	=	'1;
					  end
			`newSeqNum	: begin
						buffer_newsqn	=	val_i;
						f_newSeqNum	=	'1;
					  end
			`heartbeatInt	: begin
						buffer_hrtbtint	=	val_i;
						f_heartbeatInt	=	'1;
					  end
			`sendtime	: begin
						buffer_sendtime	=	val_i;
						f_sendTime	=	'1;
					  end
			default		: begin
						default_val	=	val_i;
						f_default	=	'1;
					  end
			endcase
endtask

/* getType(buffer_msgType)
function[3:0] getType;
	input[31:0]	type;
	case (type)
		logonMsg	:	getType		=	logon;
		logoutMsg	:	getType		=	logout;
		heartBeatMsg	:	getType		=	heartbeat;
		seqResetMsg	:	getType		=	reset;
		resendReqMsg	:	getType		=	resendReq;
		default		:	getType		=	'0;
	endcase	
endfunction
*/

always @(posedge clk ) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end

always @ (*) begin


	if (rst) begin
		new_message_o	=	'0;
		error_type_o	=	'0;
		type_o		=	'0;
	end 

	case (state)

	// expected tag beginstring	
	state0	: begin
				end_processing		=	'0;
			if ({start_of_message_i, tag_valid_i} == 2'b11 ) begin
				if (tag_i == `t_beginString) begin
					new_message_o	=	'0;
					next_state	=	state1;
				end else begin
					new_message_o	=	'1;
					next_state	=	state0;
					error_type_o	=	`garbled;
				end
			end else
				next_state	=	state0;
		  end	

	// check if beginstring value supports fix4.3
	state1	: begin
			if (val_valid_i == 1 ) begin
				if (val_i[23:0] > `supportedVersion) begin
					next_state	=	state0;
					new_message_o	=	'1;
					error_type_o	=	`unsupportedVersion;
				end else
					next_state	=	state2;
			end else
				next_state	=	state1;
		  end	
	
	// expected tag bodylength
	state2	: begin
			if (tag_valid_i == 1 ) begin
				if (tag_i != `t_bodylength) begin
					next_state	=	state0;
					new_message_o	=	'1;
					error_type_o	=	`garbled;
				end else
					next_state	=	state3;
			end 
				next_state	=	state2;
		  end	

	// buffer bodylength for later matching
	state3	: begin
			if (val_valid_i == 1 ) begin
				temp_bodylength = 	val_i;	
				next_state	=	state4;	
			end else
				next_state	=	state3;
		  end

	// expected tag message type
	state4	: begin
			if (tag_valid_i == 1 ) begin
				if (tag_i != `t_msgType) begin
					next_state	=	state0;
					new_message_o	=	'1;
					error_type_o	=	`garbled;
				end else
					next_state	=	state5;
			end else
				next_state	=	state4;
		  end
	
	// if message type supported then buffer it, otherwise reject
	state5	: begin
			if (val_valid_i == 1 ) begin
				if (checkvalidity(val_i) == '1) begin			// need to define it
					buffer_msgType		=	val_i;
					next_state		=	state6;
				end else begin
					error_type_o	=	`invalidMsgType;		// need to send reject
					new_message_o	=	'1;
					next_state	=	state0;
				end
			end else
				next_state	=	state5;
		  end
	
	state6 : begin	if (tag_valid_i == 1 && end_of_message_i == 0) begin
				buffer_t	=	tag_i;
				next_state	=	state7;
			end else if (tag_valid_i == 1 && end_of_message_i == 1) begin
				next_state	=	state8;
			end else
				next_state	=	state6;
		 end
	state7:  begin  if (val_valid_i == 1) begin
				bufferval (buffer_t, val_i);
				next_state	=	state6;
			end else 
				next_state	=	state7;
		 end
	state8: 	next_state	=	state9;
	state9:		next_state	=	state10;
	state10:	next_state	=	state11;
	state11: begin
			end_processing		=	'1;
			checksum_valid		=	(checksum_validity_i == '1) ? '1 : '0;
			if (done == '1) begin
				next_state	=	state0;
				new_message_o	=	'1;
			end else
				next_state	=	state11;
		 end
	endcase 
end

// error checking
always @ (posedge clk) begin
	
	done		<=	'0;

if (end_processing == '1) begin
	if (buffer_msgSeqN < expectedIncomingSeqNum_i && buffer_pdf[7:0] != 8'h59) begin
		if(buffer_msgType != `seqResetMsg || (buffer_msgType == `seqResetMsg && buffer_gff[7:0] == 8'h59)) begin
			error_type_o	<=	`msgSeqL;	// serious error		// 59 - Y (set)
		end
	end else if (!checksum_valid) begin
		error_type_o	<=	`garbled;
	end else if (!(f_srcCompId && f_targetCompId && f_sendTime && f_msgSeqNum)) begin
		error_type_o	<=	`requiredTagMissing;
	end else if (buffer_msgSeqNum > expectedIncomingSeqNum_i) begin
		error_type_o	<=	`msgSeqH;
	end
		
	if (buffer_msgType == `seqResetMsg)
		type_o	<=	(buffer_gff[7:0] == 8'h59) ? `gapFill : `reset;
	else
		type_o	<=	buffer_msgType;

	done	<=	'1;
end

end

endmodule

/*
// intended to check srcId and compId validity before receiving all the remaining tag/val
if ( f_srcCompId & f_targetCompId  ) begin

	search_i	<=	'1;
	value_i		<=	{buffer_srcompid, buffer_tcompid};

	if (!found_o || (found_o == '1 && return_index_o != connected_host_addr_i)) begin
		error_type_o	<=	session_not_found;
		exit		<=	'1;	
	end
end
*/
