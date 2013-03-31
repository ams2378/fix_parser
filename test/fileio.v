module fileio;

integer in,out,mon;
reg clk;

reg  enable;
wire valid;
reg [7:0] din;
reg [7:0] exp;
wire [7:0] dout;
integer statusI,statusO;

dut dut (clk,enable,din,dout,valid);

initial $vcdpluson;

initial begin
  clk = 0;
  enable  = 0;
  din = 0;
  exp = 0;
  in  = $fopen("inmsg.txt","r");
  out = $fopen("outmsg.txt","r");
  mon = $fopen("monitor.txt","w");
end

always # 1 clk = ~clk;

// DUT input driver code
initial begin
    repeat (10) @ (posedge clk);
    while (!$feof(in)) begin
      @ (negedge clk);
      enable = 1;
      statusI = $fscanf(in,"%h\n",din[7:0]);
      @ (negedge clk);
      enable = 0;
	if (din == 8'h3b) begin
		repeat(100) @ (posedge clk);
	end
    end
    repeat (10) @ (posedge clk);
    $fclose(in);
    $fclose(out);
    $fclose(mon);
    #100 $finish;
end

// DUT output monitor and compare logic
always @ (posedge clk)
 if (valid) begin
   $fwrite(mon,"%h\n",dout[7:0]);
   statusO = $fscanf(out,"%h\n",exp[7:0]);

     $display("       Got  %h",dout);
     $display("       Exp  %h",exp);
 end

endmodule


