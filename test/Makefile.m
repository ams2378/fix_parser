#-----------------------------------------------------------------------------
#                                                                             
#- Title       : RUNSIM.DO
#- Design      : FIX Engine 
#- Author      : Adil Sadik <ams2378@columbia.edu> 
#-
#-----------------------------------------------------------------------------
#-
#- File        : Makefile for simulation 
#- Created     : 
#-
#-----------------------------------------------------------------------------
#-
#-  Description : Compile src code and run sim
#-
#-----------------------------------------------------------------------------

SRC= dut.v 
BENCH= bench.v

FLAGS= -incr

all:
	make config
	make compile
	make run

config:
	vlib work
	vmap work work

compile:
	vlog $(SRC)
	vlog $(FLAGS) $(BENCH)

run:
	vsim -t ps -lib work $(BENCH)
	run -al	
#	vsim -do $(BENCH)

