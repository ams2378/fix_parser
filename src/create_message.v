/**
 * @filename		create_message.v 
 *
 * @brief     	        module create fix message as specified  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies		
 */

module create_message #(parameter VALUE_WIDTH = 256, WIDTH_SIZE = 5, SEQMEM_DEPTH = 10) (
		// inputs
		input				clk,
		input				rst,
		input   			create_message_i,
		input[2:0]			message_type_i,
		input[23:0]			checksum_i,
		input[5:0] 			beginstring_i,			
		input[VALUE_WIDTH-1:0] 		senderCompId_i,		
		input[VALUE_WIDTH-1:0] 		targetCompId_i,		
		input[7:0] 			heartBeatInt_i,	
		input [WIDTH_SIZE-1:0]		sizeSenderId_i,
		input [WIDTH_SIZE-1:0]		sizeTargetId_i,
		input [SEQMEM_DEPTH-1:0]	msgSeqNum_i,

		// outputs		
		output reg			start_checksum_o,
		output reg			end_checksum_o,
		output reg[7:0]			data_o
	);


// internal variables

reg[7:0]		t_beginString 	=	8'h38;
reg[7:0]		t_bodyLength 	=	8'h39;
reg[15:0]		t_msgSeqNum	=	16'h3334;
reg[15:0]		t_msgType	=	16'h3334;
reg[15:0]		t_sourceComId	=	16'h3439;
reg[15:0]		t_sendTime	=	16'h3532;
reg[15:0]		t_targetComId	=	16'h3536;
reg[15:0]		t_encrypMethod	=	16'h3536;
reg[23:0]		t_heartBeatInt	=	24'h313038;
reg[15:0]		t_checkSum	=	16'h3130;
reg[WIDTH_SIZE-1 :0] 	temp_size;

reg[2:0] 	logon		=	3'b001;
reg[2:0]	logout		=	3'b010;
reg[2:0]	heartBeat	=	3'b011;
reg[2:0]	seqReq		=	3'b100;


// function to Convert an int to ASCII string
function [7:0] i2c;
     	input [7:0] i;
      	reg [7:0]   c;
      	begin
		case (i) 
			0 : i2c = 8'h30;
			1 : i2c = 8'h31;
			2 : i2c = 8'h32;
			3 : i2c = 8'h33;
			4 : i2c = 8'h34;
			5 : i2c = 8'h35;
			6 : i2c = 8'h36;
			7 : i2c = 8'h37;
			8 : i2c = 8'h38;
			9 : i2c = 8'h39;
			default : i2c = '0;
      		endcase
      	end
endfunction

// function to determine the BodyLength- only for administrative messages
function [7:0] bodyLen_a;
	input[2:0] type;
	reg[7:0]   b_1;
	begin
		if (type == logon) begin		// 24 : time + hb + encryption  8: SOH character + equal
			b_1 = 15 + msgSeqNum_i + sizeSenderId_i + sizeTargetId_i + 24 + 15;
			bodyLen_a = b_1; 
		end else if (type == logout) begin
			b_1 = 40;
			bodyLen_a = b_1; 
		end else if (type == heartBeat) begin
			b_1 = 60;
			bodyLen_a = b_1; 
		end else if (type == seqReq) begin
			b_1 = 100;
			bodyLen_a = b_1; 
		end
	end	
endfunction

/*
parameter 		initial_s = 2'b00;


*/







endmodule
