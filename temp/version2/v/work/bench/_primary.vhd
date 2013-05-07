library verilog;
use verilog.vl_types.all;
entity bench is
    generic(
        NUM_HOST        : integer := 2
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM_HOST : constant is 1;
end bench;
