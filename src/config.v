/**
 * @filename		configure.v 
 *
 * @brief     	        set config parameters required for connection  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	n/a	
 */


module configure (
	input		clk,
	input		configure_i,
	input [1:0]	connectType_i,			
	input [7:0] 	reconnectInt_i,			
	input [15:0] 	starttime_i,			
	input [15:0] 	endtime_i,			
	input [5:0] 	beginstring_i,			
	input [5:0] 	defaultApplVerId_i,		
	input [255:0] 	senderCompId_i,		
	input [255:0] 	targetCompId_i,		
	input [15:0] 	hostAddr_i,			 
	input [7:0] 	heartBeatInt_i,

	output [1:0]	connectType_o,			
	output [7:0] 	reconnectInt_o,			
	output [15:0] 	starttime_o,			
	output [15:0] 	endtime_o,			
	output [5:0] 	beginstring_o,			
	output [5:0] 	defaultApplVerId_o,		
	output [255:0] 	senderCompId_o,		
	output [255:0] 	targetCompId_o,		
	output [15:0] 	hostAddr_o,			 
	output [7:0] 	heartBeatInt_o
	);

reg [1:0]	connectType_o,			
reg [7:0] 	reconnectInt_o,			
reg [15:0] 	starttime_o,			
reg [15:0] 	endtime_o,			
reg [5:0] 	beginstring_o,			
reg [5:0] 	defaultApplVerId_o,		
reg [255:0] 	senderCompId_o,		
reg [255:0] 	targetCompId_o,		
reg [15:0] 	hostAddr_o,			 
reg [7:0] 	heartBeatInt_o


always @ (posedge clk)
		connectType_o 		<= 	'0;
		reconnectInt_o 		<= 	'0;
  		starttime_o		<=	'0;		
 		endtime_o		<= 	'0;		
 		beginstring_o		<= 	'0;	
 		defaultApplVerId_o	<=	'0;	
 		senderCompId_o		<=	'0;
 		targetCompId_o		<=	'0;	
 		hostAddr_o		<=	'0;	 
 		heartBeatInt_o		<=	'0;
	if (configure_i == 1) begin
		connectType_o 		<= 	connectType_i;
		reconnectInt_o 		<= 	reconnectInt_i;
  		starttime_o		<=	starttime_i;		
 		endtime_o		<= 	endtime_i;		
 		beginstring_o		<= 	beginstring_i;	
 		defaultApplVerId_o	<=	defaultApplVerId_i;	
 		senderCompId_o		<=	senderCompId_i;
 		targetCompId_o		<=	targetCompId_i;	
 		hostAddr_o		<=	hostAddr_i;	 
 		heartBeatInt_o		<=	heartBeatInt_i;
	end	

endmodule



