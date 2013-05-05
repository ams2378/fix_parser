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

//`timescale 1 ns / 100 ps

module bench;

parameter			NUM_HOST  = 2;

// decleare dut in/out ports
reg				clk;
reg				rst;
reg				connect_i;			// from app
reg[NUM_HOST-1:0]		connect_to_host_i;		// from app

reg				connected_i;			// from toe
reg[NUM_HOST-1:0]		connected_host_addr_i;		// from toe
reg[NUM_HOST-1:0]		id_i;				// from toe
reg[7:0]			message_i;			// from toe
reg				fifo_full_i;
reg				new_message_i;			// will be implemented by fifo contr.
reg				fifo_write_o;
reg[7:0]			message_o;			// goes to fifo
reg				end_o;


// instantiate dut
fix_engine dut (	  
 		.clk,
 		.rst,
 		.connect_i,			// from app
 		.connect_to_host_i,		// from app

		.connected_i,			// from toe
 		.connected_host_addr_i,		// from toe
 		.id_i,				// from toe
 		.message_i,			// from toe
 		.fifo_full_i,
 		.new_message_i,			// will be implemented by fifo contr.
 		.fifo_write_o,
 		.message_o,			// goes to fifo
		.end_o
	);

// internal variables and events
reg[2:0] session_state [7:0];
reg[2:0] session_map_counter [15:0];
reg	 count_expired;
reg[2:0] count_expired_addr;
reg	 t_fifo_write_o;
reg	 chk_connect;
reg	 t_end_o;
reg	 t1_end_o;
reg	 t2_end_o;
reg	 t3_end_o;

integer chksm_tag_done;
integer	not_done;
integer	temp;
integer statusI,statusO, mon;
reg	  start_checking;
reg [7:0] exp;
reg [7:0] exp_g;		// garbage
integer in,out,cfg;
integer dut_error;
integer		temp_count;
integer		count_bytes;

event message_sent;
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
event comparison_done;
event handle_checksum;
event handle_time;
event handle_bodylength;
event input_stimuli_sent;
event send_message;

// clock generator
always # 1 clk = ~clk;

// dumping waveforms
initial 
begin
  	$dumpfile ("dut.vcd");
  	$dumpvars;
end

//enable if compiling with VCS
//initial 

initial begin

$vcdpluson;		 

end

// initialization
initial begin
	$display ("\n");
	$display ("################################################### \n");
  	$display ("STARTING SIMULATION\n");
	temp			=	0;
	clk			=	'0;
    	rst			=	'0;
    	connect_i		=	'0;
	connect_to_host_i	=	'0;
    	connected_i		=	'0;
  	connected_host_addr_i	=	'0;
	id_i			=	'0;
	fifo_full_i		=	'0;
   	new_message_i		=	'0;
  	message_i		=	'0;
	temp_count		=	0;
	count_bytes		=	0;
	not_done		=	1;
	chk_connect		=	'0;
	chksm_tag_done		=	10;
  	in  = $fopen("init_out.txt","r");
 // 	out = $fopen("init_out.txt","r");
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
  	#10 -> start_initiator;
end

// applying reset logic
initial
forever begin
 	@ (reset_enable);
 	@ (negedge clk)
 	$display ("Applying reset @ %0dns", $time);
   	rst = 1;
 	@ (negedge clk)
   	rst = 0;
 	$display ("Came out of Reset @ %0dns", $time);
 	-> reset_done;
end

// initiate initiator  
initial 
forever begin 
	@ (start_initiator);
	@ (negedge clk)
	$display ("Initiating a new connection @ %0dns", $time);
	connect_i = '1;
	connect_to_host_i  =  2'b01; 
	@ (negedge clk)
	connect_i = '0;
	-> waiting_for_ack;
	@connected;
	#7 connected_i = '0;
	-> input_stimuli_sent;
	$display ("ACK received @ %0dns", $time);
	@error;
	->exit_sim;
end

// send connection status
initial begin
	@(waiting_for_ack);
	#3 @(negedge clk)
	connected_i = '1;
	connected_host_addr_i = 2'b01;
//	@ (negedge clk)
//	connected_i = '0;
	->connected;
end

// exiting simulation
initial
	@ (exit_sim)  begin
	$display ("Terminating simulation @ %0dns ", $time);
     		$display("       Got  %h",message_o);
     		$display("       Exp  %h",exp);
 	$display ("################################################### \n");
 	#10 $finish;
end

// golden model
always @(*) begin

	chk_connect	=	connect_i;

	if (connect_i == 1) begin
		exp		= {3'b000, 1'b0, connect_to_host_i, 3'b000};	
	end
	
	t_fifo_write_o	=	fifo_write_o;
	
end


always @ (posedge clk) begin 

	if (fifo_write_o == 1 && connect_i == 0 ) begin
		start_checking =  '1;
	end else
		start_checking = '0;
end


always @ (negedge clk) begin
	t_end_o  <= #5 end_o;

	if (t_end_o == '1)
		chksm_tag_done = 1;

end

always @ (negedge clk) begin
#4	t1_end_o  <= t_end_o;
end


// handle bodylength
always @ (posedge clk) begin

	@handle_bodylength;

	while (t_fifo_write_o == 1 && message_o != 8'h01) begin
		statusO = $fscanf(in, "%h ",exp_g[7:0]);
		exp	= 8'hxx;
	end
end

// handle time
always @ (posedge clk) begin

	@handle_time;
	count_bytes	=	count_bytes + 1;
	if (message_o != 8'h01) begin
		statusO = $fscanf(in, "%h ",exp_g[7:0]);
		exp	= 8'hxx;
		-> handle_time;
	end else
		-> send_message;
end


// handle checksum 
always @ (posedge clk) begin

	@handle_checksum;
	count_bytes	=	count_bytes + 1;
	if (message_o != 8'h01) begin
		statusO = $fscanf(in, "%h ",exp_g[7:0]);
		exp	= 8'h3b;
		-> handle_checksum;
	end else
		-> message_sent;
end

always @ (posedge clk) begin

if (fifo_write_o == 1) begin
	if (connect_i == 1) begin
		start_checking = '1;
	end else begin
		if (temp_count <3) begin
			temp_count	=	temp_count + 1;
			start_checking = '0;
		end else begin
			if (count_bytes >= 12 && count_bytes < 15 && message_o != 8'h01) begin		// end_o : end_i at checksum calc 
				count_bytes = count_bytes + 1;
				statusO = $fscanf(in, "%h ",exp_g[7:0]);
				exp	= 8'h3b;
			end else if (count_bytes >= 39 && count_bytes < 61 && end_o != 1 && message_o != 8'h01) begin
				count_bytes = count_bytes + 1;
				statusO = $fscanf(in, "%h ",exp_g[7:0]);
				exp	= 8'h3b;
			end else if ( chksm_tag_done > 0 && chksm_tag_done <4  ) begin
				chksm_tag_done = chksm_tag_done + 1;
				statusO = $fscanf(in, "%h ",exp_g[7:0]);
				exp	= 8'h3b; 
			end else if (chksm_tag_done == 4) begin
				-> message_sent;	
			end else begin
				count_bytes 	= 	count_bytes + 1;		// initialize at 5 
				statusO = $fscanf(in, "%h ",exp[7:0]);
			end
		end
	end
end
end

// jump here for comparison_done
initial
forever begin
	@ message_sent;
	#10 @ (negedge clk) 

	repeat (2) @ (negedge clk) begin
		statusO = $fscanf(in, "%h ",exp_g[7:0]);
	end	
	
	@ (negedge clk)
	new_message_i = '1;
	id_i	=	2'b01;
	while (!$feof(in)) begin
      		@ (negedge clk);
		new_message_i = '0;
      		statusI = $fscanf(in,"%h ", message_i[7:0]);
		if (message_i == 8'h3b) begin
			repeat (400) @ (negedge clk);
		end
			new_message_i = '1;
	end
end

always @ (posedge clk) begin
	if (start_checking) begin
		if (message_o == exp || exp == 8'h3b) begin
			$display("%0dns passed : input and output  matched",$time);
			$display("       Got  %h",message_o);
			$display("       Exp  %h",exp);
		end else begin
			dut_error	=	1;
			-> error;
		end
	end
end


endmodule
