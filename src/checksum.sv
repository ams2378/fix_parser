/**
 * @filename		checksum.sv 
 *
 * @brief     	        compute checksum on the received message  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	n/a	
 */


module checksum(
	
	input[7:0]		data_i,
	input			start_i,
	input			end_i,

	output[7:0]		checksum_o

);

parameter 			state0 = 2'b00;
parameter			state1 = 2'b01;
parameter			state2 = 2'b10;

logic [1:0]			state;
logic [1:0]			next_state;
logic [8:0]			checksum;
logic [8:0]			temp;
logic [7:0]			soh = 8'h01;
logic [7:0]			head = 8'h38;


always_ff @(posedge clk) begin

	if (rst)		state <= initial_s;
	else			state <= next_state;
end

always_ff @(state or data_i) begin

	if (rst) begin
		checksum = '0;
	end

	case(state) 
		
		state0: begin 
				if (start_i == 0) begin
					next_state = state0;
				end else begin
					temp = soh + head + data_i; 
					next_state = state1;
				end
		end
		state1: begin
				if (state_i != 1) begin
					temp = temp + data_i;
					next_state = state1;
				end else if (data_i == sep_c) begin
					temp = temp - 8'h31 - 8'h30 - 8'h01;	
					next_state = value;
				end
		end
		state2: begin	
				checksum = checksum % 9'b100000000;
				next_state = state0;
		end
	endcase
end

assign checksum_o = checksum; 

endmodule
