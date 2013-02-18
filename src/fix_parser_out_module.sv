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
	
	output[31:0]		tag_o,
	output[31:0]		value_o,
	output			tag_status_o,
	output			value_status_o,
	output 			tag_valid_o,
	output			value_valid_o
//	output[1:0]		data_type
);

logic[31:0]			tag;
logic[31:0]			body;
logic				tag_status;
logic				body_status;
logic				tag_valid;
logic				body_valid;

always_comb begin

	if ((soh_i != 3'b111) && (sep_i != 3'b111)) begin	
	//	data_type = 2'b00;	
		case({soh_i, sep_i})
				6'b011001:	begin 
								tag  = data_i[23:16]; 
									tag_valid = '1;
									tag_status = '0;
									body = '0;
									body_valid = '0;
									body_status = '1;
								end								
				6'b011000:	begin
									tag  = data_i[23:08];
									tag_valid = '1;
									tag_status = '0;
									body = '0;
									body_valid = '0;
									body_status = '1;
								end															
				6'b000011:	begin
									body = data_i[23:08];
									body_valid = '1;
									body_status = '0;
									tag = '0;
									tag_valid = '0;
									tag_status = '0;
								end																
				6'b001011:	begin
									body = data_i[23:16];
									body_valid = '1;
									body_status = '0;
									tag = '0;
									tag_valid = '0;
									tag_status = '0;
								end															
									
				6'b010000:  begin
									tag  = data_i[15:08];
									tag_valid = '1;
									tag_status = '0;
									body = '0;
									body_valid = '0;
									body_status = '1;
								end																										
				6'b000010:  begin
									body = data_i[15:08];
									body_valid = '1;
									body_status = '0;
									tag = '0;
									tag_valid = '0;
									tag_status = '0;
								end	
				default:		begin
									body = '0;
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
									body =  data_i[31:8];   
									body_valid = '1; 
									tag = '0;
									tag_valid = '0;  
									tag_status = '1; 		 
									body_status = '0;
							  end
					3'b001: begin 
									body = data_i[31:16];			 
									body_valid = '1; 
									body_status = '0;
									tag  =  data_i[7:0];		
									tag_valid = '1;
									tag_status = '1;
							  end
					3'b010: begin 
									body = data_i[31:24];		 
									body_valid = '1; 
									body_status = '0;
									tag  = data_i[15:0];		
									tag_valid = '1;		
									tag_status = '1;
							  end
					3'b011: begin 
									body = '0;				
									body_valid = '0; 
									body_status = '0;
									tag = data_i[23:0];		
									tag_valid = '1;
								   tag_status = '1;
							  end
					default: begin body = '0;				
									body_valid = '0; 
									tag = '0;
									tag_valid = '0;
									tag_status = '0;
									body_status = '0;
						  	   end
				endcase
	end else if ((soh_i == 3'b111) && (sep_i != 3'b111)) begin
//		data_type = 2'b10;	
				case (sep_i)
							3'b000: begin 	
										tag = data_i[31:8]; 					  
										tag_valid = '1; 
										body = '0;
										body_valid = '0;
										tag_status = '0; 
										body_status = '1;
							 	end
							3'b001: begin 
										tag = data_i[31:16];			 
										tag_valid = '1; 
										tag_status = '0;
										body  = data_i[7:0];		
										body_valid = '1;
										body_status = '1;
								end
							3'b010: begin 
										tag = data_i[31:24];		 
										tag_valid = '1; 
										tag_status = '0;											
										body  = data_i[15:0];		
										body_valid = '1;	
									        body_status = '1;	
								end
							3'b011: begin 
										tag = '0;				
										tag_valid = '0; 
										tag_status = '0;
										body = data_i[23:0];	
										body_valid = '1;
										body_status = '1;
								end
							default: begin 
										body = '0;				
										body_valid = '0; 
										tag = '0;
										tag_valid = '0;
										tag_status = '0;
										body_status = '0;
								end
				endcase
	end else if ((soh_i == 3'b111) && (sep_i == 3'b111)) begin	
						
	//	data_type = 2'b11;	
							if (tag_status_i == '1)	begin
										body = '0;
										body_valid = '0;
										body_status = '0;											
										tag = data_i[31:0];
										tag_valid = '1;
										tag_status = '1;
	
							end else if (value_status_i == '1) begin	
										
										body = data_i[31:0];
										body_valid = '1;
										body_status = '1;											
										tag = '0;
										tag_valid = '0;
										tag_status = '0;																					
							end else begin
										body = '0;
										body_valid = '0;
										body_status = '0;											
										tag = '0;
										tag_valid = '0;
										tag_status = '0;	
							end
	end else begin
	
										body = '0;
										body_valid = '0;
										body_status = '0;											
										tag = '0;
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

assign tag_o = tag;
assign tag_status_o = tag_status;
assign tag_valid_o = tag_valid;
assign value_o = body;
assign value_status_o = body_status;
assign value_valid_o = body_valid;

endmodule

