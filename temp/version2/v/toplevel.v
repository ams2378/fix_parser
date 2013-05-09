module toplevel (
			input			clk,						
			input			rst,			

 			input			connect_i,			
 			input[1:0]		connect_to_host_i,
	
			output			start_pkt_pg, 		
			output			end_pkt_pg, 		
			output			valid_o_pg,		
			input			ready_i_pg,		
			output[63:0]		packet_pg, 		
			output[2:0]		empty_pg,		
			output			error_o_pg,	
	
			input			start_stream_in, 	
			input			end_stream_in,		
			input			valid_stream_in,		
			output			ready_o_stream,		
			input[63:0]		data_stream_in,		
			input[2:0]		empty_o_stream,		
			input			error_i_stream
);

wire		w_full_i;
wire		w_error_i;
wire[7:0]	w_data_i;
wire		w_empty_i;
wire		w_readreq_o;
wire		w_valid_o;
wire[7:0]	w_data_o;
wire[1:0]	w_id_i;		
wire		w_connected_i;
wire[1:0]	w_connected_host_addr_i;
wire[7:0]	w_message_o;
wire		fifo_write_o;



integer		count;


always @ (posedge clk) begin

	rst_t	=	'0;

	connect_to_host_i_t	=	2'b01;
	count = count + 1;

	if (count == 32'd100 || count == 32'd101) begin
		rst_t	=	 '0;
	end

	if (count == 32'd110) begin
		connect_i_t		=	'1;
	end
end

interface interface (

		 .clk(clk),
		 .rst(rst),

		 .full_i(w_full_i),					// from toe
		 .error_i(w_error_i),					// from toe
		 .data_i(w_data_i),					// from toe
		 .empty_i(w_empty_i),					// from toe

		 .readreq_o(w_readreq_o),				// to toe
		 .valid_o(w_valid_o),					// to fix engine
		 .data_o(w_data_o),					// to fix engine
		 .id_o(w_id_i)						// to fix engine
);

fix_engine dut (	  
 		.clk(clk),
 		.rst(rst),
 		.connect_i,			// from app
 		.connect_to_host_i,		// from app

		.connected_i(w_connected_i),				// from toe
 		.connected_host_addr_i(w_connected_host_addr_i),	// from toe
 		.id_i(w_id_i),						// from interface
 		.message_i(w_data_o),					// from interface
 		.fifo_full_i(w_fifo_full_i),
 		.new_message_i(w_valid_o),				// from interface
 		.fifo_write_o(w_fifo_write_o),
 		.message_o(w_message_o)			  
);

top_toe_fix toe (
			 .clk(clk),						
			 .rst(rst),			
	
			// output stream
			 .start_pkt_pg, 		
			 .end_pkt_pg, 		
			 .valid_o_pg,		
			 .ready_i_pg,		
			 .packet_pg, 		
			 .empty_pg,		
			 .error_o_pg,	

			// input stream
			 .start_stream_in, 	
			 .end_stream_in,		
			 .valid_stream_in,		
			 .ready_o_stream,		
			 .data_stream_in,		
			 .empty_o_stream,		
			 .error_i_stream,
			
			// fix engine		
			 .data_in_df(w_message_o),        	
			 .writeReq_df(w_fifo_write_o), 		
	
			 .empty_df(w_empty_i), 				 		
			 .full_df(w_fifo_full_i), 		
			 .error_df(w_error_i),				  		

			 .con_status_tcb(w_connected_i),    	
			 .con_addr_tcb(w_connected_host_addr_i)    	
);

endmodule
