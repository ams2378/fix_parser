vlib work 
vmap work work

# Include Netlist and Testbench
#vlog -incr /tools2/courses/ee6321/share/ibm13rflpvt/verilog/ibm13rflpvt.v
#vlog dut.v  

make src1
vlog -incr fix_engine.v 

# Run Simulator 
vsim -t ps -lib work fix_engine
do waveformat.do   
run -al
while {[exa testend_s] == "false"} {run 0.20 ms}
#quit -sim	 
