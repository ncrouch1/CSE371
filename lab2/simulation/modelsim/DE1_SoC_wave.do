onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_tb/dut/HEX0
add wave -noupdate /DE1_SoC_tb/dut/HEX1
add wave -noupdate /DE1_SoC_tb/dut/HEX2
add wave -noupdate /DE1_SoC_tb/dut/HEX3
add wave -noupdate /DE1_SoC_tb/dut/HEX4
add wave -noupdate /DE1_SoC_tb/dut/HEX5
add wave -noupdate /DE1_SoC_tb/dut/LEDR
add wave -noupdate /DE1_SoC_tb/dut/V_GPIO
add wave -noupdate /DE1_SoC_tb/dut/counter
add wave -noupdate /DE1_SoC_tb/dut/HEX2valid
add wave -noupdate /DE1_SoC_tb/dut/HEX3valid
add wave -noupdate /DE1_SoC_tb/dut/read
add wave -noupdate /DE1_SoC_tb/dut/read1
add wave -noupdate /DE1_SoC_tb/dut/read2
add wave -noupdate /DE1_SoC_tb/dut/wrtensplace
add wave -noupdate /DE1_SoC_tb/dut/wronesplace
add wave -noupdate /DE1_SoC_tb/dut/rdtensplace
add wave -noupdate /DE1_SoC_tb/dut/rdonesplace
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1 ns}
