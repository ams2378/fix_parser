

module top #(parameter VALUE_WIDTH = 256, SIZE = 64) (
	input				clk,
	input				rst,
	input				configure_i,
	input				start_i,
	input				end_session_i,
	input				connected_i,// will be removed later-for TCP

	input [1:0]			connectType_i,			
	input [7:0] 			reconnectInt_i,			
	input [15:0] 			starttime_i,			
	input [15:0] 			endtime_i,			
	input [5:0] 			beginstring_i,			
	input [5:0] 			defaultApplVerId_i,		
	input [255:0] 			senderCompId_i,		
	input [255:0] 			targetCompId_i,		
	input [15:0] 			hostAddr_i,			 
	input [7:0] 			heartBeatInt_i,
	input [SIZE-1:0]		sizeSenderId_i,
	input [SIZE-1:0]		sizeTargetId_i,
	input [SIZE-1:0]		sizeHeartBeat_i,
	input [2:0]			received_msg_type_i,

	output reg			connect_o,
	output reg			send_message_o,
	output reg			disconnect_o,
	output reg			ignore_o,
	output reg [7:0]		data_o
	);


wire				configure;
wire[VALUE_WIDTH-1:0]		beginstring;
wire[VALUE_WIDTH-1:0]		sendercompid;
wire[VALUE_WIDTH-1:0]		targetcompid;
wire[VALUE_WIDTH-1:0]		heartbeat;
wire[SIZE-1:0]			sendersize;
wire[SIZE-1:0]			targetsize;
wire[SIZE-1:0]			heartbeatsize;
wire				tagvalid;
wire				valuevalid;
wire				doChecksum;
wire				tag;
wire				value;
wire[2:0]			messagetype;
wire				createmessage;
wire				done;
wire				endd;
wire				messagecreated;	


configure #(.VALUE_WIDTH(VALUE_WIDTH), .SIZE(SIZE)) configure_module (

		.clk (clk),
		.rst,
		.configure(configure),
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
		 
		.beginstring_o (beginstring),			
		.senderCompId_o (sendercompid),			
		.targetCompId_o (targetcompid),		
		.heartBeatInt_o (heartbeat ),
		.sizeSenderId_o (sendersize),
		.sizeTargetId_o (targetsize),
		.sizeHeartBeat_o (heartbeatsize)

//		.connectType_o (  ) ,			
//		.reconnectInt_o ( ),			
//		.starttime_o ( ),			
//		.endtime_o (  ),			
//		.defaultApplVerId_o ( ),		
//		.hostAddr_o (  ),	
		);



session_controller session_control (

		.clk,
		.rst,
		.configure_i,
		.start_i,
		.end_session_i,
		.connected_i,
//		.response_received_i,
//		.packet_status_i,		
		.timeout_i ('1), 
		.message_created_i (messagecreated),
		.new_message_r_i ('0),
		.send_b_a_message_i ('0),
		.received_msg_type_i,

		.load_configure_o (configure),
		.connect_o,
		.create_message_o (messagetype),		
		.send_message_o,
		.disconnect_o,
		.ignore_o,
		.initiate_msg_o (createmessage)
		);

create_message #(.VALUE_WIDTH(VALUE_WIDTH), .SIZE(SIZE)) create_messege_module (

		.clk,
		.rst,
		.start_i (createmessege),
		.done_i (done),
		.end_i (endd),				
		.bodyLength_r_i ('1), 	
		.message_type_i (messagetype),			
		.v_beginString_i (beginstring),			
		.s_v_beginString_i (6'b111111) ,    	 // will update later	
		.v_senderCompId_i (sendercompid),		
		.s_v_senderCompId_i (sendersize),		
		.v_targetCompId_i (targetcompid),		
		.s_v_targetCompId_i (targetsize),		
		.v_heartBeatInt_i (heartbeat),	
		.s_v_heartBeatInt_i (heartbeatsize),	
		.v_sendTime_i ('0),			// will update later
		.v_msgSeqNum_i (8'h30),
		.s_v_msgSeqNum_i (5'b00001),

		.tag_o (tag),
		.tag_valid_o (tagvalid),
		.val_o (value),
		.val_valid_o (valuevalid),
		.v_size_o (valuesize),
		.t_size_o (tagsize),
		.checksum_o (doChecksum),
		.msg_creation_done_o (messagecreated)
		
		);

fsm_create_2 #(.VALUE_WIDTH(VALUE_WIDTH), .SIZE(SIZE)) fsm (

		.clk,
		.rst,
		.tag_valid_i (tagvalid),
		.val_valid_i (valuevalid),
		.tag_i (tag),
		.val_i (value),
		.t_size_i (tagsize),
		.v_size_i (valuesize),
		.checksum_i (doChecksum),
		.checksum_val_i ('0),			// will update later

		.data_o,
	//	.start_chksm_o,
		.done_o (done),
		.end_o (endd)
	//	.end_of_msg_o

		);

endmodule
