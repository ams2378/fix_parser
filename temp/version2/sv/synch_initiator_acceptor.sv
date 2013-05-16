

`include "defines.vh"

module synch_initiator_acceptor (

		input			clk,		
		input			rst,
		input			end_i,
		input			end_a,
		input			status,
		input			all_sent,

		output reg		new_message_i,
		output reg		new_message_a,
		output reg		send_data_to_acceptor,
		output reg		send_data_to_initiator
		);

parameter		state0 = 3'b000;
parameter		state1 = 3'b001;
parameter		state2 = 3'b010;
parameter		state3 = 3'b011;
parameter		state4 = 3'b100;

reg[2:0]		state;
reg[2:0]		next_state;

always @ (posedge clk) begin
	if(rst)		state  <= state0;
	else		state  <= next_state;
end

always @(*) begin

	case (state) 
		state0	:	begin
						new_message_i = '0;
						new_message_a = '0;
						send_data_to_acceptor = '0;
						send_data_to_initiator = '0;
					if (end_i == 1) begin
						next_state = state1;
					end else if (end_a == 1) begin
						next_state = state2;	
					end else
						next_state = state0;
				end

		state1	:	begin
						new_message_i = '0;
						new_message_a = '0;
						send_data_to_acceptor = '0;
						send_data_to_initiator = '0;
					if (status == '1) begin			// sc read all data
						new_message_a	 = '1;
						next_state	 = state3;
					end else
						next_state	=  state1;
				end

		state3	:	begin
						new_message_i = '0;
						new_message_a = '0;
						send_data_to_acceptor = '0;
						send_data_to_initiator = '0;
					if (all_sent == 0) begin
						send_data_to_acceptor = '1;
						next_state	=	state3;
					end else begin
						send_data_to_acceptor = '0;
						next_state	=	state0;
					end
				end

		state2	:	begin
						new_message_i = '0;
						new_message_a = '0;
						send_data_to_acceptor = '0;
						send_data_to_initiator = '0;
					if (status == '1) begin			// sc read all data
						new_message_i	 = '1;
						next_state	 = state4;
					end else
						next_state	=  state2;
				end

		state4	:	begin
						new_message_i = '0;
						new_message_a = '0;
						send_data_to_acceptor = '0;
						send_data_to_initiator = '0;
					if (all_sent == 0) begin
						send_data_to_initiator = '1;
						next_state	=	state4;
					end else begin
						send_data_to_initiator = '0;
						next_state	=	state0;
					end
				end
		default:        begin
						new_message_i = '0;
						new_message_a = '0;
						send_data_to_acceptor = '0;
						send_data_to_initiator = '0;
						next_state  = state0;
				end
	endcase
end

endmodule
