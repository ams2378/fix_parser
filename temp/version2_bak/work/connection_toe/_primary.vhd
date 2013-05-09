library verilog;
use verilog.vl_types.all;
entity connection_toe is
    generic(
        HOST_ADDR       : integer := 2
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        connect_i       : in     vl_logic;
        connect_addr_i  : in     vl_logic_vector;
        connect_o       : out    vl_logic;
        connect_host_addr_o: out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of HOST_ADDR : constant is 1;
end connection_toe;
