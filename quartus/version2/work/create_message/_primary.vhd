library verilog;
use verilog.vl_types.all;
entity create_message is
    generic(
        VALUE_WIDTH     : integer := 256;
        SIZE            : integer := 64
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start_i         : in     vl_logic;
        done_i          : in     vl_logic;
        end_i           : in     vl_logic;
        bodyLength_r_i  : in     vl_logic;
        message_type_i  : in     vl_logic_vector(3 downto 0);
        v_beginString_i : in     vl_logic_vector;
        s_v_beginString_i: in     vl_logic_vector;
        v_senderCompId_i: in     vl_logic_vector;
        s_v_senderCompId_i: in     vl_logic_vector;
        v_targetCompId_i: in     vl_logic_vector;
        s_v_targetCompId_i: in     vl_logic_vector;
        v_heartBeatInt_i: in     vl_logic_vector;
        s_v_heartBeatInt_i: in     vl_logic_vector;
        v_sendTime_i    : in     vl_logic_vector;
        v_msgSeqNum_i   : in     vl_logic_vector;
        s_v_msgSeqNum_i : in     vl_logic_vector;
        tag_o           : out    vl_logic_vector(31 downto 0);
        tag_valid_o     : out    vl_logic;
        val_o           : out    vl_logic_vector;
        val_valid_o     : out    vl_logic;
        v_size_o        : out    vl_logic_vector;
        t_size_o        : out    vl_logic_vector(4 downto 0);
        checksum_o      : out    vl_logic;
        msg_creation_done_o: out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of VALUE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end create_message;
