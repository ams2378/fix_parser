// MODULE               :                                    
// TOP MODULE           : --                                            
//                                                                       
// PURPOSE              :                     
//                                                                       
// AUTHOR               :                            
//                                                                       
// Revision History                                                      
//                                                                       

module bench;

// decleare dut in/out ports
reg enable;
reg clk;
reg reset;
reg configure;
reg start;
wire valid;
reg [7:0] din;
wire [7:0] dout;

/*
reg [1:0 ]connectType;			// 01- initiator, 10- acceptor
reg [7:0] reconnectInt;			// in second (exp: 60 second)
reg [15:0] starttime;			// in hh mn sc
reg [15:0] endtime;			// in hh mn sc
reg [5:0] beginstring;			// (example) 4.4 - 100 100
reg [5:0] defaultApplVerId;		// 4.3 - 100 011
reg [255:0] senderCompId;		// sent as ASCII (max - 256 bits)
reg [255:0] targetCompId;		// sent as ASCII (max - 256 bits)
reg [15:0] hostAddr;			// (example) - 16 bit	 
reg [7:0] heartBeatInt;			// (example) - 8 bit

*/
// instantiate dut
dut dut (clk,enable,reset, start, configure, din,dout,valid);

// internal variables and events
integer statusI,statusO, conf;
reg [7:0] exp;
integer in,out,mon;
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

//initial $vcdpluson;		// only for VCS simulator

// initialization
initial begin
  clk = 0;
  enable = 0;
  din = 0;
  exp = 0;
//  cfg = $fopen("cfg.txt","r");
  in  = $fopen("init_in.txt","r");
  out = $fopen("init_out.txt","r");
  mon = $fopen("monitor.txt","w");
end

// test flow 
// note: current flow only handles initiator- incorporating acceptor with it will be trivial.
initial begin
  #10 -> reset_enable;
  @ (reset_done);
  -> configure_enable;	
  @ (configure_done);
  #10 -> start_initiator;
  @ (error);
  -> exit_sim;
end

// exiting simulation
initial
@ (exit_sim)  begin
 $display ("Terminating simulation");
 if (dut_error == 0) begin
   $display ("Simulation Result : PASSED");
 end
 else begin
   $display ("Simulation Result : FAILED");
 end
 $display ("###################################################");
 #1 $finish;
end

// applying reset logic
initial
forever begin
 @ (reset_enable);
 @ (negedge clk)
 $display ("Applying reset");
   reset = 1;
 @ (negedge clk)
   reset = 0;
 $display ("Came out of Reset");
 -> reset_done;
end

// start configuration 
initial 
forever begin
	@ (configure_enable);
	@ (negedge clk)
	$display ("configuring DUT");
	configure = 1;
/*	$fgets(cfg, connectType);
	$fgets(cfg, reconnectInt);
	$fgets(cfg, starttime);
	$fgets(cfg, endtime);
	$fgets(cfg, beginstring);
	$fgets(cfg, defaultApplVerId);
	$fgets(cfg, senderCompId);
	$fgets(cfg, targetCompId);
	$fgets(cfg, hostAddr);
	$fgets(cfg, heartBeatInt);		*/
	@ (negedge clk)
	configure = 0;
	#2 -> configure_done;			// 2 cycles to do configuration
end  

// initiate initiator  
initial 
forever begin 
	@ (start_initiator);
	@ (negedge clk)
	$display ("Initiating a new connection");
	start = 1;
	@ (negedge clk)
	start = 0;
	-> initiation_trigger_sent;
end

initial
forever begin
	@(initiation_trigger_sent)
   while (!($feof(in))) begin
	@ (negedge clk)
	$display ("DUT receiving inputs from acceptor");
	enable = 1;
	statusI = $fscanf(in,"%h\n",din[7:0]);
	@ (negedge clk)
	enable = 0;
	if (din == 8'h3b) begin			// end of one FIX message
		#10;				// wait for heartbeat
	end
  end
end

// DUT output monitor and compare logic
always @ (posedge clk)
 if (reset == 1) 
	exp <= 0;
 else if (valid == 1) begin
   statusO = $fscanf(out,"%h\n",exp[7:0]);
   if (dout !== exp) begin
	dut_error = 1;
	-> error;
   end else begin
	dut_error = 0;
     $display("%0dns Match : input and output match",$time);
     $display("       Got  %h",dout);
     $display("       Exp  %h",exp);
   end
 end
endmodule
