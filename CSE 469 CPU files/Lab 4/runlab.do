# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.

vlog "./alu.sv"
vlog "./bitAddSub64.sv"
vlog "./control.sv"
vlog "./datamem.sv"
vlog "./decoders.sv"
vlog "./EX.sv"
vlog "./flagSetter.sv"
vlog "./forwarding_unit.sv"
vlog "./IF.sv"
vlog "./instructmem.sv"
vlog "./math.sv"
vlog "./MEM.sv"
vlog "./mux_32_1.sv"
vlog "./mux_64x32_1.sv"
vlog "./Pipelined_CPU.sv"
vlog "./register.sv"
vlog "./regfile.sv"
vlog "./RF.sv"
vlog "./zeroChecker.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work Pipelined_CPU_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do Pipelined_CPU_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
