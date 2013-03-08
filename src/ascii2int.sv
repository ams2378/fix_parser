/**
 * @filename		ascii2int.sv 
 *
 * @brief     	        converts received ASCII to INT  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	n/a	
 */


module ascii2int(

   	input             	clk,     
   	input             	rst, 
   	input [7:0]      	data_i,
	input			end_i, 
   
   	output[7:0] 		result_o   
   );


parameter 			state0 = 2'b000;
parameter			state1 = 2'b001;
parameter			state2 = 2'b010;
parameter			state3 = 2'b011;
parameter			state4 = 2'b100;

logic [2:0]			state;
logic [2:0]			next_state;
logic [7:0]			result;

logic [7:0]			d2;
logic [7:0]			d1;
logic [7:0]			d0;


always_ff @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end

always_ff @(state or end_i) begin

	if (rst) begin
		result = '0;
	end

	case(state) 
		
		state0: begin 
				if (end_i == 1) begin
					next_state = state1;
				end else begin
					next_state = state0;
				end
		end
		state1: begin
				d2 = data_i - 8'd48;	
				next_state = state2;
		end
		state2: begin
				d2 = d2 * 8'd100;
				d1 = data_i - 8'd48;	
				next_state = state3;
		end
		state3: begin
				d1 = d1 * 8'd10;
				d0 = data_i - 8'd48;	
				next_state = state4;
		end
		state4: begin
				result = d2 + d1 + d0;	
				next_state = state0;
		end
	endcase
end

assign result_o = result; 

endmodule

