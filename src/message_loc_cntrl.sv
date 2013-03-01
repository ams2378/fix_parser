

module message_loc_cntrl # (parameter NUM_MESSAGE =10, DATA_WIDTH = 5 ) (

	input 				clk,
	input				rst,

	input				end_message_i,
	input				start_message_i,
	input [DATA_WIDTH-1 :0]		start_addr_i,
	input [DATA_WIDTH-1 :0]		end_addr_i,
	input				full_i,

	input				re_i,
	input				read_start_i,
	input				read_end_i,

	output [DATA_WIDTH-1:0]		start_o,
	output [DATA_WIDTH-1:0]		end_o,



	output [NUM_MESSAGE-1 :0]	address_o,
	output [DATA_WIDTH-1:0]		start_addr_o,
	output [DATA_WIDTH-1:0]		end_addr_o,
	output				store_start_o,
	output				store_end_o
);


parameter 			state0 = 2'b00;
parameter			state1 = 2'b01;
parameter			state2 = 2'b10;

logic [NUM_MESSAGE-1 :0]	address;
logic [DATA_WIDTH-1:0]		start_addr;
logic [DATA_WIDTH-1:0]		end_addr;
logic				store_start;
logic				store_end;

logic [1:0]			state;
logic [1:0]			next_state;

logic [NUM_MESSAGE-1 : 0]	count;

always_ff @(posedge clk) begin

	if (rst)		state <= state0;
	else			state <= next_state;
end


always_ff @(state or end_message_i or start_message_i) begin

	if (rst) begin
		address	 	= 	'0;
		start_addr 	= 	'0;	
		end_addr 	= 	'0;
		store_start 	= 	'0;
		store_end 	= 	'0;
		count 		= 	'0;
	end

	case(state) 
		
		state0: begin 
				if ( start_message_i == 0) begin
					next_state = state0;
				end else begin
					store_start = '1;
					address = count;
					start_addr = start_addr_i;
					next_state = state1;
				end
		end
		state1: begin
				if (end_message_i == 0) begin
					store_start = '0;
					next_state = state1;
				end else begin 
					store_end = '1;
					address = count;
					end_addr = end_addr_i;
					next_state = state2;
				end
		end
		state2: begin	
				store_end = '0;
				count = count + 1;
				next_state = state0;	
		end
	endcase
end

assign	address_o	= 	address;
assign  start_addr_o	=	start_addr;
assign 	end_addr_o	=	end_addr;
assign 	store_start_o	=	store_start;
assign 	store_end_o	=	store_end;



message_loc #(.DATA_WIDTH(5), .NUM_MESSAGE(10)) message_mem (

		.clk,
		.rst,

		.start_i(store_start_o),
		.end_i(store_end_o),
		.store_start_i(store_start_o),
		.store_end_i(store_end_o),
		.addr_i(address_o),
		.re_i,
		.read_start_i,
		.read_end_i,

		.start_o,
		.end_o

);  


endmodule
