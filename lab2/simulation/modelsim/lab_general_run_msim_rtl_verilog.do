transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Daddy/Documents/CSE371/lab2 {C:/Users/Daddy/Documents/CSE371/lab2/ram32x3port2.v}
vlog -sv -work work +incdir+C:/Users/Daddy/Documents/CSE371/lab2 {C:/Users/Daddy/Documents/CSE371/lab2/DE1_SoC.sv}
vlog -sv -work work +incdir+C:/Users/Daddy/Documents/CSE371/lab2 {C:/Users/Daddy/Documents/CSE371/lab2/seg7.sv}
vlog -sv -work work +incdir+C:/Users/Daddy/Documents/CSE371/lab2 {C:/Users/Daddy/Documents/CSE371/lab2/task2.sv}
vlog -sv -work work +incdir+C:/Users/Daddy/Documents/CSE371/lab2 {C:/Users/Daddy/Documents/CSE371/lab2/task3.sv}

