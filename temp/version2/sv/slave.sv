module slave (
	// these connect to the clock port
	clk,
	reset,

	// these connect to the slave port
	slave_address,
	slave_read,
	slave_readdata,
	slave_write,
	slave_writedata,
//	slave_byteenable,	
	
	// these connect 
	ready_to_read,
	fix_message_sent,
	read_request,
	final_index,
	data_out_2,
	session_initiate
);

	parameter		CONN	=	3'b110;
	parameter		RSTAT	=	3'b000;
	parameter		RDATA	=	3'b001;

	input clk;
	input reset;
	

	input		ready_to_read;
	input [2:0] slave_address;
	input slave_read;
	wire [7:0] slave_readdata;
	output [7:0] slave_readdata;
	input slave_write;
	input [7:0] slave_writedata;
//	input [3:0] slave_byteenable;

	input reg	fix_message_sent;
	output reg	read_request;
	input reg[7:0]	final_index;
	input reg[7:0]	data_out_2;	
	output reg[7:0]	session_initiate;	


	reg [7:0]	control_readdata_temp_d1;
	reg [7:0]	control_readdata_temp;
	//reg		read_request;
	reg [7:0]	index;

	// for internal logic
	reg [31:0] status_register;

	//reg [7:0]	index;
	reg [7:0]	read_result;
	//reg [31:0]	session_initiate;
	reg [31:0]	connect_initiate;	

// *** fix *************************************************************************************************** 
// *********************************************************************************************************** 
//	  (slave_address == 3'b011)? length_register :
//	  (slave_address == 3'b110)? control_register : 
//	  (slave_address == 3'b111)? checksum_register : 0;

	assign control_readdata_temp = (slave_address == RSTAT)? status_register : 
							  (slave_address == RDATA)? data_out_2 : 0;
							  
							  //read_result : 0;

	always @ (posedge clk or posedge reset)
	begin
		if (reset)
		begin
			control_readdata_temp_d1 <= 0;
		end
		else
		begin
			if (slave_read == 1)
			begin
				control_readdata_temp_d1 <= control_readdata_temp;
			end
		end
	end
	
	assign slave_readdata = control_readdata_temp_d1;	

					
	always @ (posedge clk or posedge reset)
	begin
		if (reset)
		begin
			status_register <= 0;
		end
		else
		begin
			if (fix_message_sent == 1)		    // all data written to the memory 
			begin
				status_register <= 32'h1;  // done
			end 

			if (connect_initiate == 8'hdd) 
				status_register <= 32'h0;  // done
		
		end
	end

	always @ (posedge clk or posedge reset)
	begin
		if (reset)
		begin
			connect_initiate <= 0;
		end
		else
		begin
			if ((slave_address == CONN) & (slave_write == 1))
			begin
				connect_initiate[7:0] <= slave_writedata[7:0];
			end else
				connect_initiate[7:0] <=	'0;
		end
	end
	
	assign session_initiate = connect_initiate;  

/*
	always @ (posedge clk)
	begin
			if (slave_read == 1 && slave_address == RDATA)
			begin
				read_request  <=  '1;	
				
			end else
				read_request  <=  '0;

			read_result 	<=	data_out_2;
	end
	*/
//	always @ (posedge clk) begin
//		if (read_request == 1)
//			index	<=	index + 1;
//		else	
//			index	<=	'0;
//	end

//	always @ (*) begin
//			addr_1	    	=	index;
//	end

// *** fix *************************************************************************************************** 
// *********************************************************************************************************** 
	
endmodule

