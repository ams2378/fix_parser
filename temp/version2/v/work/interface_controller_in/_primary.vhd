library verilog;
use verilog.vl_types.all;
entity interface_controller_in is
    generic(
        NUM_HOST        : integer := 2
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        full_i          : in     vl_logic;
        send_message_valid_i: in     vl_logic;
        message_i       : in     vl_logic_vector(7 downto 0);
        connect_req_i   : in     vl_logic;
        connect_host_addr_i: in     vl_logic_vector;
        disconnect_i    : in     vl_logic;
        disconnect_addr_i: in     vl_logic_vector;
        message_length_i: in     vl_logic_vector(7 downto 0);
        all_sent_i      : in     vl_logic;
        initiate_msg_i  : in     vl_logic;
        data_o          : out    vl_logic_vector(7 downto 0);
        writereq_o      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM_HOST : constant is 1;
end interface_controller_in;
