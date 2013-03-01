
module read_message_cntrl #(parameter TAG_WIDTH = 32, NUM_MESSAGE = 10) (

	input				clk,
	input				rst,

	input				read_message_i,

	output				search_tag_o,
	output				read_message_loc_o,
	output				read_start_addr_loc_o,
	output				read_end_addr_loc_o	
);

logic				search_tag;
logic				read_message_loc;
logic				read_start_addr_loc;
logic				read_end_addr_loc;	

always_ff @ (posedge clk or posedge rst or read_message_i) begin

	if (rst) begin
		search_tag = '0;
		read_message_loc = '0;
		read_start_loc = '0;
		read_end_loc = '0;	
	end else if (read_message_i) begin 
		search_tag = '1;
		read_message_loc = '1;
		read_start_loc = '1;
		read_end_loc = '1;	
	end else begin
		search_tag = '0;
		read_message_loc = '0;
		read_start_loc = '0;
		read_end_loc = '0;	
	end
end


assign 	search_tag_o 			= 	search_tag;
assign	read_message_loc		=	read_message_loc_o;
assign	read_start_addr_loc		=	read_start_loc_o;
assign	read_end_addr_loc		=	read_end_loc_o;


endmodule









/*
parameter 			state0 = 3'b00;
parameter			state1 = 3'b01;

logic [1:0]			state;
logic [1:0]			next_state;

logic				search_tag;
logic				read_message_loc;
logic				read_start_loc;
logic				read_end_loc;	

always_ff @(posedge clk) begin
	if (rst)		state <= state0;
	else			state <= next_state;
end

always_ff @(state or start_tag_i or start_value_i) begin
	
	if (rst) begin
		search_tag = '0;
		read_message_loc = '0;
		read_start_loc = '0;
		read_end_loc = '0;	
	end
	
	case(state) 
	
		state0: begin 				
				if (read_message_i == 1) begin
					search_tag = '1;
					read_message_loc = '1;
					read_start_loc = '1;
					read_end_loc = '1;	
					next_state = state1;
				end else begin
					search_tag = '0;
					read_message_loc = '0;
					read_start_loc = '0;
					read_end_loc = '0;	
					next_state = state0;
				end
		end
		state1: begin
					next_state = state0;
		end
	endcase
end
*/
