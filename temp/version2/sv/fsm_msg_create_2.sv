// note v_width changed to 1 same to t-width

`include "defines.vh"

module fsm_msg_create_2 # (parameter VALUE_WIDTH = `VALUE_DATA_WIDTH, T_SIZE = 5, SIZE = 64) (

		input 				clk,
		input				rst,
		input				tag_valid_i,
		input				val_valid_i,
		input[31:0]			tag_i,
		input[VALUE_WIDTH-1:0]		val_i,
		input[T_SIZE-1:0]		t_size_i,
		//input[VALUE_WIDTH>>SIZE -1:0]	v_size_i,
		input[SIZE-1:0]			v_size_i,
		input 				checksum_i,
		input[7:0]			checksum_val_i,		// from create_checksum

		input				fifo_full_i,

		output reg[7:0]			data_o,
	//	output reg			start_chksm_o,		// indicates start create_checksum
		output reg			done_o,
		output reg			end_o,
		output reg			all_sent_o,
		output reg			end_of_msg_o,
		output reg			data_valid_o
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
reg [11:0]			state;
reg [11:0]			next_state;

reg[T_SIZE-1:0]			t_width;
reg[T_SIZE-1:0]			t_width_t;
reg[SIZE -1 :0]			v_width;
reg[SIZE -1 :0]			v_width_t;
integer				temp_var;
integer				temp_var_t;

reg				start_chksm_o;

// build state flops
always @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end

// state machine
//always @ (state or tag_valid_i or val_valid_i or checksum_i or t_width or v_width or checksum_val_i) begin
always @ (*) begin

	if (rst) begin
		done_o 			= '0;
		data_o			= '0;
		start_chksm_o		= '0;
		end_o			= '0;
		all_sent_o	=	'0;
		data_valid_o		= '0;
		temp_var		=  0;
	end

	case (state)

	// sending tag- starts from very first tag
	state0: begin
		if (fifo_full_i == 1) begin 
			next_state	=	state0;
			data_valid_o	=	'0;			
			all_sent_o	=	'0;
		end else begin
		if ( tag_valid_i == 1 && checksum_i == 0) begin
			data_o		=	tag_i [temp_var*8 +: 8];
			done_o		=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			all_sent_o	=	'0;
			end_o		=	'0;
			data_valid_o	=	'1;			
			t_width		=	t_size_i;
			temp_var_t 	= 	temp_var + 1;
			t_width_t 	= 	t_width >> 1;	
			next_state 	=	state1;
		end else if (tag_valid_i == 1 && checksum_i == 1) begin
			data_o		=	tag_i [temp_var*8 +: 8];
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			done_o		=	'0;
			data_valid_o	=	'1;			
			end_o		=	'0;
			all_sent_o	=	'0;
			temp_var_t 	= 	temp_var + 1;
			t_width		=	t_size_i;
			t_width_t 	= 	t_width >> 1;	
			next_state 	=	state6;
		end else begin
			next_state	=	state0;
			data_o		=	'0;
			done_o		=	'0;
			end_of_msg_o	=	'0;
			data_valid_o	=	'0;			
			start_chksm_o	=	'0;
			all_sent_o	=	'0;
			end_o		=	'0;				
		end
		end
		end

	state1: begin
		if (fifo_full_i == 1) begin 
			next_state	=	state1;
			data_valid_o	=	'0;			
			all_sent_o	=	'0;
		end else begin
		if (t_width_t == 0) begin
			done_o		=	'1;			// edit 1 to 0
			end_o		=	'0;
			end_of_msg_o	=	'0;
			data_valid_o	=	'1;			
			all_sent_o	=	'0;
			data_o		=	8'h3d;
			start_chksm_o	=	'1;			// send checksum start signal
			temp_var_t	=	0;
			next_state 	=	state3;
		end else begin
			data_o		=	tag_i [temp_var_t*8 +: 8];
			end_o		=	'0;
			end_of_msg_o	=	'0;
			data_valid_o	=	'1;			
			start_chksm_o	=	'0;
			all_sent_o	=	'0;
			done_o		=	'0;
			temp_var 	= 	temp_var_t + 1;
			t_width 	= 	t_width_t >> 1;	
			done_o 		=	'0;
			next_state	=	state2;
		end	
		end	
		end


	state2: begin
		if (fifo_full_i == 1) begin 
			next_state	=	state2;
			data_valid_o	=	'0;			
			all_sent_o	=	'0;
		end else begin
		if (t_width == 0) begin
			done_o		=	'1;
			start_chksm_o	=	'0;
			end_o		=	'0;
			end_of_msg_o	=	'0;
			all_sent_o	=	'0;
			data_valid_o	=	'1;			
			data_o		=	8'h3d;
			temp_var_t	=	0;
			next_state 	=	state3;
		end else begin
			data_o		=	tag_i [temp_var*8 +: 8];
			done_o		=	'0;
			end_o		=	'0;
			end_of_msg_o	=	'0;
			all_sent_o	=	'0;
			data_valid_o	=	'1;			
			start_chksm_o	=	'0;
			temp_var_t 	= 	temp_var + 1;
			t_width_t 	= 	t_width >> 1;	
			next_state	=	state1;
		end	
		end	

		end

	state3: begin
		if (fifo_full_i == 1)begin 
			next_state	=	state3;
			data_valid_o	=	'0;				
			all_sent_o	=	'0;
		end else begin
		if (val_valid_i == 1 ) begin
			end_o		=	'0;
			start_chksm_o	=	'0;
			data_valid_o	=	'1;			
			end_of_msg_o	=	'0;
			all_sent_o	=	'0;
			done_o		=	'0;
			data_o		=	val_i [temp_var_t*8 +: 8];
			v_width		=	v_size_i;
			temp_var 	= 	temp_var_t + 1;
			v_width_t 	= 	v_width >> 1;	
			next_state 	=	state4;
		end else begin
			data_valid_o	=	'0;			
			next_state	=	state3;
		end
		end
		end

	state4: begin
		if (fifo_full_i == 1)begin 
			next_state	=	state4;
			data_valid_o	=	'0;			
			all_sent_o	=	'0;
		end else begin
		if (v_width_t[0] == 0) begin
			end_o		=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			done_o		=	'1;
			data_valid_o	=	'1;			
			all_sent_o	=	'0;
			data_o		=	8'h01;
			temp_var_t	=	0;
			temp_var	=	0;
			next_state 	=	state0;
		end else begin
			data_o		=	val_i [temp_var*8 +: 8];
			done_o 		=	'0;
			start_chksm_o	=	'0;
			data_valid_o	=	'1;			
			end_of_msg_o	=	'0;
			end_o		=	'0;
			temp_var_t 	= 	temp_var + 1;
			all_sent_o	=	'0;
			v_width 	= 	v_width_t >> 1;	
			next_state	=	state5;
		end
		end	
		end

	state5: begin
		if (fifo_full_i == 1) begin 
			next_state	=	state5;
			data_valid_o	=	'0;			
			all_sent_o	=	'0;
		end else begin
		if (v_width[0] == 0) begin
			end_o		=	'0;
			end_of_msg_o	=	'0;
			data_valid_o	=	'1;			
			start_chksm_o	=	'0;
			done_o		=	'1;
			all_sent_o	=	'0;
			data_o		=	8'h01;
			temp_var_t	=	0;
			temp_var	=	0;
			next_state 	=	state0;
		end else begin
			end_o		=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			all_sent_o	=	'0;
			data_valid_o	=	'1;			
			data_o		=	val_i [temp_var_t*8 +: 8];
			done_o 		=	'0;
			temp_var 	= 	temp_var_t + 1;
			v_width_t 	= 	v_width >> 1;	
			next_state	=	state4;
		end
		end	
		end

	state6: begin
		if (fifo_full_i == 1) begin 
			next_state	=	state6;
			data_valid_o	=	'0;			
			all_sent_o	=	'0;
		end else begin
		if (t_width_t == 0) begin
			end_o		=	'0;
			start_chksm_o	=	'0;
			all_sent_o	=	'0;
			data_valid_o	=	'1;			
			end_of_msg_o	=	'1;		// end of msg signal checksum to stop
			done_o		=	'1;
			data_o		=	8'h3d;
			temp_var_t	=	0;
			next_state 	=	state8;
		end else begin
			end_o		=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
			all_sent_o	=	'0;
			data_valid_o	=	'1;			
			data_o		=	tag_i [temp_var_t*8 +: 8];
			done_o 		=	'0;
			temp_var 	= 	temp_var_t + 1;
			t_width	 	= 	t_width_t >> 1;	
			next_state	=	state7;
		end
		end	
		end

	state7: begin
		if (fifo_full_i == 1)begin 
			next_state	=	state7;
			data_valid_o	=	'0;			
			all_sent_o	=	'0;
		end else begin
		if (t_width == 0) begin
			end_o		=	'0;
			start_chksm_o	=	'0;
			end_of_msg_o	=	'1;	
			data_valid_o	=	'1;			
			done_o		=	'1;
			all_sent_o	=	'0;
			data_o		=	8'h3d;
			temp_var	=	0;
			next_state 	=	state8;
		end else begin
			end_o		=	'0;
			start_chksm_o	=	'0;
			end_of_msg_o	=	'0;	
			all_sent_o	=	'0;
			data_valid_o	=	'1;			
			data_o		=	tag_i [temp_var*8 +: 8];
			done_o 		=	'0;
			temp_var_t 	= 	temp_var + 1;
			t_width_t 	= 	t_width >> 1;	
			next_state	=	state6;
		end
		end	
		end

	// checksum first byte
	state8: begin
		if (fifo_full_i == 1)begin 
			next_state	=	state8;
			data_valid_o	=	'0;			
			all_sent_o	=	'0;
		end else begin
			end_o		=	'0;
			done_o		=	'0;
			data_valid_o	=	'1;			
			all_sent_o	=	'0;
			end_of_msg_o	=	'0;
			start_chksm_o	=	'0;
		//	data_o		=	8'h33;			//checksum_val_i; temp	
			data_o		=	checksum_val_i;	
			next_state	=	state9;
		end
		end

	// checksum second byte
	state9: begin
		if (fifo_full_i == 1) begin 
			next_state	=	state9;
			data_valid_o	=	'0;			
			all_sent_o	=	'0;
		end else begin
			end_o		=	'0;
			done_o		=	'0;
			end_of_msg_o	=	'0;
			data_valid_o	=	'1;			
			start_chksm_o	=	'0;
			all_sent_o	=	'0;
		//	data_o		=	8'h31;			//checksum_val_i; temp	
			data_o		=	checksum_val_i;	
			next_state	=	state10;
		end
		end

	// checksum third byte
	state10: begin
		if (fifo_full_i == 1) begin 
			next_state	=	state10;
			data_valid_o	=	'0;			
			all_sent_o	=	'0;
		end else begin
			end_o		=	'0;
			done_o		=	'0;
			end_of_msg_o	=	'0;
			all_sent_o	=	'0;
			data_valid_o	=	'1;			
			start_chksm_o	=	'0;
		//	data_o		=	8'h36;			//checksum_val_i; temp	
			data_o		=	checksum_val_i;	
			next_state	=	state11;
		end
		end

	state11: begin
		if (fifo_full_i == 1) begin 
			next_state	=	state11;
			data_valid_o	=	'0;			
			all_sent_o	=	'0;
		end else begin
			all_sent_o	=	'1;
			done_o		=	'0;
			end_of_msg_o	=	'0;
			data_valid_o	=	'1;			
			start_chksm_o	=	'0;
			data_o		=	8'h01;
			end_o		=	'1;	
			next_state	=	state0;
		end
		end
	endcase

end


endmodule