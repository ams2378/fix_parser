transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2/bin2bcd {/home/adil/fix_engine/fix_parser/quartus/version2/bin2bcd/binary_to_bcd.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/ram.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/fix_parser_out_module.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/fix_parser.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/create_checksum.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/ascii2int.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/session_manager.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/sequence_generator.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/received_msg_processor.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/interface_controller_in.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/hostaddress.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/fsm_msg_create_2.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/fix_engine.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/create_message.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/connection_toe.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/checksum.sv}
vlog -sv -work work +incdir+/home/adil/fix_engine/fix_parser/quartus/version2 {/home/adil/fix_engine/fix_parser/quartus/version2/bodylength.sv}

