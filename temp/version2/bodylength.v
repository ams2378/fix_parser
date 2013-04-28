
`include "defines.vh"

module bodylength #(parameter HOST_ADDR = `HOST_ADDR_WIDTH, VALUE_WIDTH = `VALUE_DATA_WIDTH)(

		input				clk,
		input				rst,
			
		input[3:0]			create_message_i,	// messagetype
		input[3:0]			l_v_msgSeqNum_i,
		input[HOST_ADDR-1:0]		target_addr_i,
		input[5:0]			l_v_targetCompId,	// 256 bits of val

		output [VALUE_WIDTH-1:0]	v_bodyLength_o,
		output				valid_o,
		output [5:0]			l_v_bodyLength_o 	// s_v_bodylength
		);


reg [VALUE_WIDTH-1:0]		length;
reg [5:0]			l_length;	 // s_v_bodylength
reg				done;
reg				start_conv;

always @ (*) begin

	start_conv	=	'0;

	case (create_message_i)
	
	`logon	:	begin
	
			start_conv	=	'1;
			length = l_t_msgSeqNum + l_v_msgSeqNum_i +
				 l_t_msgType   + `l_v_logon	 +
				 l_t_senderCompId + l_v_senderCompId +
				 l_t_sendTime  + l_v_sendTime +
				 l_t_targetCompId + l_v_targetCompId + 
				 l_t_encryptMethod + l_v_encryptMethod +
				 l_t_heartBeatInt + l_v_heartbeat;	
			end
	`logout	:	begin
			start_conv	=	'1;
			length = l_t_msgSeqNum + l_v_msgSeqNum_i +
				 l_t_msgType   + `l_v_logon	 +
				 l_t_senderCompId + l_v_senderCompId +
				 l_t_sendTime  + l_v_sendTime +
				 l_t_targetCompId + l_v_targetCompId;
			end

	`heartbeat:	begin
			start_conv	=	'1;
			length = l_t_msgSeqNum + l_v_msgSeqNum_i +
				 l_t_msgType   + `l_v_logon	 +
				 l_t_senderCompId + l_v_senderCompId +
				 l_t_sendTime  + l_v_sendTime +
				 l_t_targetCompId + l_v_targetCompId;
			end

end


binary_to_bcd # (.BITS_IN_PP(32), .BCD_DIGITS_OUT_PP(10), .BIT_COUNT_WIDTH_PP(5) ) converted 
	(
		.clk_i(clk),
		.rst_i(rst),
		.ce_i('1),
		.start_i(start_conv),
		.dat_binary_i(length),
		.done_o(done),
		.ascii_o(v_bodyLength_o),
		.size_o(l_v_bodyLength_o)
//		.width_o(width_seq_o)
	);


assign 	valid_o	=	(done == 1) ? 1 : 0;
