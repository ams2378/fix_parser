
`include "defines.vh"

module hbcounter # (parameter HB_RANGE = `HB_RANGE)(

		input			clk,		
		input			rst,
		input			start_counter_i,
		input[HB_RANGE-1 :0] 	heartbeat_val_i,
		input			received_new_msg_i,	
	
		output reg		threshold_recahed_o
		);



parameter		state0 = 2'b00;
parameter		state1 = 2'b01;
parameter		state2 = 2'b10;

reg[1:0]		state;
reg[1:0]		next_state;

reg			start_count;
reg			timeout;
reg[HB_RANGE-1 :0] 	count_0;


always @ (posedge clk) begin
	if(rst)		state  <= state0;
	else		state  <= next_state;
end


always @(*) begin

	case (state) 

		state0	:	begin
						start_count = '0;
						threshold_recahed_o   = '0;
					if (start_counter_i == 1) begin
						start_count = '1;
						next_state = state1;
					end else
						next_state = state0;
				end

		state1	:	begin
						start_count = '0;
						threshold_recahed_o   = '0;
					if (timeout == 1 ) begin
						start_count = '0;
						threshold_recahed_o   = '1;
						next_state = state2;
					end else if (received_new_msg_i == 1) begin 
						start_count = '0;;
						next_state = state0;
					end else begin
						start_count = '1;;
						next_state = state1;
					end
				end

		state2	:	begin
						start_count = '0;
						threshold_recahed_o   = '0;		//edit
						next_state = state0;
				end
	endcase
end



always @ (posedge clk) begin

	if(rst)		count_0	<= 0;
	
	timeout	<=	'0;

	if (start_count == 1) begin
		count_0		<=	count_0 + 1;
		if (count_0 == heartbeat_val_i) begin
			timeout <= '1;	
			count_0	<=  0;
		end
	end else
		count_0		<=	'0;
end


endmodule		

