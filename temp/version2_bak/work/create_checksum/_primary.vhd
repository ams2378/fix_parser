library verilog;
use verilog.vl_types.all;
entity create_checksum is
    generic(
        state0          : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        state1          : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        state2          : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        state3          : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        state4          : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        state5          : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi1);
        state6          : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi0);
        state7          : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        data_i          : in     vl_logic_vector(7 downto 0);
        start_i         : in     vl_logic;
        end_i           : in     vl_logic;
        checksum_o      : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of state0 : constant is 1;
    attribute mti_svvh_generic_type of state1 : constant is 1;
    attribute mti_svvh_generic_type of state2 : constant is 1;
    attribute mti_svvh_generic_type of state3 : constant is 1;
    attribute mti_svvh_generic_type of state4 : constant is 1;
    attribute mti_svvh_generic_type of state5 : constant is 1;
    attribute mti_svvh_generic_type of state6 : constant is 1;
    attribute mti_svvh_generic_type of state7 : constant is 1;
end create_checksum;
