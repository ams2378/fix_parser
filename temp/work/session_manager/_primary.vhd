library verilog;
use verilog.vl_types.all;
entity session_manager is
    generic(
        NUM_HOST        : integer := 10;
        VALUE_WIDTH     : integer := 256
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        new_message_i   : in     vl_logic;
        validity_i      : in     vl_logic_vector(2 downto 0);
        timeout_i       : in     vl_logic;
        connected_host_i: in     vl_logic_vector;
        type_i          : in     vl_logic_vector(2 downto 0);
        connected_i     : in     vl_logic;
        end_session_i   : in     vl_logic;
        resendDone_i    : in     vl_logic;
        ignore_o        : out    vl_logic;
        disconnect_o    : out    vl_logic;
        error_type_o    : out    vl_logic_vector(2 downto 0);
        resendReq_o     : out    vl_logic;
        targetCompId_o  : out    vl_logic_vector;
        igonre_o        : out    vl_logic;
        doResend_o      : out    vl_logic;
        sendHeartbeat_o : out    vl_logic;
        sendLogout_o    : out    vl_logic;
        messagereceived_o: out    vl_logic;
        updateSeqCounter_o: out    vl_logic;
        seqCounterLoc_o : out    vl_logic_vector;
        disconnect_host_num_o: out    vl_logic_vector;
        sendLogon_o     : out    vl_logic;
        end_session_o   : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM_HOST : constant is 1;
    attribute mti_svvh_generic_type of VALUE_WIDTH : constant is 1;
end session_manager;
