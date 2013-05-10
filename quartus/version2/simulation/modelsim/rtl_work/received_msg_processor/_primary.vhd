library verilog;
use verilog.vl_types.all;
entity received_msg_processor is
    generic(
        VALUE_WIDTH     : integer := 256;
        COUNTER_DEPTH   : integer := 80
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        tag_valid_i     : in     vl_logic;
        tag_i           : in     vl_logic_vector(31 downto 0);
        val_valid_i     : in     vl_logic;
        val_i           : in     vl_logic_vector;
        start_of_message_i: in     vl_logic;
        end_of_message_i: in     vl_logic;
        expectedIncomingSeqNum_i: in     vl_logic_vector;
        checksum_validity_i: in     vl_logic;
        new_message_o   : out    vl_logic;
        error_type_o    : out    vl_logic_vector(3 downto 0);
        type_o          : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of VALUE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of COUNTER_DEPTH : constant is 1;
end received_msg_processor;
