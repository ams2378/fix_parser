/*
 ------------------------------------------------------------------------------
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
 - needtodefine: file: logon, heartbeat
 -	  	 states: connected, logonsent, waiting_for_connection, heartbeatsent	  
 -		 val: heartbeatvalue 
 -		 event: message_sent 
 -		  
 -		  
 -----------------------------------------------------------------------------
*/

`timescale 1 ns / 100 ps

module bench;

// decleare dut in/out ports
reg  		clk,
reg  		reset,
reg  		configure_i,
reg  		connect_i,
reg[2:0]	connect_to_addr_i,
//reg  		read_msg_num_i,
//reg		read_msg_tag_i,
reg		connected_i,
reg[2:0]	connected_host_addr_i,
reg		new_msg_received_i,
reg[7:0]	message_i,

reg		connect_req_o,
reg[2:0]  	connect_host_addr_o,
reg		send_message_valid_o,
reg[7:0]	message_o

// instantiate dut
dut dut (	  
   		.clk,
    		.reset,
    		.configure_i,
    		.connect_i,
		.connect_to_addr_i,

    		.connected_i,
  	 	.connected_host_addr_i,
   		.new_message_received_i,
  	  	.message_i,

  		.connect_req_o,
 	  	.connect_host_addr_o,
  		.send_message_valid_o,
  		.message_o
	);

// internal variables and events

reg[2:0] session_state [7:0];
reg[2:0] session_map_counter [15:0];
reg	 count_expired;
reg[2:0] count_expired_addr;

integer statusI,statusO, mon;
reg [7:0] exp;
integer in,out,cfg;
integer dut_error;

parameter	tcp_connected = 3'b001;;

event reset_enable;
event reset_done;
event exit_sim;
event configure_enable;
event configure_done;
event start_initiator;
event start_acceptor;
event error;
event initiation_trigger_sent;
event waiting_for_ack;
event connected;

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
	clk			=	'0;
    	reset			=	'0;
    	configure_i		=	'0;
    	connect_i		=	'0;
    	connected_i		=	'0;
  	connected_host_addr_i	=	'0;
   	new_message_i		=	'0;
  	message_i		=	'0;
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
	configure_i = 1;
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
	connect_i = 8'b00000001;
	@ (negedge clk)
	start = 0;
	-> waiting_for_ack;
	@connected;
	-> initiation_trigger_sent;
	$display ("ACK received @ %0dns", $time);
	@error;
	->exit_sim;
end

// send connection status
initial begin
	@(waiting_for_ack);
	#3 @(negedge clk);
	connected_i = '1;
	connected_host_add_i = 3'b001;
	->connected;
end

// exiting simulation
initial
	@ (exit_sim)  begin
	$display ("Terminating simulation @ %0dns ", $time);
 	if (dut_error == 0) begin
  		$display("Simulation Result : PASSED");
 	end else begin
     		$display("Simulation Result : FAILED");
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
		dut_error = (message_out != 8'h00) ? 1 : 0;
		if (dut_error)	-> error;		
	end else if (send_message_o == 1)begin
   		statusO = $fscanf(out,"%h\n",exp[7:0]);
		dut_error = (message_o != exp) ? 1 : 0;		
		if (dut_error)	-> error;
		else begin
 	   	$display("Match : input and output match @ %0dns  ",$time);
     		$display("       Got  %h",dout);
     		$display("       Exp  %h",exp);
		end		
   	end 

endmodule

function update_state; 
input [2:0]	connect_host_addr;
input [2:0]	newState;
begin
	case (connect_host_addr)
		3'b000:	session_state[0] = newState;		// need to declear session_state 
		3'b001:	session_state[1] = newState; 
		3'b010:	session_state[2] = newState; 
		3'b011:	session_state[3] = newState; 
		3'b100:	session_state[4] = newState; 
		3'b101:	session_state[5] = newState; 
		3'b110:	session_state[6] = newState; 
		3'b111:	session_state[7] = newState; 
	endcase
end
endfunction


// send_logon(connect_host_addr_o);
task send_logon;
begin
	update_state (connected_host_addr_o, logonsent);	
	while (!($feof(in))) begin
		@ (posedge clk)
		send_message_valid_o = 1;
		statusI = $fscanf(logon,"%h\n",dout[7:0]);
	end
	-> message_sent;
end
	$fclose(logon);
endtask

// send_heartbeat(connect_host_addr_o);
task send_heartbeat;
begin
	update_state (connected_host_addr_o, heartbeatsent);	
	while (!($feof(in))) begin
		@ (posedge clk)
		send_message_valid_o = 1;
		statusI = $fscanf(hearbeat,"%h\n",dout[7:0]);
	end
	-> message_sent;
end
	$fclose(logon);
endtask

initial forever begin		// only for first host
	@ message_sent;
	session_map_counter[0] = '0;
	while (session_map_counter[0] < hearbeatvalue) begin
	@ (posedge clk)
		session_map_counter[0] = session_map_counter[0] + 1;
	end
	count_expired = (session_map_counter[0] == heartbeatvalue) ? '1 : 0;
	count_expired_addr = '0;	
end



// golden model
always @ (posedge clk) begin

	if (rst == 1) begin
  		connect_req_o		= 	'0;
 	  	connect_host_addr_o	= 	'0;
  		send_message_valid_o	= 	'0;
  		message_o		= 	'0;
	end

	if (connect_i == 1) begin
		connect_req_o		=	'1;
		connect_host_addr_o	=	connect_to_addr_i;
		send_msg_valid_o	=	'0;
		update_state (connect_host_addr_o, waiting_for_connection);
	end 

	if (connected_i == 1) begin
		update_state (connect_host_addr_o, connected);
		send_logon(connect_host_addr_o);
		send_msg_valid_o	=	'0;
	end

	if (count_expired == 1) begin				// need to define it later
		send_heartbeat (count_expired_addr);
		send_msg_valid_o	=	'0;
	end
end


