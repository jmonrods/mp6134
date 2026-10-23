SHELL := /bin/bash
.ONESHELL:

PROJECT_ROOT := $(abspath $(CURDIR)/../..)

# Tutorial 00: directed testbench
cpu_directed: clean
	source $(PROJECT_ROOT)/tools/questa/setup.sh
	vlib work
	vmap work work
	vlog -sv $(PROJECT_ROOT)/00-directed/cpu_tb.sv $(PROJECT_ROOT)/00-directed/cpu.sv $(PROJECT_ROOT)/00-directed/alu.sv
	vsim -c work.cpu_tb -do "run -all; quit -f;"

# Tutorial 01: instruction memory
imem_tb: clean
	source $(PROJECT_ROOT)/tools/questa/setup.sh
	vlib work
	vmap work work
	vlog -sv $(PROJECT_ROOT)/01-randomization/imem_tb.sv $(PROJECT_ROOT)/01-randomization/imem.sv
	vsim -c work.imem_tb -do "run -all; quit -f;"

# Tutorial 01: cpu with random instruction memory and coverage collection
cpu_tutorial01: clean
	source $(PROJECT_ROOT)/tools/questa/setup.sh
	vlib work
	vmap work work
	vlog +cover -sv $(PROJECT_ROOT)/01-randomization/cpu_tb.sv $(PROJECT_ROOT)/01-randomization/cpu.sv $(PROJECT_ROOT)/01-randomization/alu.sv $(PROJECT_ROOT)/01-randomization/imem.sv
	vsim -sv_seed 100 -c -coverage work.cpu_tb -do "coverage save -onexit coverage.ucdb; run -all; quit -f;"
	vcover report coverage.ucdb

# Tutorial 02: cpu with object-oriented programming
cpu_tutorial02: clean
	source $(PROJECT_ROOT)/tools/questa/setup.sh
	vlib work
	vmap work work
	vlog -sv -f $(PROJECT_ROOT)/02-oop/dut.f
	vlog -sv -f $(PROJECT_ROOT)/02-oop/tb.f
	vopt top -o top_optimized +cover=sbfec
	vsim -sv_seed random -c top_optimized -coverage -do "set NoQuitOnFinish 1; onbreak {resume}; log /* -r; run -all; coverage save -onexit coverage.ucdb; quit;"
	#vcover report coverage.ucdb


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


