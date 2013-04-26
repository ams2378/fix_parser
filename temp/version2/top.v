
module fix_engine (

  		input  			clk,
  		input  			reset,
  		input  			configure_i,
  		input  			connect_i,
  		input  			connected_i,
  		input[5:0] 		connected_host_addr_i,
  		input  			new_message_i,
	 	input[7:0]  		message_i,
	
  		output reg		connect_req_o,
  		output reg[5:0]  	connect_host_addr_o,
  		output reg		send_message_o,
  		output reg[7:0]		message_o
	);









