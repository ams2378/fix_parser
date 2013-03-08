/**
 * @filename		checksum.sv 
 *
 * @brief     	        computes checksum of the received message  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	n/a	
 */


module checksum(

	input			clk,
	input			rst,	
	input[7:0]		data_i,
	input			start_i,
	input			end_i,

	output[7:0]		checksum_o
);

parameter 			state0 = 2'b00;
parameter			state1 = 2'b01;
parameter			state2 = 2'b10;
parameter			state3 = 2'b11;

logic [1:0]			state;
logic [1:0]			next_state;
logic [7:0]			checksum;
logic [8:0]			temp;
logic [7:0]			soh = 8'h01;
logic [7:0]			head = 8'h38;


always_ff @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end

always_ff @(state or start_i or end_i) begin

	if (rst) begin
		checksum = '0;
	end

	case(state) 
		
		state0: begin 
				if (start_i == 1) begin
					temp = 8'd117;	// head + data_i; 
					next_state = state1;
				end else begin
					next_state = state0;
				end
		end
		state1: begin
				if (end_i != 1) begin
					temp = temp + data_i;
					if (temp >= 9'd256) begin
						temp = temp - 9'd256;
					end
					next_state = state2;
				end else begin
					next_state = state3;
				end
		end
		state2: begin
				if (end_i != 1) begin
					temp = temp + data_i;
					if (temp >= 9'd256) begin
						temp = temp - 9'd256;
					end
					next_state = state1;
				end else begin
					next_state = state3;
				end
		end
		state3: begin
				temp = temp - 8'd97;	
				if (temp >= 9'd256) begin	
					temp = temp - 9'd256;
				end
				temp = temp % 9'd256;
				checksum = temp[7:0];
				next_state = state0;
		end
	endcase
end

assign checksum_o = checksum; 

endmodule
