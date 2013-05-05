library verilog;
use verilog.vl_types.all;
entity ram is
    generic(
        ADDR_WIDTH      : integer := 6;
        DATA_WIDTH      : integer := 8
    );
    port(
        data            : in     vl_logic_vector;
        addr            : in     vl_logic_vector;
        we              : in     vl_logic;
        clk             : in     vl_logic;
        q               : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
end ram;