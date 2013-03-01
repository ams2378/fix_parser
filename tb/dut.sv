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
	reg				empty_o;
	reg				full_o;

	reg[31:0]			find_tag_i;
	reg[9 :0] 			message_num_i;
	reg				read_message_i;

	reg[255:0]			output_value_o;
	reg				output_value_valid_o;
/*
fix_parser_top dut(.clk, .rst, .data_i, .tag_o, .value_o, .end_of_body_o, .start_of_header_o, 
		   .t_wr_cs_o, .t_wr_en_o, .v_wr_cs_o, .v_wr_en_o,  .empty, .full);
*/

fix_parser_top dut(.clk, .rst, .data_i, .find_tag_i, .message_num_i, .read_message_i, .output_value_o, .output_value_valid_o , .start_of_header_o, .empty_o, .full_o);

initial begin


reg [1183:0] data ;
int temp;
int i = 0;

temp = 164;	//148;

/*
data = 1184'h7c383d4649582e342e32207c20393d313738207c2033353d38207c2034393d50484c58207c2035363d50455253207c2035323d32303037313132332d30353a33303a30302e303030207c;
*/

/* sample FIX:|8=FIX.4.2|9=178|35=8|49=PHLX|52=20071123-05:30:00.000|11=ATOMNOCCC9990900|10=128|   */

data = 656'h7c383d4649582e342e327c393d3137387c33353d387c34393d50484c587c35323d32303037313132332d30353a33303a30302e3030307c31313d41544f4d4e4f434343393939303930307c31303d3132387c; 

$vcdpluson;

clk = 0;
read_message_i = '0;
message_num_i = '0;
find_tag_i = '0;


#1 clk = 0;
#1 clk = 1;

rst = '1;

#1 clk = 0;
#1 clk = 1;

rst= '1;

#1 clk = 0;
#1 clk = 1;

rst= '0;

while (temp > 0) begin

	#1 clk = 0;
	#1 clk = 1;

	rst= '0;
	data_i = data [8*temp-1 -: 8];
	i = i++;
	temp--;

end

temp = 164;
i = 0;

#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;

#1 clk = 0;
#1 clk = 1;

message_num_i = '0;
read_message_i = '1;
find_tag_i = 16'h3130;

#1 clk = 0;
#1 clk = 1;


read_message_i = '0;

#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;

#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;


#1 clk = 0;
#1 clk = 1;

end

endmodule
