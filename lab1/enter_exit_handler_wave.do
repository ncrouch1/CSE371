onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /enter_exit_handler_tb/dut/HEXD0
add wave -noupdate /enter_exit_handler_tb/dut/HEXD1
add wave -noupdate /enter_exit_handler_tb/dut/HEXD2
add wave -noupdate /enter_exit_handler_tb/dut/HEXD3
add wave -noupdate /enter_exit_handler_tb/dut/HEXD4
add wave -noupdate /enter_exit_handler_tb/dut/HEXD5
add wave -noupdate /enter_exit_handler_tb/dut/HEXD6
add wave -noupdate /enter_exit_handler_tb/dut/HEXD7
add wave -noupdate /enter_exit_handler_tb/dut/HEXD8
add wave -noupdate /enter_exit_handler_tb/dut/HEXD9
add wave -noupdate /enter_exit_handler_tb/dut/clk
add wave -noupdate /enter_exit_handler_tb/dut/reset
add wave -noupdate /enter_exit_handler_tb/dut/enter
add wave -noupdate /enter_exit_handler_tb/dut/exit
add wave -noupdate /enter_exit_handler_tb/dut/counterstate
add wave -noupdate /enter_exit_handler_tb/dut/HEX
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {18 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
