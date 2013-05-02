library verilog;
use verilog.vl_types.all;
entity binary_to_bcd is
    generic(
        BITS_IN_PP      : integer := 32;
        BCD_DIGITS_OUT_PP: integer := 10;
        BIT_COUNT_WIDTH_PP: integer := 5
    );
    port(
        clk_i           : in     vl_logic;
        ce_i            : in     vl_logic;
        rst_i           : in     vl_logic;
        start_i         : in     vl_logic;
        dat_binary_i    : in     vl_logic_vector;
        dat_bcd_o       : out    vl_logic_vector;
        done_o          : out    vl_logic;
        ascii_o         : out    vl_logic_vector;
        size_o          : out    vl_logic_vector(9 downto 0);
        width_o         : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of BITS_IN_PP : constant is 1;
    attribute mti_svvh_generic_type of BCD_DIGITS_OUT_PP : constant is 1;
    attribute mti_svvh_generic_type of BIT_COUNT_WIDTH_PP : constant is 1;
end binary_to_bcd;
