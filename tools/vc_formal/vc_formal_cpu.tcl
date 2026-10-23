# vc_formal.tcl - FPV Flow via a Top-Level Wrapper
set_app_var fml_mode_on true
set_fml_appmode FPV

# Read a top-level formal harness/wrapper that instantiates both ALUs
read_file -sva -format sverilog -top cpu_tb_top -vcs {../../04-vcf/cpu_behavioral.sv ../../04-vcf/cpu.sv ../../04-vcf/alu.sv ../../04-vcf/cpu_tb_top.sv}

# Set up clock and reset (modify signal names to match your design)
create_clock -period 10 clk
create_reset -sense high rst

# Run formal proof engines
check_fv
report_fv

