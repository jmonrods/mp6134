set_app_var enable_lint true
read_file -format sverilog -top alu ../../rtl/alu.sv
check_lint
report_lint -verbose
