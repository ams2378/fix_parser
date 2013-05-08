`include "defines.vh"

module end_to_end_system #(parameter NUM_HOST = `HOST_ADDR_WIDTH, SIZE = 64, T_SIZE = 5) (
	input				clk,
	input				rst,
	input				connect_i,			// from app
	input[NUM_HOST-1:0]		connect_to_host_i,		// from app

	input				connected_i_i,			// from toe
	input[NUM_HOST-1:0]		connected_host_addr_i_i,		// from toe
	input[NUM_HOST-1:0]		id_i_i,				// from toe
	input[7:0]			message_i_i,			// from toe
	input				fifo_full_i_i,
	input				new_message_i_i,			
	output				fifo_write_i_o,
	output[7:0]			message_i_o,			// goes to fifo

	input				connected_a_i,			// from toe
	input[NUM_HOST-1:0]		connected_host_addr_a_i,		// from toe
	input[NUM_HOST-1:0]		id_a_i,				// from toe
	input[7:0]			message_a_i,			// from toe
	input				fifo_full_a_i,
	input				new_message_a_i,			
	output				fifo_write_a_o,
	output[7:0]			message_a_o			// goes to fifo

	);

fix_engine initiator (
	 .clk,
	 .rst,
	 .connect_i,			
	 .connect_to_host_i,		

	 .connected_i(connected_i_i),			
	 .connected_host_addr_i(connected_host_addr_i_i),		
	 .id_i(id_i_i),				
	 .message_i(message_i_i),			 
	 .fifo_full_i(fifo_full_i_i),
	 .new_message_i(new_message_i_i),			
	 .fifo_write_o(fifo_write_i_o),
	 .message_o(message_i_o)			

	);

fix_engine acceptor (
	 .clk,
	 .rst,
	 .connect_i('0),			
	 .connect_to_host_i('0),		

	 .connected_i(connected_a_i),			
	 .connected_host_addr_i(connected_host_addr_a_i),		
	 .id_i(id_a_i),				
	 .message_i(message_a_i),			 
	 .fifo_full_i(fifo_full_a_i),
	 .new_message_i(new_message_a_i),			
	 .fifo_write_o(fifo_write_a_o),
	 .message_o(message_a_o)			

	);

endmodule
