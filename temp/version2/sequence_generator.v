
// seq num range: 80 bit ascii // 40 bit bcd // 32 bit binary

`include "defines.vh"

module sequence_generator #(parameter MAX_SIZE = 80, HOST_ADDR = `HOST_ADDR_WIDTH, SIZE = `VALUE_SIZE) (

		input 				clk,
		input				rst,
		input				receive_new_message_i,
		input				create_message_i,	// from session manager 
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
		output reg[3:0]			width_seq_o

		);

parameter 		MEM_DEPTH = 1 << `HOST_ADDR_WIDTH;
reg[32-1-1:0]		mem[MEM_DEPTH-1:0];
integer			i, j, k;
reg[MAX_SIZE-1:0]	outgoing_seq_num;
reg[MAX_SIZE-1:0]	outgoing_seq_num_temp;
reg			start_conv;
reg			done;
reg[3:0]		width;

// initialize mem at rst
always @(posedge clk ) begin
	if (rst) begin
		for (i = 0; i<MEM_DEPTH; i=i+1) begin
			mem[i]	<=	8'd123;
		end
	end
end

always @(posedge clk) begin
	
	start_conv	<=	'0;

	if (updateSeqCounter_i == 1) begin
		mem[seqCounterLoc_i]  <= newSeqNum_i;
	end else if (create_message_i == 1 && ignore_i != 1) begin
		mem[sending_to_host_addr_i]  <= mem[sending_to_host_addr_i] + 1;
		start_conv		     <=	'1;
	end
	
	if (receive_new_message_i == 1) begin
		expected_seq_num_o	     <= mem[received_host_addr_i];	
	end	
end

always @(*) begin
		outgoing_seq_num		=	'0;
	for (k = 0; k<width; k=k+1) begin
		outgoing_seq_num[k*8 +: 8] = outgoing_seq_num_temp[8*(width-1-k) +: 8];	
	end

	if (mem[sending_to_host_addr_i] < 32'd10)
		width_seq_o	=	4'b0001;
	else if (mem[sending_to_host_addr_i] < 32'd100)
		width_seq_o	=	4'b0010;
	else if ( mem[sending_to_host_addr_i] < 32'd1000)	
		width_seq_o	=	4'b0011;
	else if (mem[sending_to_host_addr_i] < 32'd10000)
		width_seq_o	=	4'b0100;
	else if ( mem[sending_to_host_addr_i] < 32'd100000)		
		width_seq_o	=	4'b0101;
	else if (mem[sending_to_host_addr_i] < 32'd1000000)
		width_seq_o	=	4'b0110;
	else if ( mem[sending_to_host_addr_i] < 32'd10000000)	
		width_seq_o	=	4'b0111;
	else if ( mem[sending_to_host_addr_i] < 32'd100000000)	
		width_seq_o	=	4'b1000;
	else if ( mem[sending_to_host_addr_i] < 32'd1000000000)
		width_seq_o	=	4'b1001;
	else if ( mem[sending_to_host_addr_i] < 32'd10000000000)		
		width_seq_o	=	4'b1010;
	
end

binary_to_bcd # (.BITS_IN_PP(32), .BCD_DIGITS_OUT_PP(10), .BIT_COUNT_WIDTH_PP(5) ) converted 
	(
		.clk_i(clk),
		.rst_i(rst),
		.ce_i('1),
		.start_i(start_conv),
//		.dat_binary_i(outgoing_seq_num),
		.dat_binary_i(mem[sending_to_host_addr_i]),
		.done_o(done),					// edit ams
		.ascii_o(outgoing_seq_num_temp),
		.size_o(size_seq_num_o),
		.width_o(width)
	);

assign	valid_seq_num_o		=	(done == 1) ? '1 : '0;
assign	outgoing_seq_num_o	=	outgoing_seq_num;

endmodule
