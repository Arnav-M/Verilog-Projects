onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Pipelined_CPU_testbench/dut/clk
add wave -noupdate /Pipelined_CPU_testbench/dut/reset
add wave -noupdate /Pipelined_CPU_testbench/dut/BrTaken
add wave -noupdate /Pipelined_CPU_testbench/dut/negative
add wave -noupdate /Pipelined_CPU_testbench/dut/zero
add wave -noupdate /Pipelined_CPU_testbench/dut/overflow
add wave -noupdate /Pipelined_CPU_testbench/dut/carry_out
add wave -noupdate /Pipelined_CPU_testbench/dut/Flags
add wave -noupdate /Pipelined_CPU_testbench/dut/stage2/BrTaken
add wave -noupdate -childformat {{{/Pipelined_CPU_testbench/dut/stage2/register/registers[18]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[17]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[16]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[15]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[14]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[11]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[10]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[9]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[8]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[7]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[6]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[5]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[4]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[3]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[2]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[1]} -radix decimal} {{/Pipelined_CPU_testbench/dut/stage2/register/registers[0]} -radix decimal}} -expand -subitemconfig {{/Pipelined_CPU_testbench/dut/stage2/register/registers[18]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[17]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[16]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[15]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[14]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[11]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[10]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[9]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[8]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[7]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[6]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[5]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[4]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[3]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[2]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[1]} {-radix decimal} {/Pipelined_CPU_testbench/dut/stage2/register/registers[0]} {-radix decimal}} /Pipelined_CPU_testbench/dut/stage2/register/registers
add wave -noupdate -radix decimal /Pipelined_CPU_testbench/dut/stage4/mem/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {720402 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1404855 ps} {1662903 ps}
