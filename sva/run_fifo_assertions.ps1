vlib work
vlog -sv fifo_assertions.sv tb_fifo_assertions.sv
vsim -c tb_fifo_assertions -do "run -all; exit"