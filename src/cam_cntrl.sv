
module cam_cntrl #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 5) (
	input				clk      , 		// Clock input
	input				rst      , 		// Active high reset

	input				wr_cs_i    , 		// Write chip select
	input[DATA_WIDTH-1:0]		data_i  , 		// Data input
	input				wr_en_i ,    		// Write Enable
	input				start_message_i,
	input				end_message_i,
	
	output[ADDR_WIDTH-1:0] 		start_addr_o,
	output[ADDR_WIDTH-1:0] 		end_addr_o,
	output				store_start_o,
	output				store_end_o,
	output				full_o

);    
 
parameter CAM_DEPTH = (1 << ADDR_WIDTH);

logic [ADDR_WIDTH-1:0] 			wr_pointer;
logic [ADDR_WIDTH-1:0] 			start_address;
logic [ADDR_WIDTH-1:0] 			end_address;
logic					store_start;
logic					store_end;
logic					full;

/* write pointer */

always_ff @ (posedge clk or posedge rst ) begin
  if (rst) begin
    wr_pointer <= 0;
    start_address = 0;
    end_address = 0;
    store_start = 0;
    store_end = 0;
    full = 0;
  end else if (wr_cs_i && wr_en_i ) begin
    wr_pointer <= wr_pointer + 1;
  end
end


always_ff @ (posedge clk or start_message_i or end_message_i) begin

  if (start_message_i) begin 
	start_address = wr_pointer;
	store_start = '1;
  end else if (end_message_i) begin
	end_address = wr_pointer;
	store_end = '1;
  end

  if (wr_pointer == CAM_DEPTH-1)
		full = '1;
end



assign start_address_o 	= 	start_address;
assign end_address_o 	= 	end_address;
assign store_start_o 	= 	store_start;
assign store_end_o 	= 	store_end;
assign full_o		=	full;


cam #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) cam_tag (
		.clk,
		.rst,

		.start_i(0),
		.end_i(5'b11111),

		.write_i(wr_en_i),
		.write_index_i(wr_pointer),
		.write_data_i(data_i),

		.search_i(0),
		.search_data_i('0)

//		.search_valid_o()
//		.search_index_o
		);



endmodule

