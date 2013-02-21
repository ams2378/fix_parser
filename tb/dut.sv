/**
 * @filename		dut.sv 
 *
 * @brief     	        A simple testbench. 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 */



module parser_test();


	reg 				clk,
	reg				rst;
	reg				ctrl;

	reg[7:0]			data_i;
	
	reg[7:0]			data_o;
	reg				tag_s_o;
	reg   				tag_e_o;
	reg				value_s_o;
	reg				value_e_o;

bit error;

fix_parser dut(.clk, .rst, .ctrl, .data_i, .data_o, .tag_s_o, .tag_e_o, .value_s_o, value_e_o);

initial begin

$vcdpluson;

clk = 0;
rst = 0;

#1 clk = 1;
#1 clk = 0;

data_i = 8'h01;

#1 clk = 1;
#1 clk = 0;

data_i = 8'h33;

#1 clk = 1;
#1 clk = 0;

data_i = 8'h39;

#1 clk = 1;
#1 clk = 0;

data_i = 8'h3d;

#1 clk = 1;
#1 clk = 0;

data_i = 8'h43;

#1 clk = 1;
#1 clk = 0;

data_i = 8'h49;

#1 clk = 1;
#1 clk = 0;

data_i = 8'h43;

#1 clk = 1;
#1 clk = 0;

data_i = 8'h01;


end

endmodule
