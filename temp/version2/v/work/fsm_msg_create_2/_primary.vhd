library verilog;
use verilog.vl_types.all;
entity fsm_msg_create_2 is
    generic(
        VALUE_WIDTH     : integer := 256;
        T_SIZE          : integer := 5;
        SIZE            : integer := 64
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        tag_valid_i     : in     vl_logic;
        val_valid_i     : in     vl_logic;
        tag_i           : in     vl_logic_vector(31 downto 0);
        val_i           : in     vl_logic_vector;
        t_size_i        : in     vl_logic_vector;
        v_size_i        : in     vl_logic_vector;
        checksum_i      : in     vl_logic;
        checksum_val_i  : in     vl_logic_vector(7 downto 0);
        fifo_full_i     : in     vl_logic;
        data_o          : out    vl_logic_vector(7 downto 0);
        done_o          : out    vl_logic;
        end_o           : out    vl_logic;
        all_sent_o      : out    vl_logic;
        end_of_msg_o    : out    vl_logic;
        data_valid_o    : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of VALUE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of T_SIZE : constant is 1;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end fsm_msg_create_2;
