library verilog;
use verilog.vl_types.all;
entity session_manager is
    generic(
        NUM_HOST        : integer := 2;
        VALUE_WIDTH     : integer := 256;
        SIZE            : integer := 64
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        new_message_i   : in     vl_logic;
        validity_i      : in     vl_logic_vector(3 downto 0);
        timeout_i       : in     vl_logic;
        connected_host_i: in     vl_logic_vector;
        type_i          : in     vl_logic_vector(3 downto 0);
        connected_i     : in     vl_logic;
        end_session_i   : in     vl_logic;
        resendDone_i    : in     vl_logic;
        data_out_2      : in     vl_logic_vector;
        we_2            : out    vl_logic;
        addr_2          : out    vl_logic_vector;
        data_in_2       : out    vl_logic_vector;
        disconnect_o    : out    vl_logic;
        disconnect_host_num_o: out    vl_logic_vector;
        targetCompId_o  : out    vl_logic_vector;
        s_v_targetCompId_o: out    vl_logic_vector;
        ignore_o        : out    vl_logic;
        updateSeqCounter_o: out    vl_logic;
        seqCounterLoc_o : out    vl_logic_vector;
        create_message_o: out    vl_logic_vector(3 downto 0);
        initiate_msg_o  : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM_HOST : constant is 1;
    attribute mti_svvh_generic_type of VALUE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end session_manager;
