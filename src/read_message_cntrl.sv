/**
 * @filename		read_message_cntrl.sv 
 *
 * @brief     	        generate control signals to initiate fetching of stored value in the memory for each FIX message	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	n/a	
 */

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
logic				read_start_loc;
logic				read_end_loc;	

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
assign	read_message_loc_o		=	read_message_loc;
assign	read_start_addr_loc_o		=	read_start_loc;
assign	read_end_addr_loc_o		=	read_end_loc;


endmodule









