
`include "defines.vh"

module bodylength #(parameter HOST_ADDR = `HOST_ADDR_WIDTH, MAX_SIZE = 80, VALUE_WIDTH = `VALUE_DATA_WIDTH)(

		input				clk,
		input				rst,
		input				start_i,
			
		input[3:0]			create_message_i,	// messagetype
		input[3:0]			l_v_msgSeqNum_i,
		input[5:0]			l_v_targetCompId,	// 256 bits of val
		
		output wire [7:0]		msg_length_bin_o,
		output reg[MAX_SIZE-1:0]	v_bodyLength_o,
		output				valid_o,
		output[9:0]			s_v_bodyLength_o 	// s_v_bodylength
		);


reg [32-1:0]			length;
reg [5:0]			l_length;	 // s_v_bodylength
reg				done;
reg				start_conv;
integer				k;
reg [3:0]			width;
reg[MAX_SIZE-1:0]		v_bodyLength_temp;
wire[40-1:0]			dat_bcd;

always @ (*) begin

	start_conv	=	'0;

	if (start_i == 1) begin
		case (create_message_i)
		
		`logon	:	begin
				start_conv	=	'1;
				length = `l_t_msgSeqNum + l_v_msgSeqNum_i +
					 `l_t_msgType   + `l_v_logon	 +
					 `l_t_senderCompId + `l_v_senderCompId +
					 `l_t_sendTime  + `l_v_sendTime +
					 `l_t_targetCompId + l_v_targetCompId + 
					 `l_t_encryptMethod + `l_v_encryptMethod +
					 `l_t_heartBeatInt + `l_v_heartbeat + 8'd13;	
				end
		`logout	:	begin
				start_conv	=	'1;
				length = `l_t_msgSeqNum + l_v_msgSeqNum_i +
					 `l_t_msgType   + `l_v_logon	 +
					 `l_t_senderCompId + `l_v_senderCompId +
					 `l_t_sendTime  + `l_v_sendTime +
					 `l_t_targetCompId + l_v_targetCompId + 8'd10;
				end
		`heartbeat:	begin
				start_conv	=	'1;
				length = `l_t_msgSeqNum + l_v_msgSeqNum_i +
					 `l_t_msgType   + `l_v_logon	 +
					 `l_t_senderCompId + `l_v_senderCompId +
					 `l_t_sendTime  + `l_v_sendTime +
					 `l_t_targetCompId + l_v_targetCompId + 8'd10;
				end
		endcase
	end

end

always @(*) begin
		v_bodyLength_o		=  '0;
	for (k = 0; k<10; k=k+1) begin
		v_bodyLength_o[k*8 +: 8] = v_bodyLength_temp[8*(width-1-k) +: 8];	
	end
end


binary_to_bcd # (.BITS_IN_PP(32), .BCD_DIGITS_OUT_PP(10), .BIT_COUNT_WIDTH_PP(5) ) converted 
	(
		.clk_i(clk),
		.rst_i(rst),
		.ce_i('1),
		.start_i(start_conv),
		.dat_binary_i(length),
		.dat_bcd_o( dat_bcd),
		.done_o(done),
		.ascii_o(v_bodyLength_temp),
		.size_o( s_v_bodyLength_o),
		.width_o(width)
	);


assign 	valid_o			=	(done == 1) ? 1 : 0;
assign  msg_length_bin_o	=	length[7:0];	

endmodule
