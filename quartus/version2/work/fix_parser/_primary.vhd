library verilog;
use verilog.vl_types.all;
entity fix_parser is
    generic(
        initial_s       : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        tag             : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        value           : vl_logic_vector(0 to 1) := (Hi1, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        data_i          : in     vl_logic_vector(7 downto 0);
        new_message_i   : in     vl_logic;
        data_o          : out    vl_logic_vector(7 downto 0);
        tag_s_o         : out    vl_logic;
        value_s_o       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of initial_s : constant is 1;
    attribute mti_svvh_generic_type of tag : constant is 1;
    attribute mti_svvh_generic_type of value : constant is 1;
end fix_parser;
