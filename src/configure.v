/**
 * @filename		configure.v 
 *
 * @brief     	        set config parameters required for connection  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	n/a	
 */


module configure # (parameter VALUE_WIDTH = 256, WIDTH_SIZE = 5)(
		// inputs
		input				clk,
		input				configure_i,
		input [1:0]			connectType_i,			
		input [7:0] 			reconnectInt_i,			
		input [15:0] 			starttime_i,			
		input [15:0] 			endtime_i,			
		input [5:0] 			beginstring_i,			
		input [5:0] 			defaultApplVerId_i,		
		input [255:0] 			senderCompId_i,		
		input [255:0] 			targetCompId_i,		
		input [15:0] 			hostAddr_i,			 
		input [7:0] 			heartBeatInt_i,
		input [WIDTH_SIZE-1:0]		sizeSenderId_i,
		input [WIDTH_SIZE-1:0]		sizeTargetId_i,

		// outputs
		output reg [1:0]		connectType_o,			
		output reg [7:0] 		reconnectInt_o,			
		output reg [15:0] 		starttime_o,			
		output reg [15:0] 		endtime_o,			
		output reg [5:0] 		beginstring_o,			
		output reg [5:0] 		defaultApplVerId_o,		
		output reg [VALUE_WIDTH-1:0] 	senderCompId_o,			
		output reg [VALUE_WIDTH-1:0] 	targetCompId_o,		
		output reg [15:0] 		hostAddr_o,			 
		output reg [7:0] 		heartBeatInt_o,
		output reg [WIDTH_SIZE-1:0]	sizeSenderId_i,
		output reg [WIDTH_SIZE-1:0]	sizeTargetId_i,
	);

always @ (posedge clk) begin
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
		sizeSenderId_o		<=	'0;
		sizeTargetId_o		<=	'0;
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
		sizeSenderId_o		<=	sizeSenderId_i;
		sizeTargetId_o		<=	sizeTargetId_i;
	end
end	

endmodule
