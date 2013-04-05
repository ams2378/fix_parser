/**
 * @filename		checksum.sv 
 *
 * @brief     	        computes checksum of the received message  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	ascii2int.sv	
 */


module checksum(

	input			clk,
	input			rst,	
	input[7:0]		data_i,
	input			start_i,
	input			end_i,

//	output[7:0]		checksum_o,
	output			chk_done_o,
	output			valid_o
);

parameter 			state0 = 3'b000;
parameter			state1 = 3'b001;
parameter			state2 = 3'b010;
parameter			state3 = 3'b011;
parameter			state4 = 3'b100;

logic [2:0]			state;
logic [2:0]			next_state;
logic [7:0]			checksum;
logic [8:0]			temp;
logic [7:0]			soh = 8'h01;
logic [7:0]			head = 8'h38;

logic [7:0]		 	rcv_checksum;
logic				ready2cmp_i;
logic				chk_done;
logic				valid;


always_ff @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end

always_ff @(state or start_i or end_i or ready2cmp_i ) begin

	if (rst) begin
		checksum = '0;
		valid = '0;
		chk_done = '0;
	end

	case(state) 
		
		state0: begin 
				if (start_i == 1) begin
					chk_done = 0;
					temp = 8'd117;	// head + data_i; 
					next_state = state1;
				end else begin
					chk_done = 0;
					valid = '0;
					next_state = state0;
				end
		end
		state1: begin
				if (end_i != 1) begin
					chk_done = 0;
					temp = temp + data_i;
					if (temp >= 9'd256) begin
						temp = temp - 9'd256;
					end
					next_state = state2;
				end else begin
					chk_done = 0;
					next_state = state3;
				end
		end
		state2: begin
				if (end_i != 1) begin
					chk_done = 0;
					temp = temp + data_i;
					if (temp >= 9'd256) begin
						temp = temp - 9'd256;
					end
					next_state = state1;
				end else begin
					chk_done = 0;
					next_state = state3;
				end
		end
		state3: begin
				chk_done = 0;
				temp = temp - 8'd97;	
				if (temp >= 9'd256) begin	
					temp = temp - 9'd256;
				end
				temp = temp % 9'd256;
				checksum = temp[7:0];
				next_state = state4;
		end
		state4: begin
				if (ready2cmp_i == 1) begin
					valid = (checksum == rcv_checksum); 
					chk_done = 1;
					next_state = state0;
				end else
					next_state = state4;
		end
	endcase
end

assign valid_o 		= 	valid; 
assign chk_done_o	=	chk_done;

ascii2int ascii2binary (

		.clk, 
		.rst,
		
		.data_i,
		.end_i,
		.done_o(ready2cmp_i),
		.result_o(rcv_checksum)
);

endmodule
