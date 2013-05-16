/**
 * @filename		dut.sv 
 *
 * @brief     	        A simple testbench. 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 */

module fix_engine_test();

	// clock port
	reg		clk;
	reg		reset;
	
	// slave port
	reg[7:0]	slave_address;
	reg		slave_read;
	reg[7:0]	slave_readdata;
	reg		slave_write;
	reg[7:0]	slave_writedata;

	parameter		CONN	=	3'b110;
	parameter		RSTAT	=	3'b000;
	parameter		RDATA	=	3'b001;

//fix_engine dut (

sys_console dut(
	 	clk,
	 	reset,

 		slave_address,
 		slave_read,
 		slave_readdata,
 		slave_write,
 		slave_writedata
	);

integer	in, in2, status, mon;
reg[7:0]	temp_in;

always 
	#1	clk = ~clk;

initial begin
	clk	=	'0;
end


initial begin

$vcdpluson;

slave_address	=	'0;
slave_read	=	'0;
slave_write	=	'0;
slave_writedata	=	'0;

#19 reset = 1;
#2 reset = 0;


slave_address	=	CONN;
slave_write	=	'1;
slave_writedata	=	8'hbb;	

#1

slave_write	=	'0;

#11

slave_address	=	CONN;
slave_write	=	'1;
slave_writedata	=	8'hcc;	

#1

slave_write	=	'0;

#301

slave_address	=	RSTAT;
slave_read	=	'1;

#1

slave_read	=	'0;


if (slave_readdata == 8'h01) begin
repeat (198) begin
@ (posedge clk);
	slave_read	=	'1;
	slave_address	=	RDATA;
@(posedge clk);
	slave_read	=	'0;
end
end
#1 
	slave_read	=	'0;

#1 

slave_address	=	CONN;
slave_write	=	'1;
slave_writedata	=	8'hdd;	

#1 
slave_write	=	'0;

#10000 $finish;

end

endmodule
