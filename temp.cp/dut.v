/**
 * @filename		dut.sv 
 *
 * @brief     	        A simple testbench. 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 */

module parser_test();

	reg				clk;
	reg				rst;
	reg				configure_i;
	reg				start_i;
	reg				end_session_i;
	reg				connected_i;// will be removed later-for TCP

	reg [1:0]			connectType_i;			
	reg [7:0] 			reconnectInt_i;			
	reg [15:0] 			starttime_i;			
	reg [15:0] 			endtime_i;			
	reg [5:0] 			beginstring_i;			
	reg [5:0] 			defaultApplVerId_i;		
	reg [255:0] 			senderCompId_i;		
	reg [255:0] 			targetCompId_i;		
	reg [15:0] 			hostAddr_i;			 
	reg [7:0] 			heartBeatInt_i;
	reg [64-1:0]			sizeSenderId_i;
	reg [64-1:0]			sizeTargetId_i;
	reg [64-1:0]			sizeHeartBeat_i;

	reg				response_received_i;
	reg[2:0]			packet_status_i	;
	reg[2:0]			received_msg_type_i;	
	reg				new_message_r_i;

	reg			connect_o;
	reg			send_message_o;
	reg			disconnect_o;
	reg			ignore_o;
	reg [7:0]		data_o;

top dut (
		.clk,
		.rst,
		.configure_i,
		.start_i,
		.end_session_i,
		.connected_i,// will be removed later-for TCP

		.connectType_i,			
		.reconnectInt_i,			
		.starttime_i,			
		.endtime_i,			
		.beginstring_i,			
		.defaultApplVerId_i,		
		.senderCompId_i,		
		.targetCompId_i,		
		.hostAddr_i,			 
		.heartBeatInt_i,
		.sizeSenderId_i,
		.sizeTargetId_i,
		.sizeHeartBeat_i,

		.response_received_i,
		.packet_status_i,
		.received_msg_type_i,
		.new_message_r_i,

		.connect_o,
		.send_message_o,
		.disconnect_o,
		.ignore_o,
		.data_o
	);

initial begin

int temp = 500;
int i = 0;

$vcdpluson;

#1 clk = 0;
#1 clk = 1;

rst = 1;
start_i			= '0;
configure_i		= '0;
response_received_i 	= '0;
packet_status_i 	= '0; 
received_msg_type_i 	= '0;
new_message_r_i 	= '0;

#1 clk = 0;
#1 clk = 1;

start_i	= '1;
rst = 0;

#1 clk = 0;
#1 clk = 1;

start_i	= '0;

#1 clk = 0;
#1 clk = 1;
configure_i = 1;

connectType_i		=	2'b01;					
reconnectInt_i		=	8'h77;	
starttime_i		=	16'hffff;				
endtime_i		=	16'hffff;				
beginstring_i		=	6'b100100;			
defaultApplVerId_i	=	6'b100100;	
senderCompId_i		=	48'h636c69656e74;	
targetCompId_i		=	80'h6f726465726d61746368;	
hostAddr_i		=	16'h000f;		 
heartBeatInt_i		=	8'h31;
sizeSenderId_i		=	6'b111111;
sizeTargetId_i		=	10'b1111111111;
sizeHeartBeat_i		=	2'b01;
	

#1 clk = 0;
#1 clk = 1;

configure_i	=	'0;

#1 clk = 0;
#1 clk = 1;

start_i		=	'1;

#1 clk = 0;
#1 clk = 1;

start_i	= '0;

#1 clk = 0;
#1 clk = 1;

connected_i	=	'1;

#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;

for (int i = 1; i<3; i++) begin

	while ( send_message_o != 1) begin
	#1 clk = 0;
	#1 clk = 1;

	end
	#1 clk = 0;
	#1 clk = 1;


	#1 clk = 0;
	#1 clk = 1;

	response_received_i = 1;
	packet_status_i  = 3'b001;

	#1 clk = 0;
	#1 clk = 1;

	response_received_i = 0;

	#1 clk = 0;
	#1 clk = 1;

	new_message_r_i = '1;
	received_msg_type_i = 3'b010;

	#1 clk = 0;
	#1 clk = 1;

	new_message_r_i = '0;


	#1 clk = 0;
	#1 clk = 1;

	while ( send_message_o != 1) begin
	#1 clk = 0;
	#1 clk = 1;
	end
end


	#1 clk = 0;
	#1 clk = 1;

	response_received_i = 1;
	packet_status_i  = 3'b001;

	#1 clk = 0;
	#1 clk = 1;

	response_received_i = 0;

	#1 clk = 0;
	#1 clk = 1;

	new_message_r_i = '1;
	received_msg_type_i = 3'b100;

	#1 clk = 0;
	#1 clk = 1;

	new_message_r_i = '0;


	#1 clk = 0;
	#1 clk = 1;

	while ( send_message_o != 1) begin
	#1 clk = 0;
	#1 clk = 1;
	end




while ( i < temp/2) begin
#1 clk = 0;
#1 clk = 1;

temp = temp - 1;

end





#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;

#1 clk = 0;
#1 clk = 1;

#10 $finish;

end

endmodule
