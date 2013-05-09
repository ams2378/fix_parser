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
	reg				fifo_full_i;
	reg				new_message_i;			// will be implemented by fifo contr.

//	reg				connect_req_o;			// goes to fifo
//	reg				disconnect_o;			// goes to fifo
//	reg[1:0]			connect_addr_o;			// goes to fifo
//	reg[1:0]			disconnect_host_num_o;		// goes to fifo
//	reg				send_message_valid_o;		// goes to fifo
//	reg[7:0]			message_o	;		// goes to fifo
//	reg				message_received_o;		// to api

	reg				fifo_write_o;
	reg[7:0]			message_o;			// goes to fifo



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
		.fifo_full_i,
		.new_message_i,			// will be implemented by fifo contr.

//		.connect_req_o,			// goes to fifo
//		.disconnect_o,			// goes to fifo
//	 	.connect_addr_o,			// goes to fifo
 //		.disconnect_host_num_o,		// goes to fifo
//		.send_message_valid_o,		// goes to fifo
//	 	.message_o	,		// goes to fifo
//		.message_received_o		// to api

		.fifo_write_o,
		.message_o

	);

integer	in, status, mon;
reg[7:0]	temp_in;

always
	#1	clk = ~clk;

initial begin
  	in = $fopen("inputs.txt","r");
	mon = $fopen("monitor.txt", "w");
end


always @ (posedge clk) begin
	if ( fifo_write_o)
		$fwrite(mon,"%h ",message_o);

//	if (send_message_valid_o == 1) begin
//		#5 fifo_full_i = '1;
//		#5 fifo_full_i = '0;
//	end
end


initial begin

clk = 0;
rst = 0;
fifo_full_i = '0;

$vcdpluson;

#1 rst = 1;
#2 rst = 0;


#1
connect_i	=	'1;
connect_to_host_i	=	2'b01;

#2 connect_i	=	'0;


#2
connected_i =	 '1;
connected_host_addr_i	=	2'b01;

#6
connected_i	=	'0;

#2

#1000 

new_message_i	=	'1;
connected_host_addr_i	=	2'b01;

while (!($feof(in))) begin
	@ (posedge clk)
	new_message_i	=	'0;
	status = $fscanf(in,"%h",temp_in[7:0]);
	if (temp_in != 8'h3b)
		message_i  =  temp_in;
	else begin
		repeat (100) @ (posedge clk);
		new_message_i	=	'1;
	end
end



#1000 $finish;

end

endmodule
