/**
 * @filename		fix_parser_out_module.sv 
 *
 * @brief     	        strip out tag and value from the message 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 */

module fix_parser_out_module(

	input 				clk,
	input				rst,
	input[7:0]			data_i,
	input				start_tag_i,
	input				start_value_i,

	/* control signals for FIFO */	
//	output				t_wr_cs_o, 		   
//	output				t_wr_en_o, 		   
//	output				v_wr_cs_o, 		   
//	output				v_wr_en_o, 		   

	/* final tag and value- to be pushed in FIFO*/
	output[31:0]			tag_o,
	output[255:0]			value_o,
	output				end_of_body_o,
	output				start_of_header_o,

	output[31:0]			data,
	output				empty,
	output				full
);

/* state variable */
parameter 			state0 = 3'b000;
parameter			state1 = 3'b001;
parameter			state2 = 3'b010;
parameter 			state3 = 3'b011;
parameter 			state4 = 3'b100;
parameter 			state5 = 3'b101;

logic [2:0]			state;
logic [2:0]			next_state;

/* internal signals */
logic				t_wr_cs;		   
logic				t_wr_en;		   
logic				v_wr_cs;		   
logic				v_wr_en; 
		   
logic[31:0]			tag;
logic[255:0]			value;
logic				end_of_body;
logic				start_of_header;

logic [7:0] 			first_tag = 8'h38;		// ASCII for "8" - indicates start of a new FIX message
logic [15:0] 			last_tag = 16'h3130;		// ASCII for "10" - indicates the last TAG

bit	last_tag_valid;

logic	incr_i;
 
always_ff @(posedge clk) begin
	if (rst)		state <= state0;
	else			state <= next_state;
end

always_ff @(state or start_tag_i or start_value_i) begin
	
	if (rst) begin
		tag = '0;
		value = '0;
		end_of_body = '0;
		start_of_header = '0;
		t_wr_cs = '0; 
		t_wr_en = '0;
		v_wr_cs = '0; 
		v_wr_en = '0;	
	end
	
	case(state) 
	
		state0: begin 				
				if (start_tag_i == 1) begin
					start_of_header = '0;
					end_of_body = '0;
					tag [7:0] = data_i;
					v_wr_cs = '0;	
					v_wr_en = '0;
					t_wr_cs = '0;
					t_wr_en = '0;	
					next_state = state1;
				end else begin
					v_wr_cs = '0;	
					v_wr_en = '0;
					t_wr_cs = '0;
					t_wr_en = '0;	
					value = '0;
					start_of_header = '0;
					end_of_body = '0;
					next_state = state0;
				end
		end
		state1: begin
				value = '0;
				v_wr_cs = '0;	
				v_wr_en = '0;	
				if (start_tag_i == 1) begin
					tag  <<= 8;
					tag[7:0] = data_i;
					next_state = state2;
				end else if (start_tag_i == 0 ) begin
					t_wr_cs = '1;	
					t_wr_en = '1;
					if (tag [7:0] == first_tag) begin
						start_of_header = '1;
						next_state = state3;
					end else if (tag [15:0] == last_tag) begin
						end_of_body = 1;
						next_state = state3;
					end else 
						next_state = state3;
				end
		end
		state2: begin
				value = '0;
				v_wr_cs = '0;	
				v_wr_en = '0;	
				if (start_tag_i == 1) begin
					tag  <<= 8;
					tag[7:0] = data_i;
					next_state = state1;
				end else if (start_tag_i == 0) begin
					t_wr_cs = '1;	
					t_wr_en = '1;
					if (tag [7:0] == first_tag) begin
						start_of_header = '1;
						next_state = state3;
					end else if (tag [15:0] == last_tag) begin
						end_of_body = 1;
						next_state = state3;
					end else 
						next_state = state3;
				end
		end
		state3: begin
				t_wr_cs = '0;	
				t_wr_en = '0;
				v_wr_cs = '0;	
				v_wr_en = '0;	
				if (start_value_i == 1) begin
					value[7:0] = data_i;
					next_state = state4;
				end else 
					next_state = state3;
		end
		state4:	begin
				tag = '0;
				t_wr_cs = '0;	
				t_wr_en = '0;
				if (start_value_i == 1) begin
					value <<= 8;
					value [7:0] = data_i;
					next_state = state5;
				end else begin	
					v_wr_cs = '1;	
					v_wr_en = '1;			
			 		if (end_of_body == 1) 		next_state = state0;
					else 				next_state = state1;
				end
			end	

		state5: begin
				tag = '0;
				t_wr_cs = '0;	
				t_wr_en = '0;
				if (start_value_i == 1) begin
					value <<= 8;
					value [7:0] = data_i;
					next_state = state4;
				end else begin
					v_wr_cs = '1;	
					v_wr_en = '1;	
			 		if (end_of_body == 1) 		next_state = state0;
					else 				next_state = state1;
				end

		end
	endcase
end


assign tag_o = tag;
assign value_o = value;
assign start_of_header_o = start_of_header;
assign end_of_body_o = end_of_body;
//assign t_wr_en_o = t_wr_en;
//assign t_wr_cs_o = t_wr_cs;
//assign v_wr_en_o = v_wr_en;
//assign v_wr_cs_o = v_wr_cs;


fifo_top #(.DATA_WIDTH (32), .ADDR_WIDTH (8)) tag_fifo (
	
		.clk (clk)     		, 		
		.rst (rst)     		, 		
		.wr_cs_i (t_wr_cs)    	, 		
		.rd_cs_i (1'b0)    	,	 		
		.data_i  (tag)  	, 		
		.rd_en_i (1'b0)    	, 		
		.wr_en_i (t_wr_en)   	, 		

		.data_o	(data)     	,	 		
		.empty_o (empty) 	, 		
		.full_o  (full)     		
); 







endmodule

