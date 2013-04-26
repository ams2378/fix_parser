library verilog;
use verilog.vl_types.all;
entity dut is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        configure_i     : in     vl_logic;
        connect_i       : in     vl_logic;
        connected_i     : in     vl_logic;
        connected_host_addr_i: in     vl_logic_vector(5 downto 0);
        new_message_i   : in     vl_logic;
        message_i       : in     vl_logic_vector(7 downto 0);
        connect_req_o   : out    vl_logic;
        connect_host_addr_o: out    vl_logic_vector(5 downto 0);
        send_message_o  : out    vl_logic;
        message_o       : out    vl_logic_vector(7 downto 0)
    );
end dut;
