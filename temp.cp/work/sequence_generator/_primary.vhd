library verilog;
use verilog.vl_types.all;
entity sequence_generator is
    generic(
        MAX_SIZE        : integer := 8
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        connect_i       : in     vl_logic;
        receive_new_message_i: in     vl_logic;
        message_valid_i : in     vl_logic;
        send_message_i  : in     vl_logic;
        igonre_i        : in     vl_logic;
        expected_seq_num_o: out    vl_logic_vector;
        outgoing_seq_num_o: out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MAX_SIZE : constant is 1;
end sequence_generator;
