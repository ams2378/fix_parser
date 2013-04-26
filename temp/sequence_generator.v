
module sequence_generator #(parameter MAX_SIZE = 8, NUM_HOST = 10) (

		input 				clk,
		input				rst,
		input				receive_new_message_i,
		input[MAX_SIZE-1:0]		heartbeat_i,
		input				send_message_i,
		input				ignore_i,
		input[NUM_HOST-1:0]		sending_to_host_addr_i,
		input[NUM_HOST-1:0]		received_host_addr_i,
	
		output reg[MAX_SIZE-1:0]	expected_seq_num_o,
		output reg[MAX_SIZE-1:0]	outgoing_seq_num_o
		);

parameter 		MEM_DEPTH = 1 << NUM_HOST;
reg[MAX_SIZE-1:0]	mem[MEM_DEPTH-1:0];
integer			i, j;

// initialize mem at rst
always @(clk) begin
	if (rst) begin
		for (i = 0; i<MEM_DEPTH; i=i+1) begin
			mem[i]	<=	'0;
		end
	end
end

always @(clk) begin
	if (send_message_i == 1 && ignore_i != 1) begin
		mem[sending_to_host_addr_i]  <= mem[sending_to_host_addr_i] + 1;
		outgoing_seq_num_o	     <= mem[sending_to_host_addr_i];	
	end
	
	if (receive_new_message_i == 1) begin
		outgoing_seq_num_o	     <= mem[received_host_addr_i];	
	end			
end

endmodule
