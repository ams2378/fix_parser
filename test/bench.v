/*
 ----------------------------------------------------------------------------- -
 -
 - FILE        : bench.v 
 - Design      : FIX Engine
 - Description : Automated testbench for design
 - Author      : Adil Sadik <sadik.adil@gmail.com, ams2378@columbia.edu> 
 -
 -----------------------------------------------------------------------------
 -
 - Created     : 03/26/2013
 - Revision    : 03/30/2013 
 -		 Included Verilog-event feature for better control 
 -		 over execution flow   
 -
 -		
 -
 -----------------------------------------------------------------------------
 -
 -  Dependency  : dut.v, init_in.txt, init_out.txt
 -  Output Log  : monitor.txt
 -   
 -  Status	: Only deals with Initiator side. 
 -		  Good (compiling and dumping waveforms in desired format)
 -  TODO	: Need to add acceptor side (should be very trivial)	  
 -   		  Need real DUT for verification (in progress)
 -   
 -  Instruction : For simulation, run "sh runsim.sh" from command line
 -		  Sim log saved in "transcript"		
 -		  Run "nuke.sh" to clean the dir
 -		  
 -
 -----------------------------------------------------------------------------
*/

`timescale 1 ns / 100 ps

module bench;

// decleare dut in/out ports
reg enable;
reg clk;
reg reset;
reg configure;
reg start;
reg [7:0] din;

reg [1:0 ]connectType;			
reg [7:0] reconnectInt;			
reg [15:0] starttime;			
reg [15:0] endtime;			
reg [5:0] beginstring;			
reg [5:0] defaultApplVerId;		
reg [255:0] senderCompId;		
reg [255:0] targetCompId;		
reg [15:0] hostAddr;				 
reg [7:0] heartBeatInt;			

wire [7:0] dout;
wire valid;

// instantiate dut
dut dut (clk,enable,reset, start, configure,din, connectType, reconnectInt, starttime, endtime, beginstring, defaultApplVerId,
	 senderCompId, targetCompId, hostAddr, heartBeatInt, dout,valid);

// internal variables and events
integer statusI,statusO, mon;
reg [7:0] exp;
integer in,out,cfg;
integer dut_error;

event reset_enable;
event reset_done;
event exit_sim;
event configure_enable;
event configure_done;
event start_initiator;
event start_acceptor;
event error;
event initiation_trigger_sent;

// clock generator
always # 1 clk = ~clk;

// dumping waveforms
initial 
begin
  	$dumpfile ("dut.vcd");
  	$dumpvars;
end

//enable if compiling with VCS
initial $vcdpluson;		 

// initialization
initial begin
	$display ("\n");
	$display ("################################################### \n");
  	$display ("STARTING SIMULATION\n");
  	clk = 0;
  	enable = 0;
  	din = 0;
  	exp = 0;
	cfg = $fopen("clientconfig.txt","r");
  	in  = $fopen("init_in.txt","r");
  	out = $fopen("init_out.txt","r");
  	mon = $fopen("monitor.txt","w");
end

// test flow:  
// start with a reset (after warmup cycle)
// configure DUT 
// upon configuration, tell DUT to initiate a fix session by sending logon
// exit in case of any error
// log information regarding error
initial begin
  	#10 -> reset_enable;
  	@ (reset_done);
  	-> configure_enable;	
  	@ (configure_done);
  	#10 -> start_initiator;
  	@ (error);
  	-> exit_sim;
end

// applying reset logic
initial
forever begin
 	@ (reset_enable);
 	@ (negedge clk)
 	$display ("Applying reset @ %0dns", $time);
   	reset = 1;
 	@ (negedge clk)
   	reset = 0;
 	$display ("Came out of Reset @ %0dns", $time);
 	-> reset_done;
end

// start configuration 
initial 
forever begin
	@ (configure_enable);
	@ (negedge clk)
	$display ("configuring DUT @ %0dns", $time);
	configure = 1;
	 statusI = $fscanf(cfg, "%b\n" ,connectType);
	 statusI = $fscanf(cfg, "%b\n" ,reconnectInt);
	 statusI = $fscanf(cfg, "%b\n" ,starttime);
	 statusI = $fscanf(cfg, "%b\n" ,endtime);
	 statusI = $fscanf(cfg, "%b\n" ,beginstring);
	 statusI = $fscanf(cfg, "%b\n" ,defaultApplVerId);
	 statusI = $fscanf(cfg, "%b\n" ,senderCompId);
	 statusI = $fscanf(cfg, "%b\n" ,targetCompId);
	 statusI = $fscanf(cfg, "%b\n" ,hostAddr);
	 statusI = $fscanf(cfg, "%b\n" ,heartBeatInt);		
	@ (negedge clk)
	configure = 0;
	#2 -> configure_done;			// 2 cycles to do configuration
end  

// initiate initiator  
initial 
forever begin 
	@ (start_initiator);
	@ (negedge clk)
	$display ("Initiating a new connection @ %0dns", $time);
	start = 1;
	@ (negedge clk)
	start = 0;
	-> initiation_trigger_sent;
end

// exiting simulation
initial
	@ (exit_sim)  begin
	$display ("Terminating simulation @ %0dns ", $time);
 	if (dut_error == 0) begin
  		$display ("Simulation Result : PASSED");
 	end else begin
     		$display ("Simulation Result : FAILED");
     		$display("       Got  %h",dout);
     		$display("       Exp  %h",exp);
 	end
 	$display ("################################################### \n");
 	#1 $finish;
end


// initiator execution starts here; driving DUT input ports
initial
forever begin
	@(initiation_trigger_sent)
   while (!($feof(in))) begin
	@ (negedge clk)
	$display ("DUT receiving inputs from acceptor @ %0dns", $time);
	enable = 1;
	statusI = $fscanf(in,"%h\n",din[7:0]);
	@ (negedge clk)
	enable = 0;
	if (din == 8'h3b) begin			// end of one FIX message
		#10;				// wait few cycles before sending new inputs
	end
  end
	$fclose(in);
	$fclose(out);
	#10 -> exit_sim; 
end

// DUT output monitor and compare logic
always @ (posedge clk)
	if (reset == 1) begin
		dut_error = (dout != 8'h00) ? 1 : 0;
		if (dut_error)	-> error;		
	end else if (valid == 1) begin
   		statusO = $fscanf(out,"%h\n",exp[7:0]);
		dut_error = (dout != exp) ? 1 : 0;		
		if (dut_error)	-> error;
		else begin
 	   	$display("Match : input and output match @ %0dns  ",$time);
     		$display("       Got  %h",dout);
     		$display("       Exp  %h",exp);
		end		
   	end 

endmodule

