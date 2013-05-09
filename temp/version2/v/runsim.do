vlib work 
vmap work work

vlog defines.vh ascii2int.v binary_to_bcd.v hostaddress.v ram_fix.v received_msg_processor.v session_manager.v create_message.v fsm_msg_create_2.v sequence_generator.v connection_toe.v create_checksum.v fix_parser.v fix_parser_out_module.v checksum.v bodylength.v interface_controller_in.v fix_engine.v 

#vlog -incr bench.v 
vlog bench.v 

vsim -t ps -lib work bench
#do waveformat.do   
run -al 
#while {[exa testend_s] == "false"} {run 0.20 ms}
#quit -sim	 
