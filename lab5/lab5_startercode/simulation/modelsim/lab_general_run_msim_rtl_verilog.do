transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/noah-/Documents/CSE371/lab5/lab5_startercode {C:/Users/noah-/Documents/CSE371/lab5/lab5_startercode/screen_clearer.sv}

