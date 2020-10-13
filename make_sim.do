vlib work

vlog -sv A5_task.sv
vlog -sv A5_task_tb.sv

vsim -novopt A5_task_tb

add log -r /*
add wave -r *

run -all