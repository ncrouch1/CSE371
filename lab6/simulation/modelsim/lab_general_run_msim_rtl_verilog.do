transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/noah-/Documents/CSE371/lab6 {C:/Users/noah-/Documents/CSE371/lab6/validate_move.sv}

