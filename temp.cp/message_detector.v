

module message_detector # (parameter VALUE_WIDTH = 256) (
		
		input 			clk,
		input			rst,
	
		input			t_valid_i,
		input			v_valid_i,
		input[31:0]		tag_i,
		input[VALUE_WIDTH-1:0]	value_i,
		input			chk_done_i,		// from checksum
		input			valid_i,		// from checksum
	
		output reg[2:0]		type_o,
		output reg		done_o,
		output reg		valid_o
		);

// state encoding
parameter 			state0  = 2'b001;
parameter 			state1  = 2'b010;
parameter 			state2  = 2'b100;

// internal variables
reg [2:0]			state;
reg [2:0]			next_state;

// include define
reg [2:0]			logon 		= 3'b001;
reg [2:0]			business 	= 3'b111;
reg [2:0]			logout 		= 3'b100;
reg [2:0]			heartbeat	= 3'b010;

reg [2:0]			temp_type;
reg 				temp_valid;


// build state flops
always @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end


always @ (state or t_valid_i or v_valid_i or tag_i or valid_i) begin

	if (rst) begin
		type_o 		<=	'0;
		valid_o		<=	'0;
		temp_valid	<=	'0;
		temp_type	<=	'0;
	end	

	case (state)

	state0:	begin
			if (t_valid_i == 1 && tag == 32'h00003335) begin
				type_o		<=	'0;
				valid_o		<=	'0;
				done_o		<=	'0;
				next_state	=	state1;
			end else begin
				type_o		<=	'0;
				valid_o		<=	'0;
				done_o		<=	'0;
				next_state	=	state0;
			end
		end

	state1:	begin
			if (v_valid_i == 1) begin
				type_o		<=	'0;
				valid_o		<=	'0;
				done_o		<=	'0;
				case (value[7:0])
					8'h41	:    temp_type <=  logon; 		 
					8'h30	:    temp_type <=  heartbeat; 	
					8'h35	:    temp_type <=  logout; 	
					default ;    temp_type <= '0 ; 			
				next_state	=	state2;
			end else begin
				type_o		<=	'0;
				done_o		<=	'0;
				valid_o		<=	'0;
				next_state	=	state1;
			end
		end

	state2: begin
			if (chk_done_i == 1) begin
				type_o		<=	temp_type;
				done_o		<=	'1;
				if (valid_i == 1)
					valid_o	<=	'1;
				else
					valid_o	<=	'0;
				next_state	=	state0;
			end else begin
				type_o		<=	'0;
				done_o		<=	'0;
				valid_o		<=	'0;
				next_state	=	state2;
			end
		end

	default:	next_state = state0;	

	endcase
end



endmodule
