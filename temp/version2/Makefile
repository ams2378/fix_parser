INCLUDE= defines.vh
SRC=received_msg_processor.v session_manager.v create_message.v fsm_msg_create_2.v counter.v sequence_generator.v

all: 
	make src  
src:
	vlog $(INCLUDE) $(SRC)

clean:
	rm -rf work
