
`include "defines.vh"

module sentmessage # (parameter COUNTER_DEPTH = `COUNTER_RANGE, SEQ_LOOKUP = `SEQ_LOOKUP_DEPTH)(

		input				clk,
		input				rst,
		input				send_message_i,
		input				end_message_i,

		input[COUNTER_DEPTH-1:0]	sequence_number_i,
		input[7:0]			din_i,


		)


reg []



always @ (clk) begin

	if (send_message_i == 1) begin
		seq_lookup_mem[sequence_number_i] = 


	end



end
