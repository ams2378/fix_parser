/**
 * @filename		fix_parser_out_module.sv 
 *
 * @brief     	        strip out tag and value from the message 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	n/a	
 */

module fix_parser_out_module (

	input 				clk,
	input				rst,
	input[7:0]			data_i,
	input[7:0]			message_i,
	input				start_tag_i,
	input				start_value_i,

	/* control signals for FIFO */	
	output				t_wr_cs_o, 		   
	output				t_wr_en_o, 		   
	output				v_wr_cs_o, 		   
	output				v_wr_en_o, 		   

	/* final tag and value- to be pushed in FIFO*/
	output[31:0]			tag_o,
	output[255:0]			value_o,
	output reg	 		end_detected_o,

	output				start_message_o
//	output				start_of_header_o
);

// bellow 1 moved from port list
reg				start_of_header_o;
reg				end_of_body_o;

reg				clear_tag;
reg				clear_val;


/* state variable */
parameter 			state0 = 3'b000;
parameter			state1 = 3'b001;
parameter			state2 = 3'b010;
parameter 			state3 = 3'b011;
parameter 			state4 = 3'b100;
parameter 			state5 = 3'b101;

reg [2:0]			state;
reg [2:0]			next_state;

/* state variable */
parameter 			sstate0 = 3'b000;
parameter			sstate1 = 3'b001;
parameter			sstate2 = 3'b010;
parameter 			sstate3 = 3'b011;
parameter 			sstate4 = 3'b100;
parameter 			sstate5 = 3'b101;

reg [2:0]			sstate;
reg [2:0]			next_sstate;

/* internal signals */
reg				t_wr_cs;		   
reg				t_wr_en;		   
reg				v_wr_cs;		   
reg				v_wr_en; 
		   
reg[31:0]			tag = '0;
//reg[31:0]			tag;				// edit syn
reg[255:0]			value = '0;
reg				end_of_body;
reg				start_of_header;
reg				start_message;
reg				end_message;

reg [7:0] 			first_tag = 8'h38;		// ASCII for "8" - indicates start of a new FIX message
reg [31:0] 			last_tag = 32'h00003130;		// ASCII for "10" - indicates the last TAG

reg				last_tag_valid;
reg				incr_i;
reg				load_tag;
reg				load_val;
reg				shift_tag;
reg				shift_val;
//reg				end_detected_o;			// edit syn
 
always @(posedge clk) begin
	if (rst)		state <= state0;
	else			state <= next_state;
end

//always @(state or start_tag_i or start_value_i) begin
always @ (*) begin	
	if (rst) begin
		end_of_body = '0;
		start_of_header = '0;
		t_wr_cs = '0; 
		t_wr_en = '0;
		v_wr_cs = '0; 
		v_wr_en = '0;
		clear_tag = '0;
		clear_val = '0;
		start_message = '0;	
	end
	
	case(state) 
	
		state0: begin 	
					start_of_header = '0;
					clear_tag   = '0;
					clear_val   = '0;
					start_message = '0;
					end_of_body = '0;
					load_tag  = '0;
					shift_tag = '0;
					load_val  = '0;
					shift_val = '0;			
				if (start_tag_i == 1) begin
					start_of_header = '0;
					end_of_body = '0;
					load_tag = '1;		
					v_wr_cs = '0;	
					v_wr_en = '0;
					t_wr_cs = '0;
					t_wr_en = '0;
					start_message = '0;
					next_state = state1;
				end else begin
					v_wr_cs = '0;	
					v_wr_en = '0;
					t_wr_cs = '0;
					t_wr_en = '0;
			//		value = '0;
					start_of_header = '0;
					end_of_body = '0;
					next_state = state0;
				end
		end
		state1: begin
					v_wr_cs = '0;	
					v_wr_en = '0;
					t_wr_cs = '0;
					t_wr_en = '0;
					start_message = '0;
					end_of_body = '0;
					load_tag  = '0;
					start_of_header = '0;
					clear_tag   = '0;
					clear_val   = '0;
					shift_tag = '0;
					load_val  = '0;
					shift_val = '0;	
		//			value = '0;
					v_wr_cs = '0;	
					v_wr_en = '0;	
				if (start_tag_i == 1) begin
					shift_tag   =	'1;		
					next_state = state2;
				end else if (start_tag_i == 0 ) begin

						clear_tag   = '1;

					t_wr_cs = '1;	
					t_wr_en = '1;
					if (tag [7:0] == first_tag) begin
						start_of_header = '1;
						start_message = '1;
						next_state = state3;
					end else if (tag [31:0] == last_tag ) begin  // && message_i == 8'h3d
						end_of_body = 1;
						next_state = state3;
					end else 
						next_state = state3;
				end
		end
		state2: begin
					v_wr_cs = '0;	
					v_wr_en = '0;
					t_wr_cs = '0;
					t_wr_en = '0;
					clear_tag   = '1;
					end_of_body = '0;
					start_of_header = '0;
					load_tag  = '0;
					shift_tag = '0;
					start_message = '0;
					clear_val   = '0;
					load_val  = '0;
					shift_val = '0;	
			//		value = '0;
				if (start_tag_i == 1) begin
					shift_tag   =  '1;
					next_state = state1;
				end else if (start_tag_i == 0) begin
					t_wr_cs = '1;	
					t_wr_en = '1;
					if (tag [7:0] == first_tag) begin
						start_of_header = '1;
						start_message = '1;
						next_state = state3;
		
						clear_tag   = '1;

					end else if (tag [31:0] == last_tag) begin
						end_of_body = 1;
						next_state = state3;
						clear_tag   = '1;

					end else 
						next_state = state3;
				end
		end
		state3: begin
					v_wr_cs = '0;	
					v_wr_en = '0;
					t_wr_cs = '0;
					t_wr_en = '0;
					end_of_body = '0;
					clear_tag   = '0;
					start_of_header = '0;

					load_tag  = '0;
					shift_tag = '0;
					load_val  = '0;
					clear_val   = '0;
					shift_val = '0;	
					start_message = '0;
					end_of_body = '0;	
				if (start_value_i == 1) begin
					load_val =  '1;
					next_state = state4;
				end else 
					next_state = state3;
		end
		state4:	begin
					end_of_body = '0;
					clear_tag   = '0;
					start_of_header = '0;
					load_tag  = '0;
					clear_val   = '0;
					shift_tag = '0;
					load_val  = '0;
					shift_val = '0;	
		//			tag = '0;			// edit syn
					v_wr_cs = '0;	
					v_wr_en = '0;
					t_wr_cs = '0;
					t_wr_en = '0;
					start_message = '0;	
				if (start_value_i == 1) begin
					shift_val  = '1;
					next_state = state5;
				end else begin	

					clear_val   = '1;

					v_wr_cs = '1;	
					v_wr_en = '1;			
			 		if (end_of_body == 1) 		next_state = state0;
					else 				next_state = state0;
				end
			end	
		state5: begin
					end_of_body = '0;
					start_of_header = '0;
					load_tag  = '0;
					clear_val   = '0;
					shift_tag = '0;
					clear_tag   = '0;
					load_val  = '0;
					shift_val = '0;	
			//		tag = '0;
					v_wr_cs = '0;	
					v_wr_en = '0;
					t_wr_cs = '0;
					t_wr_en = '0;
					start_message = '0;	
				if (start_value_i == 1) begin
					shift_val  = '1;
					next_state = state4;
				end else begin

					clear_val   = '1;

					v_wr_cs = '1;	
					v_wr_en = '1;	
			 		if (end_of_body == 1) 		next_state = state0;
					else 				next_state = state0;
				end
			end
		default:  begin
				end_of_body = '0;
				start_of_header = '0;
				t_wr_cs = '0; 
				t_wr_en = '0;
				v_wr_cs = '0; 
				v_wr_en = '0;
				clear_tag = '0;
				clear_val = '0;
				start_message = '0;	
				next_state	=	state0;
			  end

	endcase
end


always @(posedge clk) begin

	if (rst) begin
		tag	<=	'0;
		value	<=	'0;
	end //else begin


	if (clear_tag == 1)
		tag		<=	'0;


	if (clear_val == 1)
		value		<=	'0;

	if (load_tag == 1) begin
		tag[7:0]	<=	data_i;
	end

	if (shift_tag == 1) begin
		tag		<=	tag << 8;
		tag[7:0]	<=	data_i;
	end

	if (load_val == 1) begin
		value[7:0]	<=	data_i;
	end

	if (shift_val ==1) begin
		value		<=	value << 8;
		value[7:0]	<=	data_i;
	end
	
	//end
end

always @ (posedge clk) begin
	if (rst)	sstate	<=	sstate0;
	else		sstate	<=	next_sstate;
end

always @ (*) begin

	case (sstate) 

	sstate0:	begin
					end_detected_o	=	'0;
				if (message_i == 8'h01)
					next_sstate	=	sstate1;
				else
					next_sstate	=	sstate0;
			end	

	sstate1:	begin
					end_detected_o	=	'0;
				if (message_i == 8'h31)
					next_sstate	=	sstate2;
				else
					next_sstate	=	sstate0;
			end	

	sstate2:	begin
					end_detected_o	=	'0;
				if (message_i == 8'h30)
					next_sstate	=	sstate3;
				else
					next_sstate	=	sstate0;
			end	

	sstate3:	begin
					end_detected_o	=	'0;
				if (message_i == 8'h3d) begin
					end_detected_o	=	'1;
					next_sstate	=	sstate0;
				end else
					next_sstate	=	sstate0;
			end
	endcase	
end

assign 	tag_o 			= 	tag;
assign 	value_o 		= 	value;
assign 	start_of_header_o 	= 	start_of_header;
assign 	end_of_body_o 		= 	end_of_body;
assign 	start_message_o 	= 	start_message;
assign 	t_wr_en_o 		= 	t_wr_en;
assign 	t_wr_cs_o 		= 	t_wr_cs;
assign 	v_wr_en_o 		= 	v_wr_en;
assign 	v_wr_cs_o 		= 	v_wr_cs;

endmodule
