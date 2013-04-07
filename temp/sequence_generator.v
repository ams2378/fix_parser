
/*

local seq tracking:
		initialize to 1 at the beginning
		increase for each send_message_i
		
remote seq tracking:
		initialize to 1 at the beginning
		increase for each received message as long as	
			message is valid
			ignore_i is not 1

*/

module sequence_generator #(parameter MAX_SIZE = 8) (

		input 				clk,
		input				rst,
		input				connect_i,
		input				receive_new_message_i,
		input				message_valid_i,
		input				send_message_i,
		input				igonre_i,
	
		output wire[MAX_SIZE-1:0]	expected_seq_num_o,
		output wire[MAX_SIZE-1:0]	outgoing_seq_num_o
		);

reg[MAX_SIZE-1:0]	outgoing_seq_counter;
reg[MAX_SIZE-1:0]	incoming_seq_counter;

always @(clk) begin

	if (connect_i == 1) begin
		incoming_seq_counter	<=	'0;
		outgoing_seq_counter	<=	'0;
	end
	
	if (send_message_i == 1) begin
		outgoing_seq_counter	<=	outgoing_seq_counter + 1;
	end
	
	if ( receive_new_message_i == 1) begin
		incoming_seq_counter	<=	incoming_seq_counter + 1;
	end			
end

assign	expected_seq_num_o	=	incoming_seq_counter;
assign	outgoing_seq_num_o	=	outgoing_seq_counter;

endmodule
