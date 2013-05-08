
module counter #(parameter CNT_SIZE = 20, NUM_HOST = 2) (

		input 				clk,
		input				rst,
		input[CNT_SIZE-1:0]		heartbeat_i,
		input				send_message_i,
		input[NUM_HOST-1:0]		sending_to_host_addr_i,
	
		output reg			timeout_o,
		output reg[NUM_HOST-1:0]	timeout_addr_o
		);

reg[CNT_SIZE-1:0]	c0;	
reg[CNT_SIZE-1:0]	c1;	
reg[CNT_SIZE-1:0]	c2;	
reg[CNT_SIZE-1:0]	c3;	

// initialize mem at rst
always @(clk) begin
	if (rst) begin
		c0	<=	'0;
		c1	<=	'0;
		c2	<=	'0;
		c3	<=	'0;
	end
end

always @(clk) begin

	timeout_o	<=	'0;
	timeout_addr_o	<=	2'b00;

	if (c0 == heartbeat_i) begin
		timeout_o	<=	'1;
		timeout_addr_o	<=	2'b00;
		c0		<=	'0;
	end 

	if (c1 == heartbeat_i) begin
		timeout_o	<=	'1;
		timeout_addr_o	<=	2'b00;
		c1		<=	'0;
	end  

	if (c2 == heartbeat_i) begin
		timeout_o	<=	'1;
		timeout_addr_o	<=	2'b10;	
		c2		<=	'0;
	end 

	if (c3 == heartbeat_i) begin
		timeout_o	<=	'1;
		timeout_addr_o	<=	2'b11;	
		c3		<=	'0;
	end

	if (send_message_i == 1 ) begin
		case (sending_to_host_addr_i) 
			2'b00	:  	begin
						c0 <= c0 + 1;
					end
			2'b01	:  	begin
						c1 <= c1 + 1;
					end
			2'b10	:  	begin
						c2 <= c2 + 1;
					end
			2'b11	:  	begin
						c3 <= c3 + 1;
					end
		endcase
	end
end

endmodule
