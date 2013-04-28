library verilog;
use verilog.vl_types.all;
entity fix_engine is
    generic(
        NUM_HOST        : integer := 2;
        SIZE            : integer := 64;
        T_SIZE          : integer := 5
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        connect_i       : in     vl_logic;
        connect_to_host_i: in     vl_logic_vector;
        connected_i     : in     vl_logic;
        connected_host_addr_i: in     vl_logic_vector;
        message_i       : in     vl_logic_vector(7 downto 0);
        valid_i         : in     vl_logic;
        new_message_i   : in     vl_logic;
        connect_req_o   : out    vl_logic;
        disconnect_o    : out    vl_logic;
        connect_addr_o  : out    vl_logic_vector;
        disconnect_host_num_o: out    vl_logic_vector;
        send_message_valid_o: out    vl_logic;
        message_o       : out    vl_logic_vector(7 downto 0);
        message_received_o: out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM_HOST : constant is 1;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
    attribute mti_svvh_generic_type of T_SIZE : constant is 1;
end fix_engine;
