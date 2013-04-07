/**
 * @filename		dut.sv 
 *
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 */

module parser_test();


		reg				clk;
		reg				rst;
		reg				new_message_i;
		reg[2:0]	 		validity_i;
		reg 				timeout_i;
		reg[10-1:0] 		connected_host_i;
		reg[2:0]			type_i;
		reg				connected_i;
		reg 				end_session_i;
		reg 				resendDone_i;

		reg			ignore_o;	
		reg			disconnect_o;
		reg[2:0]			error_type_o;
		reg			resendReq_o;
		reg[256-1:0]	targetCompId_o;
		reg			igonre_o;
		reg			doResend_o;
		reg			sendHeartbeat_o;
		reg 			sendLogout_o;	
		reg 			messagereceived_o;
		reg 			updateSeqCounter_o;
		reg[10-1:0] 	seqCounterLoc_o;
		reg[10-1:0] 	disconnect_host_num_o;
		reg 			sendLogon_o;
		reg 			end_session_o;

session_manager dut (
		 		.clk,
		 		.rst,
		 		.new_message_i,
		 	 	.validity_i,
		  		.timeout_i,
		  		.connected_host_i,
		 		.type_i,
		 		.connected_i,
		  		.end_session_i,
		  		.resendDone_i,

		 		.ignore_o,	
		 		.disconnect_o,
		 		.error_type_o,
				.resendReq_o,
		 		.targetCompId_o,
		 		.igonre_o,
		 		.doResend_o,
		 		.sendHeartbeat_o,
		  		.sendLogout_o,	
		  		.messagereceived_o,
		  		.updateSeqCounter_o,
		  		.seqCounterLoc_o,
		  		.disconnect_host_num_o,
		  		.sendLogon_o,
		  		.end_session_o
	);

initial begin

$vcdpluson;

#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
connected_i = 1;


#1 clk = 0;
#1 clk = 1;

connected_i = 0;

#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;

#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;

	#1 clk = 0;
	#1 clk = 1;

	#1 clk = 0;
	#1 clk = 1;


	#1 clk = 0;
	#1 clk = 1;


	#1 clk = 0;
	#1 clk = 1;

	#1 clk = 0;
	#1 clk = 1;

	#1 clk = 0;
	#1 clk = 1;

	#1 clk = 0;
	#1 clk = 1;

	#1 clk = 0;
	#1 clk = 1;

	#1 clk = 0;
	#1 clk = 1;


	#1 clk = 0;
	#1 clk = 1;


	#1 clk = 0;
	#1 clk = 1;


	#1 clk = 0;
	#1 clk = 1;


	#1 clk = 0;
	#1 clk = 1;

	#1 clk = 0;
	#1 clk = 1;

#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;

#1 clk = 0;
#1 clk = 1;

#10 $finish;

end

endmodule
