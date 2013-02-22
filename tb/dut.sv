/**
 * @filename		dut.sv 
 *
 * @brief     	        A simple testbench. 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 */



module parser_test();


	reg 				clk;
	reg				rst;
	reg[7:0]			data_i;

	reg[31:0]			tag_o;
	reg[255:0]			value_o;
	reg				end_of_body_o;
	reg				start_of_header_o;
	reg				t_wr_cs_o;		   
	reg				t_wr_en_o;		   
 	reg				v_wr_cs_o;		   
	reg				v_wr_en_o; 
	reg[31:0]			data;
	reg				empty;
	reg				full;

fix_parser_top dut(.clk, .rst, .data_i, .tag_o, .value_o, .end_of_body_o, .start_of_header_o, 
		   .t_wr_cs_o, .t_wr_en_o, .v_wr_cs_o, .v_wr_en_o, .data, .empty, .full);



initial begin


reg [1183:0] data ;
int temp;
int i = 0;

temp = 148;

data = 1184'h7c383d4649582e342e32207c20393d313738207c2033353d38207c2034393d50484c58207c2035363d50455253207c2035323d32303037313132332d30353a33303a30302e303030207c;

$vcdpluson;

clk = 0;

#1 clk = 0;
#1 clk = 1;

rst = '1;
data_i = 8'h01;

#1 clk = 0;
#1 clk = 1;

rst= '1;
data_i = 8'h33;



while (temp > 0) begin

	#1 clk = 0;
	#1 clk = 1;

	rst= '0;
	data_i = data [8*temp-1 -: 8];
	i = i++;
	temp--;

end


#1 clk = 0;
#1 clk = 1;

data_i = 8'h01;

#1 clk = 0;
#1 clk = 1;

data_i = 8'h33;

#1 clk = 0;
#1 clk = 1;

data_i = 8'h39;

#1 clk = 0;
#1 clk = 1;

data_i = 8'h3d;

#1 clk = 0;
#1 clk = 1;

data_i = 8'h43;

#1 clk = 0;
#1 clk = 1;

data_i = 8'h49;

#1 clk = 0;
#1 clk = 1;

data_i = 8'h43;

#1 clk = 0;
#1 clk = 1;

data_i = 8'h01;


end

endmodule
