SHELL := /bin/bash
.ONESHELL:

PROJECT_ROOT := $(abspath $(CURDIR)/../..)
RTL := $(PROJECT_ROOT)/rtl
UVM := $(PROJECT_ROOT)/uvm

lint:
	source $(PROJECT_ROOT)/tools/vc_static/setup.sh
	mkdir -p work
	vc_static_shell -f vc_static.tcl -batch

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
