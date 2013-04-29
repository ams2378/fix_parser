/*
	in from toe:
		connected_i
		connected_host_addr_i
		data_i
		valid_i

	out to toe:
		disconnect_o
		connect_req_o
		connect_addr_o
		send_message_valid_o
		message_o
		disconnect_host_num_o	

	Inteface will read from fifo and split out the signals

	todo:
		fix_parser
		fix_parser_out_module

*/


`include "defines.vh"

module fix_engine #(parameter NUM_HOST = `HOST_ADDR_WIDTH, SIZE = 64, T_SIZE = 5) (
	input				clk,
	input				rst,
//	input				configure_i,			// from app
	input				connect_i,			// from app
	input[NUM_HOST-1:0]		connect_to_host_i,		// from app
	input				connected_i,			// from toe
	input[NUM_HOST-1:0]		connected_host_addr_i,		// from toe
	input[7:0]			message_i,			// from toe
	input				valid_i,			// from toe

	input				new_message_i,			// will be implemented by fifo contr.

	output				connect_req_o,			// goes to fifo
	output				disconnect_o,			// goes to fifo
	output[NUM_HOST-1:0]		connect_addr_o,			// goes to fifo
	output[NUM_HOST-1:0]		disconnect_host_num_o,		// goes to fifo
	output				send_message_valid_o,		// goes to fifo
	output[7:0]			message_o	,		// goes to fifo
	output				message_received_o		// to api
	);

parameter	HOSTADDR_DATA_WIDTH = `VALUE_DATA_WIDTH + `VALUE_SIZE;

wire[3:0]			w_validity;			
wire[3:0]			w_type;			
wire[`VALUE_DATA_WIDTH-1:0]	w_v_targetCompId;
wire[SIZE-1:0]			w_s_v_targetCompId;
wire				w_ignore;
wire				w_updatecnt;
wire[NUM_HOST-1:0]		w_seqCounterLoc;
wire[3:0]			w_messagetype;
wire				w_initiate_msg;
wire[`VALUE_DATA_WIDTH-1:0]	w_expseqnum;			// not supported yet
wire[`VALUE_DATA_WIDTH-1:0]	w_outseqnum;			
wire				w_new_message;
wire				w_done;
wire				w_endd;
wire[SIZE-1:0]			w_s_msgSeqNum;			
wire[31:0]			w_tag;
wire				w_tagvalid;
wire[`VALUE_DATA_WIDTH-1:0]     w_value;	
wire				w_valuevalid;
wire[SIZE-1:0]			w_valuesize;
wire[4:0]			w_tagsize;
wire				w_doChecksum;
wire[7:0]			w_checksum_val;
wire				w_start_chksm;
wire				w_end_chksm;
wire[7:0]			w_data;
wire				w_tag_s;
wire				w_value_s;
wire				w_start_message;
wire				w_end_message;
wire				w_checksum_valid;
wire[31:0]			w_tag_val;
wire[`VALUE_DATA_WIDTH-1:0]	w_val_val;
wire				w_we_2;
wire[`HOST_ADDR_WIDTH-1:0]	w_addr_2;
wire[HOSTADDR_DATA_WIDTH-1:0]	w_data_2;
wire[HOSTADDR_DATA_WIDTH-1:0]	w_q_2;


hostaddress  hostaddresstable(

		.clk(clk),
		.we(w_we_2),
		.q(w_q_2),
		.addr(w_addr_2),
		.data(w_data_2)
	);


connection_toe  toe_if (

		.clk(clk),
		.rst(rst),
		.connect_i(connect_i),
		.connect_addr_i(connect_to_host_i),
		.connect_o(connect_req_o),
		.connect_host_addr_o(connect_addr_o)
	);


session_manager session_controller (

	.clk(clk),
	.rst(rst),
	.new_message_i (w_new_message),				// from message processor
	.validity_i(w_validity),				// from message processor
	.timeout_i ('0),					// from counter
 	.connected_host_i(connected_host_addr_i),		// *** - need to multiplex
	.type_i (w_type),					// from message processor
	.connected_i(connected_i),				// from connection toe
	.end_session_i ('0),			 		// now hwired to 0
	.resendDone_i ('0),					// now hwired to 0
	.data_out_2(w_q_2),					// from hostaddress table
	
	.we_2(w_we_2),						// to hostaddress
	.addr_2(w_addr_2),					// to hostaddress
	.data_in_2(w_data_2),					// to hostaddress
	.disconnect_o(disconnect_o),				// to toe ***
 	.disconnect_host_num_o(disconnect_host_num_o),		// to toe ***
	.targetCompId_o (w_v_targetCompId),			// to create message	
	.s_v_targetCompId_o(w_s_v_targetCompId),		// to create message
	.ignore_o (w_ignore),					// to seq gen (not supported yet)
	.messagereceived_o(message_received_o),			// to api ***
	.updateSeqCounter_o(w_updatecnt),			// to seq gen
	.seqCounterLoc_o(w_seqCounterLoc),			// to seq gen
	.create_message_o(w_messagetype),			// to create message
 	.initiate_msg_o(w_initiate_msg)				// to create message
//	.error_type_o,						// to create message (not supported yet)
//	.doResend_o,						// ignore ***
//	.end_session_o,			 			// ignore ***
	); 

received_msg_processor message_processor (

	.clk(clk),
	.rst(rst),
	.tag_valid_i(w_tag_en),					// from parser
	.tag_i(w_tag_val),					// from parser
	.val_valid_i(w_val_en),					// from parser
	.val_i(w_val_val),					// from parser
	.start_of_message_i(w_start_message),			// from parser
	.end_of_message_i(w_end_message),			// from parser
	.expectedIncomingSeqNum_i(w_expseqnum),			// from sequence generator ***
	.checksum_validity_i (w_checksum_valid),		// from checksum calc	
		
	.new_message_o (w_new_message),				// to session manager
	.error_type_o (w_validity),				// to session manager
	.type_o	(w_type)					// to session manager
	);

create_message  create_messege_module (

	.clk(clk),
	.rst(rst),
	.start_i (w_initiate_msg),				// from SM
	.done_i (w_done),					// from fsm
	.end_i (w_endd),					// from fsm
	.bodyLength_r_i ('1), 					// from bodylength module (ready) 
	.message_type_i (w_messagetype),			// from SM	
	.v_targetCompId_i (w_v_targetCompId),			// from SM	
	.s_v_targetCompId_i (w_s_v_targetCompId),		// from SM	
	.v_sendTime_i (168'h3537342e33303a30303a30303a35302d3430343033313032),//***
	.v_msgSeqNum_i (w_outseqnum),				// from seq gen **** enable valid	
	.s_v_msgSeqNum_i (w_s_msgSeqNum),			// from seq gen (add valid)
	.v_senderCompId_i(`v_senderCompId),			// from defines	
	.s_v_beginString_i (8'b01111111),    			// from defines 	
	.v_beginString_i (`v_beginString),			// from defines	
	.s_v_senderCompId_i(`s_v_senderCompId),			// from defines	
	.v_heartBeatInt_i (`v_heartbeat),			// from defines
	.s_v_heartBeatInt_i (`s_v_heartbeat),			// from defines

	.tag_o (w_tag),						// to fsm
	.tag_valid_o (w_tagvalid),				// to fsm
	.val_o (w_value),					// to fsm
	.val_valid_o (w_valuevalid),				// to fsm
	.v_size_o (w_valuesize),				// to fsm
	.t_size_o (w_tagsize),					// to fsm
	.checksum_o (w_doChecksum)				// to fsm
//	.msg_creation_done_o (messagecreated)			// to SM 
		
	);

fsm_msg_create_2  fsm (

	.clk(clk),
	.rst(rst),
	.tag_valid_i (w_tagvalid),
	.val_valid_i (w_valuevalid),
	.tag_i (w_tag),
	.val_i (w_value),
	.t_size_i (w_tagsize),
	.v_size_i (w_valuesize),
	.checksum_i (w_doChecksum),
	.checksum_val_i (w_checksum_val),			// will update later

	.data_o(message_o),
	.start_chksm_o(w_start_chksm),				// to checksum calc (start calc)
	.done_o (w_done),
	.end_o (w_endd),
	.end_of_msg_o(w_end_chksm)				// to checksum calc (end calc)
	);

create_checksum	checksum_calc(

	.clk(clk),
	.rst(rst),	
	.data_i(message_o),
	.start_i(w_start_chksm),
	.end_i(w_end_chksm),

	.checksum_o(w_checksum_val)
);


sequence_generator sequence_manager (

	 .clk(clk),
	 .rst(rst),
	 .receive_new_message_i('0),				// not supported now- from fifo control***
	 .create_message_i(w_messagetype),			// from session manager 
	 .ignore_i (w_ignore),					// from session manager
	 .updateSeqCounter_i(w_updatecnt),			// from session manager
	 .seqCounterLoc_i(w_seqCounterLoc),			// from session manager
	 .newSeqNum_i('0),					// from received message processor***
	 .sending_to_host_addr_i('0),				// from session manager ***
	 .received_host_addr_i('0),				// ***

 	 .expected_seq_num_o(w_expseqnum),			//  ***
	 .outgoing_seq_num_o(w_outseqnum),			// to create message
	 .size_seq_num_o(w_s_msgSeqNum)				// to create message
//	 .valid_seq_num_o					// to create message (need to enable it)
//	 .width_seq_o						// *** not needed now				
	);

fix_parser parser(
		.clk(clk),
		.rst(rst),
		.data_i(message_i),
		.new_message_i(new_message_i),		

		.data_o(w_data),
		.tag_s_o(w_tag_s),
		.value_s_o(w_value_s)
);

fix_parser_out_module out_module(

		.clk,
		.rst,
		.data_i(w_data),
		.start_tag_i(w_tag_s),
		.start_value_i(w_value_s),
		
		.t_wr_cs_o (w_tag_en),
		.t_wr_en_o (w_tag_en),
		.v_wr_cs_o (w_val_en),
		.v_wr_en_o (w_val_en),
		.tag_o 	   (w_tag_val),
		.value_o   (w_val_val),

		.end_of_body_o (w_end_message),
//		.start_of_header_o,
		.start_message_o (w_start_message)
);

checksum  checksum (
	
		.clk (clk), 		
		.rst (rst), 
	
		.data_i(message_i),
		.start_i (w_start_message),
		.end_i(w_end_message),
		.valid_o(w_checksum_valid)	

); 



endmodule