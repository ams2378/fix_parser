library verilog;
use verilog.vl_types.all;
entity hostaddress is
    generic(
        ADDR_WIDTH      : integer := 2;
        DATA_WIDTH      : integer := 321;
        SIZE            : integer := 6
    );
    port(
        data            : in     vl_logic_vector;
        addr            : in     vl_logic_vector;
        we              : in     vl_logic;
        clk             : in     vl_logic;
        host_size       : out    vl_logic_vector;
        q               : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end hostaddress;
