library verilog;
use verilog.vl_types.all;
entity sequence_generator is
    generic(
        MAX_SIZE        : integer := 80;
        HOST_ADDR       : integer := 2;
        SIZE            : integer := 64
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        receive_new_message_i: in     vl_logic;
        create_message_i: in     vl_logic;
        ignore_i        : in     vl_logic;
        updateSeqCounter_i: in     vl_logic;
        seqCounterLoc_i : in     vl_logic_vector(1 downto 0);
        newSeqNum_i     : in     vl_logic_vector;
        sending_to_host_addr_i: in     vl_logic_vector(1 downto 0);
        received_host_addr_i: in     vl_logic_vector(1 downto 0);
        expected_seq_num_o: out    vl_logic_vector;
        outgoing_seq_num_o: out    vl_logic_vector;
        size_seq_num_o  : out    vl_logic_vector;
        valid_seq_num_o : out    vl_logic;
        width_seq_o     : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MAX_SIZE : constant is 1;
    attribute mti_svvh_generic_type of HOST_ADDR : constant is 1;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end sequence_generator;
