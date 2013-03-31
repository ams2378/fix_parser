vlib work 
vmap work work

vlog dut.v  
vlog -incr bench.v 

vsim -t ps -lib work bench
do waveformat.do   
run -al 
#while {[exa testend_s] == "false"} {run 0.20 ms}
#quit -sim	 
