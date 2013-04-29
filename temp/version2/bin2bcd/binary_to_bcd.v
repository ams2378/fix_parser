module binary_to_bcd # (parameter BITS_IN_PP = 32, BCD_DIGITS_OUT_PP = 10, BIT_COUNT_WIDTH_PP = 5) (
  clk_i,
  ce_i,
  rst_i,
  start_i,
  dat_binary_i,
  dat_bcd_o,
  done_o,

  ascii_o,
  size_o,
  width_o
  );

//parameter BITS_IN_PP         = 32; // # of bits of binary input
//parameter BCD_DIGITS_OUT_PP  = 10;  // # of digits of BCD output
//parameter BIT_COUNT_WIDTH_PP = 5;  // Width of bit counter
 
// I/O declarations
input  clk_i;                      // clock signal
input  ce_i;                       // clock enable input
input  rst_i;                      // synchronous reset
input  start_i;                    // initiates a conversion
input  [BITS_IN_PP-1:0] dat_binary_i;        // input bus
output [4*BCD_DIGITS_OUT_PP-1:0] dat_bcd_o;  // output bus
output done_o;                     // indicates conversion is done
output [3:0]	width_o;
 
reg [4*BCD_DIGITS_OUT_PP-1:0] dat_bcd_o;
integer			i;
reg [8*BCD_DIGITS_OUT_PP-1:0] ascii;
output [8*BCD_DIGITS_OUT_PP-1:0] ascii_o;
reg [9:0] size;
output [9:0] size_o;

 
reg [3:0]	width;
//reg [4:0] 	bit_width;
reg [9:0] 	bit_width;			// edit ams


// Internal signal declarations
 
reg  [BITS_IN_PP-1:0] bin_reg;
reg  [4*BCD_DIGITS_OUT_PP-1:0] bcd_reg;
wire [BITS_IN_PP-1:0] bin_next;
reg  [4*BCD_DIGITS_OUT_PP-1:0] bcd_next;
reg  busy_bit;
reg  [BIT_COUNT_WIDTH_PP-1:0] bit_count;
wire bit_count_done;
 
//--------------------------------------------------------------------------
// Functions & Tasks
//--------------------------------------------------------------------------
 
function [4*BCD_DIGITS_OUT_PP-1:0] bcd_asl;
  input [4*BCD_DIGITS_OUT_PP-1:0] din;
  input newbit;
  integer k;
  reg cin;
  reg [3:0] digit;
  reg [3:0] digit_less;
  begin
    cin = newbit;
    for (k=0; k<BCD_DIGITS_OUT_PP; k=k+1)
    begin
      digit[3] = din[4*k+3];
      digit[2] = din[4*k+2];
      digit[1] = din[4*k+1];
      digit[0] = din[4*k];
      digit_less = digit - 5;
      if (digit > 4'b0100)
      begin
        bcd_asl[4*k+3] = digit_less[2];
        bcd_asl[4*k+2] = digit_less[1];
        bcd_asl[4*k+1] = digit_less[0];
        bcd_asl[4*k+0] = cin;
        cin = 1'b1;
      end
      else
      begin
        bcd_asl[4*k+3] = digit[2];
        bcd_asl[4*k+2] = digit[1];
        bcd_asl[4*k+1] = digit[0];
        bcd_asl[4*k+0] = cin;
        cin = 1'b0;
      end
 
    end // end of for loop
  end
endfunction
 
//--------------------------------------------------------------------------
// Module code
//--------------------------------------------------------------------------
 
// Perform proper shifting, binary ASL and BCD ASL
assign bin_next = {bin_reg,1'b0};
always @(bcd_reg or bin_reg)
begin
  bcd_next <= bcd_asl(bcd_reg,bin_reg[BITS_IN_PP-1]);
end
 
// Busy bit, input and output registers
always @(posedge clk_i or rst_i)
begin
  if (rst_i)
  begin
    busy_bit <= 0;  // Synchronous reset
    dat_bcd_o <= 0;
  end
  else if (start_i && ~busy_bit)
  begin
    busy_bit <= 1;
    bin_reg <= dat_binary_i;
    bcd_reg <= 0;
  end
  else if (busy_bit && ce_i && bit_count_done && ~start_i)
  begin
    busy_bit <= 0;
    dat_bcd_o <= bcd_next;
  end
  else if (busy_bit && ce_i && ~bit_count_done)
  begin
    bcd_reg <= bcd_next;
    bin_reg <= bin_next;
  end
end
assign done_o = ~busy_bit;
 
// Bit counter
always @(posedge clk_i)
begin
  if (~busy_bit) bit_count <= 0;
  else if (ce_i && ~bit_count_done) bit_count <= bit_count + 1;
end
assign bit_count_done = (bit_count == (BITS_IN_PP-1));

always @(*) begin

bit_width[0] = ~ (bcd_next[0] | bcd_next[1] | bcd_next[2] | bcd_next[3]); 
bit_width[1] = ~ (bcd_next[4] | bcd_next[5] | bcd_next[6] | bcd_next[7]); 
bit_width[2] = ~ (bcd_next[8] | bcd_next[9] | bcd_next[10] | bcd_next[11]); 
bit_width[3] = ~ (bcd_next[12] | bcd_next[13] | bcd_next[14] | bcd_next[15]); 
bit_width[4] = ~ (bcd_next[16] | bcd_next[17] | bcd_next[18] | bcd_next[19]); 
bit_width[5] = ~ (bcd_next[20] | bcd_next[21] | bcd_next[22] | bcd_next[23]); 
bit_width[6] = ~ (bcd_next[24] | bcd_next[25] | bcd_next[26] | bcd_next[27]); 
bit_width[7] = ~ (bcd_next[28] | bcd_next[29] | bcd_next[30] | bcd_next[31]); 
bit_width[8] = ~ (bcd_next[32] | bcd_next[33] | bcd_next[34] | bcd_next[35]); 
bit_width[9] = ~ (bcd_next[36] | bcd_next[37] | bcd_next[38] | bcd_next[39]); 

	for (i = 0; i < 10; i = i+1) begin
		case (bcd_next[i*4 +: 4])
			4'b0000	: ascii[i*8 +: 8]		=	8'b00110000;
			4'b0001	: ascii[i*8 +: 8]		=	8'b00110001;
			4'b0010	: ascii[i*8 +: 8]		=	8'b00110010;
			4'b0011	: ascii[i*8 +: 8]		=	8'b00110011;
			4'b0100	: ascii[i*8 +: 8]		=	8'b00110100;
			4'b0101	: ascii[i*8 +: 8]		=	8'b00110101;
			4'b0110	: ascii[i*8 +: 8]		=	8'b00110110;
			4'b0111	: ascii[i*8 +: 8]		=	8'b00110111;
			4'b1000	: ascii[i*8 +: 8]		=	8'b00111000;
			4'b1001	: ascii[i*8 +: 8]		=	8'b00111001;
			default	: ascii[i*8 +: 8]		=	'0;		
		endcase
	end


	casez (bit_width) 
		10'b0????????? : begin width = 4'b1010; size = 10'b1111111111; end
		10'b10???????? : begin width = 4'b1001; size = 10'b0111111111; end
		10'b110??????? : begin width = 4'b1000; size = 10'b0011111111; end
		10'b1110?????? : begin width = 4'b0111; size = 10'b0001111111; end
		10'b11110????? : begin width = 4'b0110; size = 10'b0000111111; end
		10'b111110???? : begin width = 4'b0101; size = 10'b0000011111; end
		10'b1111110??? : begin width = 4'b0100; size = 10'b0000001111; end
		10'b11111110?? : begin width = 4'b0011; size = 10'b0000000111; end
		10'b111111110? : begin width = 4'b0010; size = 10'b0000000011; end
		10'b1111111110 : begin width = 4'b0001; size = 10'b0000000001; end
		10'b1111111111 : begin width = 4'b0000; size = '0; end
		default  : begin width = 4'b0000; size = '0; end
	endcase
end

assign width_o	=	width;
assign size_o	=	size;
assign ascii_o	=	ascii;
 
endmodule
 
