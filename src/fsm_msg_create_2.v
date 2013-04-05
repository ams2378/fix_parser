

module fsm_msg_create_2 # (parameter VALUE_WIDTH = 256, SIZE = 5) (

		input 				clk,
		input				rst,
		input				tag_valid_i,
		input				val_valid_i,
		input[31:0]			tag_i,
		input[VALUE_WIDTH-1:0]		val_i,
		input[4:0]			t_size_i,
		//input[VALUE_WIDTH>>SIZE -1:0]	v_size_i,
		input[7:0]			v_size_i,
		input 				checksum_i,
		input[7:0]			checksum_val_i,

		output reg[7:0]			data_o,
		output reg			start_chksm_o,
		output reg			done_o,
		output reg			end_o,
		output reg			end_of_msg_o
	//	output reg			data_valid_o
		);


// state encoding
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

reg[4:0]			t_width;
reg[VALUE_WIDTH>>SIZE -1 :0]	v_width;
integer				temp_var;

// build state flops
always @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end

// state machine
always @ (state or tag_valid_i or val_valid_i or checksum_i) begin

	if (rst) begin
		done_o 			= '0;
		data_o			= '0;
		start_chksm_o		= '0;
		end_o			= '0;
//		data_valid_o		= '0;
		temp_var		=  0;
	end

	case (state)

	// sending tag- starts from very first tag
	state0: begin
		if ( tag_valid_i == 1 && checksum_i == 0) begin
			data_o		=	tag_i [temp_var*8 +: 8];
			done_o		=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			end_o		=	'0;			
			t_width		=	t_size_i;
			temp_var 	= 	temp_var + 1;
			t_width 	= 	t_width >> 1;	
			next_state 	=	state1;
		end else if (tag_valid_i == 1 && checksum_i == 1) begin
			data_o		=	tag_i [temp_var*8 +: 8];
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			done_o		=	'0;
			end_o		=	'0;
			temp_var 	= 	temp_var + 1;
			t_width		=	t_size_i;
			t_width 	= 	t_width >> 1;	
			next_state 	=	state4;
		end else
			next_state	=	state0;
		end

	state1: begin
		if (t_width == 0) begin
			done_o		=	'1;
			end_o		=	'0;
			end_of_msg_o	=	'0;
			data_o		=	8'h3d;
			start_chksm_o	=	'1;			// send checksum start signal
			temp_var	=	0;
			next_state 	=	state3;
		end else begin
			data_o		=	tag_i [temp_var*8 +: 8];
			end_o		=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			done_o		=	'0;
			temp_var 	= 	temp_var + 1;
			t_width 	= 	t_width >> 1;	
			done_o 		=	'0;
			next_state	=	state2;
		end	
		end	


	state2: begin
		if (t_width == 0) begin
			done_o		=	'1;
			start_chksm_o	=	'0;
			end_o		=	'0;
			end_of_msg_o	=	'0;
			data_o		=	8'h3d;
			temp_var	=	0;
			next_state 	=	state3;
		end else begin
			data_o		=	tag_i [temp_var*8 +: 8];
			done_o		=	'0;
			end_o		=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			temp_var 	= 	temp_var + 1;
			t_width 	= 	t_width >> 1;	
			next_state	=	state1;
		end	
		end	


	state3: begin
		if (val_valid_i == 1 ) begin
			end_o		=	'0;
			start_chksm_o	=	'0;
			end_of_msg_o	=	'0;
			done_o		=	'0;
			data_o		=	val_i [temp_var*8 +: 8];
			v_width		=	v_size_i;
			temp_var 	= 	temp_var + 1;
			v_width 	= 	v_width >> 1;	
			next_state 	=	state4;
		end else begin
			next_state	=	state3;
		end
		end

	state4: begin
		if (v_width == 0) begin
			end_o		=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			done_o		=	'1;
			data_o		=	8'h01;
			temp_var	=	0;
			next_state 	=	state0;
		end else begin
			data_o		=	val_i [temp_var*8 +: 8];
			done_o 		=	'0;
			start_chksm_o	=	'0;
			end_of_msg_o	=	'0;
			end_o		=	'0;
			temp_var 	= 	temp_var + 1;
			v_width 	= 	v_width >> 1;	
			next_state	=	state5;
		end
		end	

	state5: begin
		if (v_width == 0) begin
			end_o		=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			done_o		=	'1;
			data_o		=	8'h01;
			temp_var	=	0;
			next_state 	=	state0;
		end else begin
			end_o		=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			data_o		=	val_i [temp_var*8 +: 8];
			done_o 		=	'0;
			temp_var 	= 	temp_var + 1;
			v_width 	= 	v_width >> 1;	
			next_state	=	state4;
		end
		end	

	state6: begin
		if (t_width == 0) begin
			end_o		=	'0;
			start_chksm_o	=	'0;
			end_of_msg_o	=	'1;		// end of msg signal checksum to stop
			done_o		=	'1;
			data_o		=	8'h3d;
			temp_var	=	0;
			next_state 	=	state8;
		end else begin
			end_o		=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			data_o		=	tag_i [temp_var*8 +: 8];
			done_o 		=	'0;
			temp_var 	= 	temp_var + 1;
			t_width	 	= 	t_width >> 1;	
			next_state	=	state7;
		end
		end	

	state7: begin
		if (t_width == 0) begin
			end_o		=	'0;
			start_chksm_o	=	'0;
			end_of_msg_o	=	'0;	
			done_o		=	'1;
			data_o		=	8'h3d;
			temp_var	=	0;
			next_state 	=	state8;
		end else begin
			end_o		=	'0;
			start_chksm_o	=	'0;
			end_of_msg_o	=	'0;	
			data_o		=	tag_i [temp_var*8 +: 8];
			done_o 		=	'0;
			temp_var 	= 	temp_var + 1;
			t_width	 	= 	t_width >> 1;	
			next_state	=	state6;
		end
		end	

	// checksum first byte
	state8: begin
			end_o		=	'0;
			done_o		=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			data_o		=	checksum_val_i;	
			next_state	=	state6;
		end

	// checksum second byte
	state9: begin
			end_o		=	'0;
			done_o		=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			data_o		=	checksum_val_i;	
			next_state	=	state7;
		end

	// checksum third byte
	state10: begin
			end_o		=	'0;
			done_o		=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			data_o		=	checksum_val_i;	
			next_state	=	state7;
		end

	state11: begin
			done_o		=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			data_o		=	8'h01;
			end_o		=	'1;	
			next_state	=	state0;
		end
	endcase

end


endmodule
