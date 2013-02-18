/**
 * @filename		dut.sv 
 *
 * @brief     	        A simple testbench. 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 */



module parser_test();

reg 		clk;
reg 		rst;
reg[31:0] 	data_i;
reg[31:0] 	tag_o;
reg[31:0] 	value_o;
reg[3:0] 	tag_valid_o;
reg[3:0] 	value_valid_o;

bit error;

fix_parser_top dut(.clk, .rst, .data_i, .out_o, .tag_valid_o, .value_valid_o);

initial begin

$vcdpluson;

clk = 0;
rst = 0;

#1 clk = 1;
#1 clk = 0;

data_i = 31'h0132323d;

#1 clk = 1;
#1 clk = 0;

data_i = 31'h33330132;

#1 clk = 1;
#1 clk = 0;

data_i = 31'h39323336;

#1 clk = 1;
#1 clk = 0;


#1 clk = 1;
#1 clk = 0;

end


endmodule
