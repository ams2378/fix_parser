library verilog;
use verilog.vl_types.all;
entity bodylength is
    generic(
        HOST_ADDR       : integer := 2;
        MAX_SIZE        : integer := 80;
        VALUE_WIDTH     : integer := 256
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start_i         : in     vl_logic;
        create_message_i: in     vl_logic_vector(3 downto 0);
        l_v_msgSeqNum_i : in     vl_logic_vector(3 downto 0);
        l_v_targetCompId: in     vl_logic_vector(5 downto 0);
        msg_length_bin_o: out    vl_logic_vector(7 downto 0);
        v_bodyLength_o  : out    vl_logic_vector;
        valid_o         : out    vl_logic;
        s_v_bodyLength_o: out    vl_logic_vector(9 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of HOST_ADDR : constant is 1;
    attribute mti_svvh_generic_type of MAX_SIZE : constant is 1;
    attribute mti_svvh_generic_type of VALUE_WIDTH : constant is 1;
end bodylength;
