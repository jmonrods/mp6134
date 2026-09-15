SHELL := /bin/bash
.ONESHELL:

PROJECT_ROOT := $(abspath $(CURDIR)/../..)
RTL := $(PROJECT_ROOT)/rtl

# single-cycle riscv cpu
cpu: clean
	source $(PROJECT_ROOT)/tools/questa/setup.sh
	vlib work
	vmap work work
	vlog -sv $(RTL)/cpu_tb.sv $(RTL)/cpu.sv $(RTL)/alu.sv
	vsim -c work.cpu_tb -do "run -all; quit -f;"

# sudoku
sudoku: clean
	source $(PROJECT_ROOT)/tools/questa/setup.sh
	vlib work
	vmap work work
	vlog -sv $(PROJECT_ROOT)/examples/sudoku_solver.sv
	vsim -c work.sudoku_solver -do "run -all; quit -f;"

# gaussian
gaussian: clean
	source $(PROJECT_ROOT)/tools/questa/setup.sh
	vlib work
	vmap work work
	vlog -sv $(PROJECT_ROOT)/examples/dist_gaussian.sv
	vsim -c work.dist_gaussian -do "run -all; quit -f;"

# tstudent
tstudent: clean
	source $(PROJECT_ROOT)/tools/questa/setup.sh
	vlib work
	vmap work work
	vlog -sv $(PROJECT_ROOT)/examples/dist_t_student.sv
	vsim -c work.dist_t_student -do "run -all; quit -f;"

# chisquare
chisquare: clean
	source $(PROJECT_ROOT)/tools/questa/setup.sh
	vlib work
	vmap work work
	vlog -sv $(PROJECT_ROOT)/examples/dist_chi_square.sv
	vsim -c work.dist_chi_square -do "run -all; quit -f;"

# clean: removes output files
clean:
	rm ./vsim.wlf -f
	rm ./vsim.dbg -f
	rm ./modelsim.ini -f
	rm ./coverage.ucdb -f
	rm ./coverage.txt -f
	rm ./work/ -rf
	rm ./transcript -f


