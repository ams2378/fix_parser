/**
 * @filename		fix_parser_out_module.sv 
 *
 * @brief     	        detects TAG and VALUE from 32 bit received data. 	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 */


module fix_parser_out_module (

	input[31:0]		data_i,
	input[2:0] 		soh_i,
	input[2:0]		sep_i,
	input			tag_status_i,
	input			value_status_i,
	
	output[31:0]		out_o,
//	output[31:0]		value_o,
	output			tag_status_o,
	output			value_status_o,
	output[3:0]		tag_valid_o,
	output[3:0]		value_valid_o
//	output[1:0]		data_type
);

logic[31:0]			out;
//logic[31:0]			body;
logic				tag_status;
logic				body_status;
logic [3:0]			tag_valid;
logic [3:0]			body_valid;

always_comb begin

	if ((soh_i != 3'b111) && (sep_i != 3'b111)) begin	
	//	data_type = 2'b00;	
		case({soh_i, sep_i})
				6'b011001:	begin 
								out[7:0]  =  data_i[23:16]; 
									     tag_valid = 4'b0010;
									     body_valid = 4'b0000;
									tag_status = '0;
								//	body = '0;
								//	body_valid = '0;
									body_status = '1;
								end								
				6'b011000:	begin
								out[15:0]   = data_i[23:08];
									tag_valid = 4'b0110;
									tag_status = '0;
								//	body = '0;
									body_valid = '0;
									body_status = '1;
								end															
				6'b000011:	begin
								out[15:0] = data_i[23:08];
									body_valid = 4'b0110;
									body_status = '0;
								//	tag = '0;
									tag_valid = '0;
									tag_status = '0;
								end																
				6'b001011:	begin
								out[7:0] = data_i[23:16];
									body_valid = 4'b0100;
									body_status = '0;
								//	tag = '0;
									tag_valid = '0;
									tag_status = '0;
								end															
									
				6'b010000:  begin
								out[7:0] = data_i[15:08];
									tag_valid = 4'b0010;
									tag_status = '0;
								//	body = '0;
									body_valid = '0;
									body_status = '1;
								end																										
				6'b000010:  begin
								out [7:0] = data_i[15:08];
									body_valid = 4'b0010;
									body_status = '0;
									tag = '0;
								//	tag_valid = '0;
									tag_status = '0;
								end	
				default:		begin
									out = '0;
									body_valid = '0;
									body_status = '0;
									tag = '0;
									tag_valid = '0;
									tag_status = '0;
								end	
		endcase		
	end else if ((soh_i != 3'b111) && (sep_i == 3'b111)) begin
//		data_type = 2'b01;	
				case (soh_i)
					3'b000: begin
								out[31:8]	 =  data_i[31:8];   
									body_valid = 4'b1110; 
								//	tag = '0;
									tag_valid = '0;  
									tag_status = '1; 		 
									body_status = '0;
							  end
					3'b001: begin 
								out[23:8]  = data_i[31:16];			 
									body_valid = 4'b0110; 
									body_status = '0;
								out[7:0]  =  data_i[7:0];		
									tag_valid = 4'b0001;
									tag_status = '1;
							  end
					3'b010: begin 
								out[23:16]  = data_i[31:24];		 
									body_valid = 4'b0100; 
									body_status = '0;
								out[15:0]  = data_i[15:0];		
									tag_valid = 4'b0011;		
									tag_status = '1;
							  end
					3'b011: begin 
								//	body = '0;				
									body_valid = '0; 
									body_status = '0;
									out[23:0] = data_i[23:0];		
									tag_valid = 4'b0111;
								   tag_status = '1;
							  end
					default: begin body = '0;				
									body_valid = '0; 
									out = '0;
									tag_valid = '0;
									tag_status = '0;
									body_status = '0;
						  	   end
				endcase
	end else if ((soh_i == 3'b111) && (sep_i != 3'b111)) begin
//		data_type = 2'b10;	
				case (sep_i)
							3'b000: begin 	
									out[23:0] = data_i[31:8]; 					  
										tag_valid = 4'b0111; 
									//	body = '0;
										body_valid = '0;
										tag_status = '0; 
										body_status = '1;
							 	end
							3'b001: begin 
									out[23:8] = data_i[31:16];			 
										tag_valid = 4'b0110; 
										tag_status = '0;
									out[7:0]  = data_i[7:0];		
										body_valid = 4'b0001;
										body_status = '1;
								end
							3'b010: begin 
									out[23:16] = data_i[31:24];		 
										tag_valid = 4'b0100; 
										tag_status = '0;											
									out[15:0]  = data_i[15:0];		
										body_valid = 4'b0011;	
									        body_status = '1;	
								end
							3'b011: begin 
									//	tag = '0;				
										tag_valid = '0; 
										tag_status = '0;
									out[23:0]  = data_i[23:0];	
										body_valid = 4'b0111;
										body_status = '1;
								end
							default: begin 
									out	 = '0;				
										body_valid = '0; 
									//	tag = '0;
										tag_valid = '0;
										tag_status = '0;
										body_status = '0;
								end
				endcase
	end else if ((soh_i == 3'b111) && (sep_i == 3'b111)) begin	
						
	//	data_type = 2'b11;	
							if (tag_status_i == '1)	begin
								//		body = '0;
										body_valid = '0;
										body_status = '0;											
									out	 = data_i[31:0];
										tag_valid = 4'b1111;
										tag_status = '1;
	
							end else if (value_status_i == '1) begin	
										
									out	 = data_i[31:0];
										body_valid = 4'b1111;
										body_status = '1;											
									//	tag = '0;
										tag_valid = '0;
										tag_status = '0;																					
							end else begin
									out	 = '0;
										body_valid = '0;
										body_status = '0;											
								//		tag = '0;
										tag_valid = '0;
										tag_status = '0;	
							end
	end else begin
										out = '0;
									//	body = '0;
										body_valid = '0;
										body_status = '0;											
									//	tag = '0;
										tag_valid = '0;
										tag_status = '0;		
										
	end
end



/*

ff #(.WIDTH(32)) mem (



);

ff #(.WIDTH(2)) mem_var(



);


always @(posedge clk) begin

if (body_status == 0 && tag_status == 1 && )





end

*/

//assign tag_o = tag;

assign out_o = out; 
assign tag_status_o = tag_status;
assign tag_valid_o = tag_valid;
//assign value_o = body;
assign value_status_o = body_status;
assign value_valid_o = body_valid;

endmodule

