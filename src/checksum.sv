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

	input			clk,
	input			rst,	
	input[7:0]		data_i,
	input			start_i,
	input			end_i,

	output[8:0]		checksum_o

);

parameter 			state0 = 2'b00;
parameter			state1 = 2'b01;
parameter			state2 = 2'b10;

logic [1:0]			state;
logic [1:0]			next_state;
logic [8:0]			checksum;
logic [15:0]			temp;
logic [7:0]			soh = 8'h01;
logic [7:0]			head = 8'h38;


always_ff @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end

//always_ff @(clk or state or start_i or end_i or data_i) begin
always_ff @(posedge clk) begin

	if (rst) begin
		checksum = '0;
	end

	case(state) 
		
		state0: begin 
				if (start_i == 1) begin
					temp = 8'd118;	//soh + head + data_i; 
					next_state = state1;
				end else begin
					next_state = state0;
				end
		end
		state1: begin
				if (end_i != 1) begin
					temp = temp + data_i;
				//	if (temp > 9'd256) begin
				//		temp = temp - 9'd256;
				//	end
					next_state = state1;
				end else begin
					temp = temp - 8'h31 - 8'h30;	
					next_state = state2;
				end
		end
		state2: begin
		//		if (temp >= 9'd256) begin	
		//			temp = temp - 9'd256;
		//		end
				temp = temp % 9'd256;
				checksum = temp[8:0];
				next_state = state0;
		end
	endcase
end

assign checksum_o = checksum; 

endmodule
