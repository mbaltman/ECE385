transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Multiplier {C:/Users/megge/Documents/GitHub/ECE385/Multiplier/reg_1.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Multiplier {C:/Users/megge/Documents/GitHub/ECE385/Multiplier/bit_9_adder.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Multiplier {C:/Users/megge/Documents/GitHub/ECE385/Multiplier/Control.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Multiplier {C:/Users/megge/Documents/GitHub/ECE385/Multiplier/Synchronizers.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Multiplier {C:/Users/megge/Documents/GitHub/ECE385/Multiplier/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Multiplier {C:/Users/megge/Documents/GitHub/ECE385/Multiplier/reg_8.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Multiplier {C:/Users/megge/Documents/GitHub/ECE385/Multiplier/Processor.sv}

vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Multiplier {C:/Users/megge/Documents/GitHub/ECE385/Multiplier/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
