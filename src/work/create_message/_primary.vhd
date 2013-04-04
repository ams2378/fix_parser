library verilog;
use verilog.vl_types.all;
entity create_message is
    generic(
        VALUE_WIDTH     : integer := 256;
        WIDTH_SIZE      : integer := 5;
        SEQMEM_DEPTH    : integer := 10
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        create_message_i: in     vl_logic;
        message_type_i  : in     vl_logic_vector(2 downto 0);
        checksum_i      : in     vl_logic_vector(23 downto 0);
        beginstring_i   : in     vl_logic_vector(5 downto 0);
        senderCompId_i  : in     vl_logic_vector;
        targetCompId_i  : in     vl_logic_vector;
        heartBeatInt_i  : in     vl_logic_vector(7 downto 0);
        sizeSenderId_i  : in     vl_logic_vector;
        sizeTargetId_i  : in     vl_logic_vector;
        msgSeqNum_i     : in     vl_logic_vector;
        start_checksum_o: out    vl_logic;
        end_checksum_o  : out    vl_logic;
        data_o          : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of VALUE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of WIDTH_SIZE : constant is 1;
    attribute mti_svvh_generic_type of SEQMEM_DEPTH : constant is 1;
end create_message;
