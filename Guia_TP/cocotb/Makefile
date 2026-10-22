SIM ?= icarus
TOPLEVEL_LANG ?= verilog

HDL_DIR := $(abspath ../MYS_CESE/MYS_CESE.srcs/sources_1/new)

VERILOG_SOURCES := $(sort $(wildcard $(HDL_DIR)/*.v))

TOPLEVEL ?= contador_bcd_1_seg
MODULE ?= test_contador_bcd_1_seg
SIM_BUILD ?= sim_build/$(TOPLEVEL)

COMPILE_ARGS += -g2012
COMPILE_ARGS += $(foreach parameter,$(PARAMETERS),-P$(TOPLEVEL).$(parameter))

.PHONY: run prepare

run: prepare
	$(MAKE) sim

prepare:
	mkdir -p waveforms

include $(shell cocotb-config --makefiles)/Makefile.sim
