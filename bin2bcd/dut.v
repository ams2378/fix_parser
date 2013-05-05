/**
 * @filename		dut.sv 
 *
 * @brief     	        A simple testbench. 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 */

module test();

	
	reg	 	clk_i;
	reg	 	ce_i;
	reg	 	rst_i;
	reg		start_i;
	reg[31:0]	dat_binary_i;
	reg[39:0]	dat_bcd_o;
	reg		done_o;
	reg[79:0]	ascii_o;
	reg[9:0]	size_o;
	reg[3:0]	width_o;


binary_to_bcd bin2bcd (.clk_i, .ce_i, .rst_i, .start_i, .dat_binary_i, .dat_bcd_o, .done_o, .ascii_o, .size_o, .width_o);


initial begin

int veriable;
int stop;

$vcdpluson;

#1 clk_i = 0;
#1 clk_i = 1;
start_i = 0;
//dat_binary_i = 16'b0000000000001111;
rst_i = 1;
ce_i = 1;
#1 clk_i = 0;
#1 clk_i = 1;

rst_i = 0;
#1 clk_i = 0;
#1 clk_i = 1;

#1 clk_i = 0;
#1 clk_i = 1;

ce_i = 1;
rst_i = 0;
//dat_binary_i = 16'b1111111111111111;
//dat_binary_i = 16'b0000000000010000;

dat_binary_i = {31'b0, 1'b1};

start_i = 1;


#1 clk_i = 0;
#1 clk_i = 1;

start_i = 0;

#1 clk_i = 0;
#1 clk_i = 1;


#1 clk_i = 0;
#1 clk_i = 1;

//rst_i = 1;
 veriable = 0;
 stop = 1000;

while (veriable <stop) begin

#1 clk_i = 0;
#1 clk_i = 1;

veriable = veriable+1;
end

end

endmodule
