library verilog;
use verilog.vl_types.all;
entity top is
    generic(
        VALUE_WIDTH     : integer := 256;
        SIZE            : integer := 64;
        T_SIZE          : integer := 5
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        configure_i     : in     vl_logic;
        start_i         : in     vl_logic;
        end_session_i   : in     vl_logic;
        connected_i     : in     vl_logic;
        connectType_i   : in     vl_logic_vector(1 downto 0);
        reconnectInt_i  : in     vl_logic_vector(7 downto 0);
        starttime_i     : in     vl_logic_vector(15 downto 0);
        endtime_i       : in     vl_logic_vector(15 downto 0);
        beginstring_i   : in     vl_logic_vector(5 downto 0);
        defaultApplVerId_i: in     vl_logic_vector(5 downto 0);
        senderCompId_i  : in     vl_logic_vector;
        targetCompId_i  : in     vl_logic_vector;
        hostAddr_i      : in     vl_logic_vector(15 downto 0);
        heartBeatInt_i  : in     vl_logic_vector(7 downto 0);
        sizeSenderId_i  : in     vl_logic_vector;
        sizeTargetId_i  : in     vl_logic_vector;
        sizeHeartBeat_i : in     vl_logic_vector;
        response_received_i: in     vl_logic;
        packet_status_i : in     vl_logic_vector(2 downto 0);
        received_msg_type_i: in     vl_logic_vector(2 downto 0);
        new_message_r_i : in     vl_logic;
        connect_o       : out    vl_logic;
        send_message_o  : out    vl_logic;
        disconnect_o    : out    vl_logic;
        ignore_o        : out    vl_logic;
        data_o          : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of VALUE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
    attribute mti_svvh_generic_type of T_SIZE : constant is 1;
end top;
