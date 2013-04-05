
module tcpconnect (

		input 			clk,
		input			rst,
		input 			connect_i,
		input[1:0]		connectType_i,
		input[7:0]		reconnectInt_i,
		input[15:0]		hostAddr_i

		output[15:0]		address_o,
		output			connect_o,
		output			listen_initiate_o
		);

parameter 			state0  = 12'b000000000001;
parameter 			state1  = 12'b000000000010;
parameter 			state2  = 12'b000000000100;
parameter 			state3  = 12'b000000001000;
parameter 			state4  = 12'b000000010000;
parameter 			state5  = 12'b000000100000;
parameter 			state6  = 12'b000001000000;
parameter 			state7  = 12'b000010000000;
parameter 			state8  = 12'b000100000000;
parameter 			state9  = 12'b001000000000;
parameter 			state10 = 12'b010000000000;
parameter 			state11 = 12'b100000000000;

// internal variables
reg [7:0]			state;
reg [7:0]			next_state;

reg[7:0]			counter;

// build state flops
always @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end

always @ (posedge state or connect_i ) begin

	if (rst) begin
		address_o		=	'0;
		connect_o		=	'0;
		listen_initiate_o	=	'0;
	end

	case(state)
	
	state0:	begin
			if (connect_i)

		end

end

endmodule
