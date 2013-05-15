/**
 * @filename		dut.sv 
 *
 * @brief     	        A simple testbench. 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 */

module fix_engine_test();

	reg				clk;
	reg				rst;
	reg				connect_i;			// from app
	reg[1:0]			connect_to_host_i;		// from app

	reg				connected_i_i;			// from toe
	reg[1:0]			connected_host_addr_i_i;		// from toe
	reg[1:0]			id_i_i;				// from toe
	reg[7:0]			message_i_i;			// from toe
	reg				fifo_full_i_i;
	reg				new_message_i_i;			// will be implemented by fifo contr.

	reg				fifo_write_i_o;
	reg[7:0]			message_i_o;			// goes to fifo

	reg				clk;
	reg				rst;

	reg				connected_a_i;			// from toe
	reg[1:0]			connected_host_addr_a_i;		// from toe
	reg[1:0]			id_a_i;				// from toe
	reg[7:0]			message_a_i;			// from toe
	reg				fifo_full_a_i;
	reg				new_message_a_i;			// will be implemented by fifo contr.


	reg				fifo_write_a_o;
	reg[7:0]			message_a_o;			// goes to fifo


//fix_engine dut (

end_to_end_system dut(
	 	.clk,
	 	.rst,
		.id_i_i,
		.id_a_i,
	 	.connect_i,			// from app
	 	.connect_to_host_i,		// from app
	 	.connected_i_i,			// from toe
	 	.connected_host_addr_i_i,		// from toe
	 	.message_i_i,			// from toe
		.fifo_full_i_i,
		.new_message_i_i,			// will be implemented by fifo contr.

		.fifo_write_i_o,
		.message_i_o,

	 	.clk,
	 	.rst,

	 	.connected_a_i,			// from toe
	 	.connected_host_addr_a_i,		// from toe
	 	.message_a_i,			// from toe
		.fifo_full_a_i,
		.new_message_a_i,			// will be implemented by fifo contr.

		.fifo_write_a_o,
		.message_a_o

	);

integer	in, in2, status, mon;
reg[7:0]	temp_in;

always 
	#1	clk = ~clk;

/*
always @ (*) begin

	if ( message_i_o == 8'h38) begin
		   new_message_a_i  =  '1;
		#1 new_message_a_i  =  '0;
	end

	#10	message_a_i 	=	message_i_o;
end
*/

initial begin
  	in = $fopen("inputs.txt","r");
  	in2 = $fopen("inputs2.txt","r");
	mon = $fopen("monitor.txt", "w");
end


always @ (posedge clk) begin
	if ( fifo_write_i_o)
		$fwrite(mon,"%h ",message_i_o);
end


initial begin

clk = 0;
rst = 0;
clk = 0;
rst = 0;
fifo_full_i_i = '0;

$vcdpluson;

#1 rst = 1;
#2 rst = 0;


#1 rst = 1;
#2 rst = 0;

#2
connect_i		=	'1;
connect_to_host_i	=	2'b01;
id_i_i			=	2'b01;

#3 connect_i	=	'0;


#5
connected_i_i =	 '1;
connected_host_addr_i_i	=	2'b01;
connected_a_i =	 '1;
connected_host_addr_a_i	=	2'b00;

#4
connected_i_i	=	'0;
connected_a_i 	=	'0;

#2

#500 

new_message_a_i	=	'1;
//connected_host_addr_a_i	=	2'b00;
id_a_i	=	2'b00;

while (!($feof(in2))) begin
	@ (posedge clk)
	new_message_a_i	=	'0;
	status = $fscanf(in2,"%h",temp_in[7:0]);
	if (temp_in != 8'h3b)
		message_a_i  =  temp_in;
	else begin
		repeat (500) @ (posedge clk);
		new_message_a_i	=	'0;
	end
end

#500 $finish;

end

endmodule
