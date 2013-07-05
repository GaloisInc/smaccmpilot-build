CABAL         := cabal-dev
CABAL_INSTALL := $(CABAL) install --force-reinstalls

# For faster builds when the Ivory/Tower compiler infrastructure has not been
# modified.  Use, e.g.,
#
#    make COMPILER=0
#
ifeq ($(COMPILER),0)
  IVORY_TARGETS :=
  TOWER_TARGETS :=
else
  IVORY_TARGETS := \
		ivory/ivory \
		ivory/ivory-opt \
		ivory/ivory-stdlib \
		ivory/ivory-backend-c \
		ivory/ivory-examples \
		ivory/ivory-bitdata \
		ivory/ivory-hw

	TOWER_TARGETS := \
		tower/ivory-tower \
		tower/ivory-tower-freertos
endif

SMACCMPILOT_TARGETS := \
	smaccmpilot/ivory-bsp-stm32f4 \
	smaccmpilot/ivory-hwf4wrapper \
	smaccmpilot/ivory \
	smaccmpilot/mavlink

IVORY_SUBMODULE					:= ./ivory
TOWER_SUBMODULE					:= ./tower
SMACCMPILOT_SUBMODULE		:= ./smaccmpilot-stm32f4
IVORY_RTV_SUBMODULE			:= ./ivory-rtverification

RTV_PLUGIN := instrument_plugin.so
RTV_PLUGIN_DIR := $(IVORY_RTV_SUBMODULE)/gcc-plugin
RTV_PLUGIN_BUILD := $(SMACCMPILOT_SUBMODULE)/gcc-plugin/$(RTV_PLUGIN)
RTV_TARGETS := ivory-rtv/rtv-lib \
	$(RTV_PLUGIN_BUILD) \
	smaccmpilot/sample-rtv-task

.PHONY: all $(IVORY_TARGETS) $(TOWER_TARGETS) $(SMACCMPILOT_TARGETS)
.PHONY: ivory-rtv/rtv-lib smaccmpilot/sample-rtv-task cbmc-reporter

all: $(SMACCMPILOT_TARGETS) $(TOWER_TARGETS) $(IVORY_TARGETS) cbmc-reporter

################################################################################
# Ivory
ivory/ivory:
	$(CABAL_INSTALL) $(IVORY_SUBMODULE)/ivory

ivory/ivory-opts: ivory/ivory
	$(CABAL_INSTALL) $(IVORY_SUBMODULE)/ivory-opts

ivory/ivory-stdlib: ivory/ivory
	$(CABAL_INSTALL) $(IVORY_SUBMODULE)/ivory-stdlib

ivory/ivory-backend-c: ivory/ivory ivory/ivory-opts
	$(CABAL_INSTALL) $(IVORY_SUBMODULE)/ivory-backend-c

ivory/ivory-examples: ivory/ivory ivory/ivory-opts ivory/ivory-backend-c
	$(CABAL_INSTALL) $(IVORY_SUBMODULE)/ivory-examples

ivory/ivory-bitdata: ivory/ivory-backend-c
	$(CABAL_INSTALL) $(IVORY_SUBMODULE)/ivory-bitdata

ivory/ivory-hw: ivory/ivory-bitdata
	$(CABAL_INSTALL) $(IVORY_SUBMODULE)/ivory-hw

################################################################################
# Tower
tower/ivory-tower: $(IVORY_TARGETS)
	$(CABAL_INSTALL) $(TOWER_SUBMODULE)/ivory-tower

tower/ivory-tower-freertos: $(IVORY_TARGETS) tower/ivory-tower
	$(CABAL_INSTALL) $(TOWER_SUBMODULE)/ivory-tower-freertos

################################################################################
# Model-checking
spreadsheet:
	$(CABAL_INSTALL) ./simple-spreadsheet-tools

cbmc-reporter: spreadsheet
	$(CABAL_INSTALL) ./cbmc-reporter

################################################################################
# SMACCMPilot
smaccmpilot/ivory: $(IVORY_TARGETS) $(TOWER_TARGETS)
smaccmpilot/ivory: smaccmpilot/mavlink smaccmpilot/ivory-hwf4wrapper
	$(CABAL_INSTALL) $(SMACCMPILOT_SUBMODULE)/src/flight

smaccmpilot/mavlink: $(IVORY_TARGETS)
	$(CABAL_INSTALL) $(SMACCMPILOT_SUBMODULE)/src/smaccm-mavlink

smaccmpilot/ivory-bsp-stm32f4: $(IVORY_TARGETS) $(TOWER_TARGETS)
	$(CABAL_INSTALL) $(SMACCMPILOT_SUBMODULE)/src/ivory-bsp-stm32f4

smaccmpilot/ivory-hwf4wrapper: $(IVORY_TARGETS)
	$(CABAL_INSTALL) $(SMACCMPILOT_SUBMODULE)/src/ivory-hwf4wrapper

smaccmpilot/sample-rtv-task: $(IVORY_TARGETS) $(TOWER_TARGETS)
smaccmpilot/sample-rtv-task: ivory-rtv/rtv-lib
	$(CABAL_INSTALL) $(SMACCMPILOT_SUBMODULE)/apps/sample-rtv-task

################################################################################
# Clean
.PHONY: clean
clean:
	rm -rf ./cabal-dev

.PHONY: veryclean
veryclean: clean
	rm -rf $(IVORY_SUBMODULE)/ivory/dist
	rm -rf $(IVORY_SUBMODULE)/ivory-opts/dist
	rm -rf $(IVORY_SUBMODULE)/ivory-stdlib/dist
	rm -rf $(IVORY_SUBMODULE)/ivory-backend-c/dist
	rm -rf $(IVORY_SUBMODULE)/ivory-bitdata/dist
	rm -rf $(IVORY_SUBMODULE)/ivory-hw/dist
	rm -rf $(TOWER_SUBMODULE)/ivory-tower/dist
	rm -rf $(TOWER_SUBMODULE)/ivory-tower-freertos/dist
	rm -rf $(SMACCMPILOT_SUBMODULE)/src/flight/dist
	rm -rf $(SMACCMPILOT_SUBMODULE)/src/smaccm-mavlink/dist
	rm -rf $(SMACCMPILOT_SUBMODULE)/src/bsp/ivory/ivory-bsp-stm32f4/dist
	rm -rf $(SMACCMPILOT_SUBMODULE)/src/bsp/ivory/ivory-bsp-hwf4wrapper/dist
