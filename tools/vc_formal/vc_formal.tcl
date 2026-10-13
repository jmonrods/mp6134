# alu_compare.tcl

# Reference: behavioral ALU
proc compile_spec {} {
    create_design -name spec -top alu_behavioral -lang sverilog
    vcs -sverilog ../../rtl/alu_behavioral.sv
    compile_design spec
}

# Implementation: RTL ALU
proc compile_impl {} {
    create_design -name impl -top alu -lang sverilog
    vcs -sverilog ../../rtl/alu.sv
    compile_design impl
}

# Compose and prove
compile_spec
compile_impl
compose
solveNB alu_equiv
listproof
