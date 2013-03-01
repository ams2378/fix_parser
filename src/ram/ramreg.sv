/**
 * @filename		ramreg.sv 
 *
 * @brief     	        RAM memory array generated from FF2 
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	FF2.sv 	
 */


module ramreg #(parameter ADDR_WIDTH = 5, DATA_WIDTH = 256) (
	input clk,
	input rst,

	input read_i,	
	input [(1 << ADDR_WIDTH)-1:0] read_addr_i,

	input write_i,
	input [(1 << ADDR_WIDTH)-1:0] write_addr_i,
	input [DATA_WIDTH-1:0] write_data_i,

	output read_valid_o,
	output [DATA_WIDTH* (1<<ADDR_WIDTH)-1:0] read_out_o
	);


logic do_write;
logic read_valid;

parameter CAM_DEPTH = (1 << ADDR_WIDTH);

wire [CAM_DEPTH - 1:0] read_valids;

generate
	for (genvar iter = 0; iter < CAM_DEPTH ; iter++) begin
		FF2 #(.WIDTH(DATA_WIDTH)) array
			(.clk,
			 .rst,

			 .readEn_i (read_addr_i[iter] & read_i),

			 .writeEn_i (write_addr_i[iter] & write_i),
			 .writedat_i (write_data_i),

			 .read_valid_o (read_valids[iter]),
			 .read_o (read_out_o[ DATA_WIDTH *iter +: DATA_WIDTH])
			);
	end
endgenerate

always_comb begin
	if (read_valids == 0)
		read_valid = 0;
	else
		read_valid = 1;
end

assign read_valid_o = read_valid;

endmodule
