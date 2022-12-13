onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label {opcode Type} /CPU_testbench/dut/opcodeType
add wave -noupdate -label Registers -radix decimal -childformat {{{/CPU_testbench/dut/RegisterFile/registerData[31]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[30]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[29]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[28]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[27]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[26]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[25]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[24]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[23]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[22]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[21]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[20]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[19]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[18]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[17]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[16]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[15]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[14]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[13]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[12]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[11]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[10]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[9]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[8]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[7]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[6]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[5]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[4]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[3]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[2]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[1]} -radix decimal} {{/CPU_testbench/dut/RegisterFile/registerData[0]} -radix decimal}} -subitemconfig {{/CPU_testbench/dut/RegisterFile/registerData[31]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[30]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[29]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[28]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[27]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[26]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[25]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[24]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[23]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[22]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[21]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[20]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[19]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[18]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[17]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[16]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[15]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[14]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[13]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[12]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[11]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[10]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[9]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[8]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[7]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[6]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[5]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[4]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[3]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[2]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[1]} {-height 15 -radix decimal} {/CPU_testbench/dut/RegisterFile/registerData[0]} {-height 15 -radix decimal}} /CPU_testbench/dut/RegisterFile/registerData
add wave -noupdate -label Clock /CPU_testbench/dut/clock
add wave -noupdate -label Reset /CPU_testbench/dut/reset
add wave -noupdate /CPU_testbench/dut/opcode
add wave -noupdate /CPU_testbench/dut/Reg2Loc
add wave -noupdate /CPU_testbench/dut/ALUSrc
add wave -noupdate /CPU_testbench/dut/MemToReg
add wave -noupdate /CPU_testbench/dut/ImmSel
add wave -noupdate /CPU_testbench/dut/RegWrite
add wave -noupdate /CPU_testbench/dut/MemWrite
add wave -noupdate /CPU_testbench/dut/BrTaken
add wave -noupdate /CPU_testbench/dut/UncondBr
add wave -noupdate /CPU_testbench/dut/ALUOp
add wave -noupdate -radix decimal /CPU_testbench/dut/CondAddr19
add wave -noupdate -radix decimal /CPU_testbench/dut/BrAddr26
add wave -noupdate -label PC -radix unsigned /CPU_testbench/dut/PC
add wave -noupdate /CPU_testbench/dut/CondAddrExtended
add wave -noupdate /CPU_testbench/dut/BrAddrExtended
add wave -noupdate /CPU_testbench/dut/Address
add wave -noupdate /CPU_testbench/dut/ShiftedAddress
add wave -noupdate /CPU_testbench/dut/NextBranchCount
add wave -noupdate /CPU_testbench/dut/Count
add wave -noupdate -radix unsigned /CPU_testbench/dut/NextAddress
add wave -noupdate /CPU_testbench/dut/DAddrExtended
add wave -noupdate /CPU_testbench/dut/Imm12Extended
add wave -noupdate /CPU_testbench/dut/WriteToReg
add wave -noupdate /CPU_testbench/dut/ALU_B
add wave -noupdate -radix decimal /CPU_testbench/dut/Da
add wave -noupdate -radix decimal /CPU_testbench/dut/Db
add wave -noupdate /CPU_testbench/dut/ImmValue
add wave -noupdate /CPU_testbench/dut/ALUResult
add wave -noupdate /CPU_testbench/dut/Dout
add wave -noupdate -radix decimal /CPU_testbench/dut/DAddr9
add wave -noupdate -radix decimal /CPU_testbench/dut/Imm12
add wave -noupdate -radix unsigned /CPU_testbench/dut/Rd
add wave -noupdate -radix unsigned /CPU_testbench/dut/Rm
add wave -noupdate -radix unsigned /CPU_testbench/dut/Rn
add wave -noupdate -radix unsigned /CPU_testbench/dut/Ab
add wave -noupdate /CPU_testbench/dut/CBZChecker/in
add wave -noupdate /CPU_testbench/dut/CBZChecker/out
add wave -noupdate /CPU_testbench/dut/CBZBranch
add wave -noupdate -label {Zero Flag} /CPU_testbench/dut/zeroFlag
add wave -noupdate -label {Carry Out Flag} /CPU_testbench/dut/carryoutFlag
add wave -noupdate -label {Negative Flag} /CPU_testbench/dut/negativeFlag
add wave -noupdate -label {Overflow Flag} /CPU_testbench/dut/overflowFlag
add wave -noupdate -label {Data Memory} /CPU_testbench/dut/DataMemory/mem
add wave -noupdate /CPU_testbench/dut/instructionMemory/instruction
add wave -noupdate /CPU_testbench/dut/instructionMemory/address
add wave -noupdate /CPU_testbench/dut/register/in
add wave -noupdate /CPU_testbench/dut/instructionMemory/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4450202 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 246
configure wave -valuecolwidth 394
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 1
configure wave -griddelta 80
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {16556373 ps}
