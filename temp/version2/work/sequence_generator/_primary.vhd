library verilog;
use verilog.vl_types.all;
entity sequence_generator is
    generic(
        MAX_SIZE        : integer := 8;
        NUM_HOST        : integer := 10
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        receive_new_message_i: in     vl_logic;
        heartbeat_i     : in     vl_logic_vector;
        send_message_i  : in     vl_logic;
        ignore_i        : in     vl_logic;
        sending_to_host_addr_i: in     vl_logic_vector;
        received_host_addr_i: in     vl_logic_vector;
        expected_seq_num_o: out    vl_logic_vector;
        outgoing_seq_num_o: out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MAX_SIZE : constant is 1;
    attribute mti_svvh_generic_type of NUM_HOST : constant is 1;
end sequence_generator;
