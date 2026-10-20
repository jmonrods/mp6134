SHELL := /bin/bash
.ONESHELL:

PROJECT_ROOT := $(abspath $(CURDIR)/../..)
RTL := $(PROJECT_ROOT)/rtl
UVM := $(PROJECT_ROOT)/uvm
VCF := $(PROJECT_ROOT)/vcf

vcf_alu:
	source $(PROJECT_ROOT)/tools/vc_formal/setup.sh
	mkdir -p work
	vcf -verdi -f vc_formal_alu.tcl

vcf_cpu:
	source $(PROJECT_ROOT)/tools/vc_formal/setup.sh
	mkdir -p work
	vcf -verdi -f vc_formal_cpu.tcl

clean:
	rm -rf work
	rm -rf vcst_rtdb
	rm -rf vcst_rtdb.bak
	rm -f novas.conf
	rm -f novas.rc
	rm -f vcst_command.log
	rm -f vcst_session.log
	rm -f vcst_session.log.bak
	rm -f .vcstPref
	rm -f vcf.log
	rm -f vcf.log.bak
	rm -f hector_command.log
	rm -rf .simon.out
	rm -rf verdiLog
	rm -rf *_learn_dir
	rm -rf .certitudeGUI