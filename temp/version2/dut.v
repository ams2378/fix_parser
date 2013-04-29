/**
 * @filename		dut.sv 
 *
 * @brief     	        A simple testbench. 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 */

module fix_engine_test();

	reg				clk;
	reg				rst;
//	reg				configure_i;			// from app
	reg				connect_i;			// from app
	reg[1:0]			connect_to_host_i;		// from app
	reg				connected_i;			// from toe
	reg[1:0]			connected_host_addr_i;		// from toe
	reg[7:0]			message_i;			// from toe
	reg				valid_i;			// from toe

	reg				new_message_i;			// will be implemented by fifo contr.

	reg				connect_req_o;			// goes to fifo
	reg				disconnect_o;			// goes to fifo
	reg[1:0]			connect_addr_o;			// goes to fifo
	reg[1:0]			disconnect_host_num_o;		// goes to fifo
	reg				send_message_valid_o;		// goes to fifo
	reg[7:0]			message_o	;		// goes to fifo
	reg				message_received_o;		// to api

fix_engine dut (
	 	.clk,
	 	.rst,
	// 	.configure_i,			// from app
	 	.connect_i,			// from app
	 	.connect_to_host_i,		// from app
	 	.connected_i,			// from toe
	 	.connected_host_addr_i,		// from toe
	 	.message_i,			// from toe
	 	.valid_i,			// from toe

		.new_message_i,			// will be implemented by fifo contr.

		.connect_req_o,			// goes to fifo
		.disconnect_o,			// goes to fifo
	 	.connect_addr_o,			// goes to fifo
 		.disconnect_host_num_o,		// goes to fifo
		.send_message_valid_o,		// goes to fifo
	 	.message_o	,		// goes to fifo
		.message_received_o		// to api
	);


always
	#1	clk = ~clk;

initial begin

clk = 1;
rst = 0;

$vcdpluson;

#1 rst = 1;
#1 rst = 0;

#5
connect_i	=	'1;
connect_to_host_i	=	2'b00;

#2
connected_i =	 '1;
connected_host_addr_i	=	2'b00;

#2

#1000 $finish;

end

endmodule
