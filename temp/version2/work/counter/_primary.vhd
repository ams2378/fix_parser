library verilog;
use verilog.vl_types.all;
entity counter is
    generic(
        CNT_SIZE        : integer := 20;
        NUM_HOST        : integer := 2
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        heartbeat_i     : in     vl_logic_vector;
        send_message_i  : in     vl_logic;
        sending_to_host_addr_i: in     vl_logic_vector;
        timeout_o       : out    vl_logic;
        timeout_addr_o  : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CNT_SIZE : constant is 1;
    attribute mti_svvh_generic_type of NUM_HOST : constant is 1;
end counter;
