library verilog;
use verilog.vl_types.all;
entity session_controller is
    generic(
        state0          : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        state1          : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0);
        state2          : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0);
        state3          : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0);
        state4          : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        state5          : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        state6          : vl_logic_vector(0 to 7) := (Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        state7          : vl_logic_vector(0 to 7) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        configure_i     : in     vl_logic;
        start_i         : in     vl_logic;
        end_session_i   : in     vl_logic;
        connected_i     : in     vl_logic;
        response_received_i: in     vl_logic;
        packet_status_i : in     vl_logic_vector(2 downto 0);
        timeout_i       : in     vl_logic;
        message_created_i: in     vl_logic;
        new_message_r_i : in     vl_logic;
        send_b_a_message_i: in     vl_logic;
        received_msg_type_i: in     vl_logic_vector(2 downto 0);
        load_configure_o: out    vl_logic;
        connect_o       : out    vl_logic;
        create_message_o: out    vl_logic_vector(2 downto 0);
        send_message_o  : out    vl_logic;
        disconnect_o    : out    vl_logic;
        ignore_o        : out    vl_logic;
        initiate_msg_o  : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of state0 : constant is 1;
    attribute mti_svvh_generic_type of state1 : constant is 1;
    attribute mti_svvh_generic_type of state2 : constant is 1;
    attribute mti_svvh_generic_type of state3 : constant is 1;
    attribute mti_svvh_generic_type of state4 : constant is 1;
    attribute mti_svvh_generic_type of state5 : constant is 1;
    attribute mti_svvh_generic_type of state6 : constant is 1;
    attribute mti_svvh_generic_type of state7 : constant is 1;
end session_controller;
