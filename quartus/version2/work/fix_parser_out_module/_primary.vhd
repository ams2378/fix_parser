library verilog;
use verilog.vl_types.all;
entity fix_parser_out_module is
    generic(
        state0          : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        state1          : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        state2          : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        state3          : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        state4          : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        state5          : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        data_i          : in     vl_logic_vector(7 downto 0);
        start_tag_i     : in     vl_logic;
        start_value_i   : in     vl_logic;
        t_wr_cs_o       : out    vl_logic;
        t_wr_en_o       : out    vl_logic;
        v_wr_cs_o       : out    vl_logic;
        v_wr_en_o       : out    vl_logic;
        tag_o           : out    vl_logic_vector(31 downto 0);
        value_o         : out    vl_logic_vector(255 downto 0);
        end_of_body_o   : out    vl_logic;
        start_message_o : out    vl_logic;
        start_of_header_o: out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of state0 : constant is 1;
    attribute mti_svvh_generic_type of state1 : constant is 1;
    attribute mti_svvh_generic_type of state2 : constant is 1;
    attribute mti_svvh_generic_type of state3 : constant is 1;
    attribute mti_svvh_generic_type of state4 : constant is 1;
    attribute mti_svvh_generic_type of state5 : constant is 1;
end fix_parser_out_module;
