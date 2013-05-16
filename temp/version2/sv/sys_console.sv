module sys_console (
	// clock port
	clk,
	reset,
	
	// slave port
	slave_address,
	slave_read,
	slave_readdata,
	slave_write,
	slave_writedata
//	slave_byteenable
);

// clock port
input clk;
input reset;

// slave port, fixed read latency of 1 cycle so no waitrequest needed since it's always available
input [2:0] 		slave_address;
input 				slave_read;
wire [7:0] 			slave_readdata;
output [7:0] 		slave_readdata;
input 				slave_write;
input [7:0] 		slave_writedata;
//input [3:0] slave_byteenable;

reg		we_1;
reg [7:0]	data_in_1;
reg [7:0]	data_out_2;
wire [7:0]	data_out_3;
reg [7:0]	addr_1;

reg		fifo_write_i_o;
reg		fifo_write_a_o;
reg [7:0]	message_i_o;
reg [7:0]	message_a_o;
reg		end_i_o;
reg		end_a_o;
reg[7:0]	count_t = '0;
reg		end_a_o;
reg		fifo_write_a_o;

ram # (.ADDR_WIDTH(8), .DATA_WIDTH(8)) states (
		.clk	(clk),
		.we  	(we_1),
		.data	(data_in_1),
		.addr	(addr_1),
		.q	(data_out_2)
);

reg [7:0]	index	=	'0;
reg [7:0]	final_index;
reg [7:0]	status;
reg 		read_request;
reg [7:0]	read_index   =  '0;

reg		end_a_o;
reg		status_syn;
reg		all_sent;
reg		new_message_i_i;
reg		new_message_a_i;
reg		send_data_to_acceptor;
reg		send_data_to_initiator;
reg		all_sent;

always @ (posedge clk) begin
	if (fifo_write_i_o == 1) begin
		addr_1  	<=	index;
		index		<=	index  +  1;
		we_1		<=	'1;
		data_in_1	<=	message_i_o;
	end else if (fifo_write_a_o == 1) begin
		index		<=	index  +  1;
		addr_1  	<=	index;
		we_1		<=	'1;
		data_in_1	<=	message_a_o;
	end else
		we_1		<=	'0;

	if (end_i_o == 1 || end_a_o == 1) begin
		final_index	<=	index;
		index		<=	'0;
	end 

	if (slave_read == 1 && slave_address == 3'b001) begin
		addr_1		<=	read_index;
		count_t		<=	count_t + 1;
	end
	
	if (count_t == 8'h2) begin
		read_index	<=	read_index + 1;
		count_t  <= '0;
	end
	
		all_sent	<=	'0;
	if (read_index == final_index ) begin
		read_index	<=	'0;
		all_sent	<=	'1;
	end
end

// the Avalon slave port for a master like Nios II to start the session and read the result
slave the_slave (
	.clk (clk),
	.reset (reset),
	.slave_address (slave_address),
	.slave_read (slave_read),
	.slave_readdata (slave_readdata),
	.slave_write (slave_write),
	.slave_writedata (slave_writedata),
//	.slave_byteenable (slave_byteenable),

	.fix_message_sent (end_i_o|end_a_o),
	.final_index (final_index),
	.ready_to_read (end_i_o|end_a_o),
	.read_request (read_request),
	.data_out_2 (data_out_2),
	.session_initiate (status)
);

reg		connect;
reg		connected;

always @ (posedge clk) begin

		connect		<=	'0;
		connected	<=	'0;

	if (status == 8'hbb) begin
		connect		<=	'1;
	end if (status == 8'hcc) begin
		connected	<=	'1;
	end 

	if (status == 8'hdd) begin
		status_syn <= '1;
	end else
		status_syn <= '0;

	if (send_data_to_acceptor == 1 || send_data_to_initiator == 1) begin
		addr_1	<= read_index;
		if (read_index != final_index)
			read_index <= read_index + 1;
		else
			read_index <= '0;
	end
end

synch_initiator_acceptor sync_acceptor_initiator_data (

 		.clk (clk),		
 		.rst (reset),
 		.end_i (end_i_o),
 		.end_a (end_a_o),
 		.status (status_syn) ,
		.all_sent (all_sent),
	
	 	.new_message_i (new_message_i_i),
	 	.new_message_a (new_message_a_i),
	 	.send_data_to_acceptor (send_data_to_acceptor),
		.send_data_to_initiator (send_data_to_initiator)
);


assign	data_out_3	=	(data_out_2 == 8'h38) ? data_out_2 : '0;

end_to_end_system endtoend (
	  .clk (clk),
	  .rst (reset),
	  .connect_i (connect),					
	  .connect_to_host_i (2'b01),			

	  .end_session_i_i ('0),

	  .connected_i_i (connected),				
	  .connected_host_addr_i_i (2'b01),		
	  .id_i_i (2'b01),				
	  .message_i_i (data_out_2),					
	  .fifo_full_i_i ('0),
	  .new_message_i_i (new_message_i_i),			
	  .fifo_write_i_o (fifo_write_i_o),
	  .message_i_o (message_i_o),					
	  .end_i_o (end_i_o),

	  .end_session_a_i ('0),
	  .connected_a_i (connected),			
	  .connected_host_addr_a_i (2'b00),		
	  .id_a_i (2'b00),				
	  .message_a_i (data_out_2),				
	  .fifo_full_a_i ('0),
	  .new_message_a_i (new_message_a_i),			

	  .fifo_write_a_o (fifo_write_a_o),
	  .message_a_o (message_a_o),				
	  .end_a_o (end_a_o)
	);

endmodule
