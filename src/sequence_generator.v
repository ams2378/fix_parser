
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
		input				receiev_new_message_i,
		input				message_valid_i,
		input				send_message_i,
		input				igonre_i,
	
		output reg[MAX_SIZE-1:0]	expected_seq_num_o,
		output reg[MAX_SIZE-1:0]	outgoing_seq_num_o
		
		);


reg[MAX_SIZE-1:0]	outgoing_seq_counter;
reg[MAX_SIZE-1:0]	incoming_seq_counter;


always @(clk) begin
		outgoing_seq_num_o	<=	'0;
	if (start_i == 1) begin
		outgo
	end
		

end

