
`include "defines.vh"

module sequence_generator #(parameter MAX_SIZE = 256, HOST_ADDR = `HOST_ADDR_WIDTH, SIZE = `VALUE_SIZE) (

		input 				clk,
		input				rst,
		input				receive_new_message_i,
		input[3:0]			create_message_i,	// from session manager 
		input				ignore_i,		// from session manager
		input				updateSeqCounter_i,	// from session manager
		input[`HOST_ADDR_WIDTH-1:0]	seqCounterLoc_i,	// from session manager
		input[MAX_SIZE-1:0]		newSeqNum_i,		// from received message processor
		input[`HOST_ADDR_WIDTH-1:0]	sending_to_host_addr_i,	// from session manager 
		input[`HOST_ADDR_WIDTH-1:0]	received_host_addr_i,	// 
	
		output reg[MAX_SIZE-1:0]	expected_seq_num_o,
		output wire[MAX_SIZE-1:0]	outgoing_seq_num_o,
		output reg[SIZE-1:0]		size_seq_num_o,
		output wire			valid_seq_num_o,
		output wire[3:0]		width_seq_o

		);

parameter 		MEM_DEPTH = 1 << `HOST_ADDR_WIDTH;
reg[MAX_SIZE-1:0]	mem[MEM_DEPTH-1:0];
integer			i, j;
reg[MAX_SIZE-1:0]	outgoing_seq_num;
reg			start_conv;
reg			done;

// initialize mem at rst
always @(posedge clk or rst) begin
	if (rst) begin
		for (i = 0; i<MEM_DEPTH; i=i+1) begin
			mem[i]	<=	'0;
		end
	end
end

always @(clk) begin
	
	start_conv	<=	'0;

	if (updateSeqCounter_i == 1) begin
		mem[seqCounterLoc_i]  <= newSeqNum_i;
	end else if (create_message_i != 0 && ignore_i != 1) begin
		mem[sending_to_host_addr_i]  <= mem[sending_to_host_addr_i] + 1;
		outgoing_seq_num	     <= mem[sending_to_host_addr_i];	
		start_conv		     <=	'1;
	end
	
	if (receive_new_message_i == 1) begin
		expected_seq_num_o	     <= mem[received_host_addr_i];	
	end			
end


assign	valid_seq_num_o		=	(done == 1) ? '1 : '0;

binary_to_bcd # (.BITS_IN_PP(32), .BCD_DIGITS_OUT_PP(10), .BIT_COUNT_WIDTH_PP(5) ) converted 
	(
		.clk_i(clk),
		.rst_i(rst),
		.ce_i('1),
		.start_i(start_conv),
		.dat_binary_i(outgoing_seq_num),
		.done_o(done),
		.ascii_o(outgoing_seq_num_o),
		.size_o(size_seq_num_o),
		.width_o(width_seq_o)
	);



endmodule
