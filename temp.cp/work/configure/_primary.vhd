library verilog;
use verilog.vl_types.all;
entity configure is
    generic(
        VALUE_WIDTH     : integer := 256;
        SIZE            : integer := 8
    );
    port(
        clk             : in     vl_logic;
        configure_i     : in     vl_logic;
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
        connectType_o   : out    vl_logic_vector(1 downto 0);
        reconnectInt_o  : out    vl_logic_vector(7 downto 0);
        starttime_o     : out    vl_logic_vector(15 downto 0);
        endtime_o       : out    vl_logic_vector(15 downto 0);
        beginstring_o   : out    vl_logic_vector(5 downto 0);
        defaultApplVerId_o: out    vl_logic_vector(5 downto 0);
        senderCompId_o  : out    vl_logic_vector;
        targetCompId_o  : out    vl_logic_vector;
        hostAddr_o      : out    vl_logic_vector(15 downto 0);
        heartBeatInt_o  : out    vl_logic_vector(7 downto 0);
        sizeSenderId_o  : out    vl_logic_vector;
        sizeTargetId_o  : out    vl_logic_vector;
        sizeHeartBeat_o : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of VALUE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end configure;
