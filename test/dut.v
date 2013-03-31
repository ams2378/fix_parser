`timescale 1 ns / 100 ps

module dut (
  input wire  clk,enable,
  input wire  reset,
  input wire  start,
  input wire  configure,
  input wire  [7:0] din,
  input wire  [1:0 ]connectType, 			
  input wire  [7:0] reconnectInt, 			
  input wire  [15:0] starttime, 			
  input wire  [15:0] endtime, 			
  input wire  [5:0] beginstring, 			
  input wire  [5:0] defaultApplVerId, 		
  input wire  [255:0] senderCompId, 		
  input wire  [255:0] targetCompId, 		
  input wire  [15:0] hostAddr, 				 
  input wire  [7:0] heartBeatInt, 		

  output reg [7:0] dout,
  output reg       valid
);

always @ (posedge clk)
  begin
    dout  <= din;
    valid  <= enable;
  end

endmodule
           
/*
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
*/ 
