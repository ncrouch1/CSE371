transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/noah-/Documents/CSE371/lab6 {C:/Users/noah-/Documents/CSE371/lab6/rom.v}
vlog -sv -work work +incdir+C:/Users/noah-/Documents/CSE371/lab6 {C:/Users/noah-/Documents/CSE371/lab6/input_handler.sv}
vlog -sv -work work +incdir+C:/Users/noah-/Documents/CSE371/lab6 {C:/Users/noah-/Documents/CSE371/lab6/input_datapath.sv}
vlog -sv -work work +incdir+C:/Users/noah-/Documents/CSE371/lab6 {C:/Users/noah-/Documents/CSE371/lab6/input_controller.sv}
vlog -sv -work work +incdir+C:/Users/noah-/Documents/CSE371/lab6 {C:/Users/noah-/Documents/CSE371/lab6/address_decoder.sv}
vlog -sv -work work +incdir+C:/Users/noah-/Documents/CSE371/lab6 {C:/Users/noah-/Documents/CSE371/lab6/validate_move.sv}
vlog -sv -work work +incdir+C:/Users/noah-/Documents/CSE371/lab6 {C:/Users/noah-/Documents/CSE371/lab6/set_move.sv}

