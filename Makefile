# -*- Mode: makefile-gmake; indent-tabs-mode: t; tab-width: 8 -*-
# please use tabs (8 width)

CABAL		:= cabal-dev
CABAL_INSTALL	:= $(CABAL) install --force-reinstalls

################################################################################
# Project directories
IVORY_MODULE		:= ivory
TOWER_MODULE		:= tower
SMACCMPILOT_MODULE	:= smaccmpilot-stm32f4
RTV_MODULE		:= ivory-rtverification
RTV_TASK		:= $(SMACCMPILOT_MODULE)/apps/sample-rtv-task
HXSTREAM                := $(SMACCMPILOT_MODULE)/src/hx-stream
COMMSEC_GCS             := $(SMACCMPILOT_MODULE)/src/gcs
COMMSEC_TEST            := $(SMACCMPILOT_MODULE)/apps/commsec-test
SHARED                  := $(SMACCMPILOT_MODULE)/src/shared
################################################################################
# Target summaries

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
		$(IVORY_MODULE)/ivory \
		$(IVORY_MODULE)/ivory-opt \
		$(IVORY_MODULE)/ivory-stdlib \
		$(IVORY_MODULE)/ivory-backend-c \
		$(IVORY_MODULE)/ivory-backend-aadl \
		$(IVORY_MODULE)/ivory-examples \
		$(IVORY_MODULE)/ivory-bitdata \
		$(IVORY_MODULE)/ivory-hw

  TOWER_TARGETS := \
		$(TOWER_MODULE)/ivory-tower \
		$(TOWER_MODULE)/ivory-tower-freertos \
		$(TOWER_MODULE)/ivory-tower-aadl \
		$(TOWER_MODULE)/ivory-tower-frontend
endif

SMACCMPILOT_TARGETS := \
	$(SMACCMPILOT_MODULE)/src/ivory-bsp-stm32f4 \
	$(SMACCMPILOT_MODULE)/src/ivory-hwf4wrapper \
	$(SMACCMPILOT_MODULE)/src/flight \
	$(SMACCMPILOT_MODULE)/src/ivory-px4-hw \
	$(SMACCMPILOT_MODULE)/src/hx-stream/ivory \
	$(SMACCMPILOT_MODULE)/src/smaccm-mavlink \
	$(SMACCMPILOT_MODULE)/src/shared

# Some systems may not have the correct toolchains available to build the
# runtime verification (RTV) compiler plugin.
# To omit the RTV targets, use
#
#    make RTV=0
#
ifeq ($(RTV),0)
  RTV_TARGETS :=
else
  RTV_TARGETS := \
	$(RTV_MODULE)/rtv-lib \
	$(RTV_MODULE)/rtv-example \
	$(SMACCMPILOT_MODULE)/apps/sample-rtv-task
endif

################################################################################
# Runtime verification synonyms
RTV_PLUGIN		:= instrument_plugin.so
RTV_PLUGIN_AP		:= $(SMACCMPILOT_MODULE)/gcc-plugin/$(RTV_PLUGIN)
################################################################################

.PHONY: \
  all \
  $(SMACCMPILOT_TARGETS) \
  $(IVORY_TARGETS) \
  $(TOWER_TARGETS) \
  simple-spreadsheet-tools \
  cbmc-reporter \
  simple-spreadsheet-tools \
  $(RTV_TARGETS) \
  $(SHARED) \
  $(HXSTREAM)/hs \
  $(HXSTREAM)/ivory \
  $(COMMSEC_GCS) \
  $(COMMSEC_TEST)

all: \
	$(SMACCMPILOT_TARGETS) \
	$(TOWER_TARGETS) \
	$(IVORY_TARGETS) \
	cbmc-reporter \
	$(RTV_TARGETS) \
        $(SHARED) \
        $(HXSTREAM)/hs \
        $(HXSTREAM)/ivory \
        $(COMMSEC_GCS) \
        $(COMMSEC_TEST)

################################################################################
# Ivory
$(IVORY_MODULE)/ivory:
	$(CABAL_INSTALL) $@/

$(IVORY_MODULE)/ivory-opts: $(IVORY_MODULE)/ivory
	$(CABAL_INSTALL) $@/

$(IVORY_MODULE)/ivory-stdlib: $(IVORY_MODULE)/ivory
	$(CABAL_INSTALL) $@/

$(IVORY_MODULE)/ivory-backend-c: $(IVORY_MODULE)/ivory
$(IVORY_MODULE)/ivory-backend-c: $(IVORY_MODULE)/ivory-opts
	$(CABAL_INSTALL) $@/

$(IVORY_MODULE)/ivory-backend-aadl: $(IVORY_MODULE)/ivory
	$(CABAL_INSTALL) $@/

$(IVORY_MODULE)/ivory-examples: $(IVORY_MODULE)/ivory
$(IVORY_MODULE)/ivory-examples: $(IVORY_MODULE)/ivory-opts
$(IVORY_MODULE)/ivory-examples: $(IVORY_MODULE)/ivory-backend-c
	$(CABAL_INSTALL) $@/

$(IVORY_MODULE)/ivory-bitdata: $(IVORY_MODULE)/ivory-backend-c
	$(CABAL_INSTALL) $@/

$(IVORY_MODULE)/ivory-hw: $(IVORY_MODULE)/ivory-bitdata
	$(CABAL_INSTALL) $@/

################################################################################
# Tower
$(TOWER_MODULE)/ivory-tower: $(IVORY_TARGETS)
	$(CABAL_INSTALL) $@/

$(TOWER_MODULE)/ivory-tower-freertos: $(IVORY_TARGETS)
$(TOWER_MODULE)/ivory-tower-freertos: $(TOWER_MODULE)/ivory-tower
	$(CABAL_INSTALL) $@/

$(TOWER_MODULE)/ivory-tower-aadl: $(IVORY_TARGETS)
$(TOWER_MODULE)/ivory-tower-aadl: $(TOWER_MODULE)/ivory-tower
	$(CABAL_INSTALL) $@/

$(TOWER_MODULE)/ivory-tower-frontend: $(IVORY_TARGETS)
$(TOWER_MODULE)/ivory-tower-frontend: $(TOWER_MODULE)/ivory-tower
$(TOWER_MODULE)/ivory-tower-frontend: $(TOWER_MODULE)/ivory-tower-freertos
$(TOWER_MODULE)/ivory-tower-frontend: $(TOWER_MODULE)/ivory-tower-aadl
	$(CABAL_INSTALL) $@/

################################################################################
# Model-checking
simple-spreadsheet-tools:
	$(CABAL_INSTALL) $@/

cbmc-reporter: simple-spreadsheet-tools
	$(CABAL_INSTALL) $@/

################################################################################
# Runtime verification

# Build the gcc plugin.  We'll need to build two versions of the plugin: one
# suitable for testing on your build machine and one suitable for use with the
# arm-gcc cross-compiler.  For the latter, we'll need a 32-bit build.  Your
# machine may be a 64-bit machine.
$(RTV_PLUGIN_AP):
	$(MAKE) -C $(RTV_MODULE)/gcc-plugin clean
	$(MAKE) -C $(RTV_MODULE)/gcc-plugin EXPLICIT32=1
	mkdir -p $(SMACCMPILOT_MODULE)/gcc-plugin
	mv $(RTV_MODULE)/gcc-plugin/$(RTV_PLUGIN) $@

$(RTV_MODULE)/rtv-lib:
	$(CABAL_INSTALL) $@/

$(RTV_MODULE)/rtv-example: $(RTV_MODULE)/rtv-lib
	$(CABAL_INSTALL) $@/

$(RTV_TASK)/instrumented-decls: $(RTV_MODULE)/rtv-lib
	bash $(RTV_MODULE)/rtv-lib/build-tools/find-instrumented.sh \
    $(RTV_TASK) > $@

$(RTV_TASK): $(IVORY_TARGETS) $(TOWER_TARGETS) $(RTV_PLUGIN_AP)
$(RTV_TASK): $(RTV_MODULE)/rtv-lib $(RTV_TASK)/instrumented-decls
	$(CABAL_INSTALL) $@/

################################################################################
# SMACCMPilot

$(SMACCMPILOT_MODULE)/src/smaccm-mavlink: $(IVORY_TARGETS) $(SHARED)
	$(CABAL_INSTALL) $@/

$(SMACCMPILOT_MODULE)/src/ivory-hwf4wrapper: $(IVORY_TARGETS)
	$(CABAL_INSTALL) $@/

$(SMACCMPILOT_MODULE)/src/ivory-bsp-stm32f4: $(IVORY_TARGETS)
$(SMACCMPILOT_MODULE)/src/ivory-bsp-stm32f4: $(TOWER_TARGETS)
	$(CABAL_INSTALL) $@/

$(SMACCMPILOT_MODULE)/src/ivory-px4-hw: $(IVORY_TARGETS) $(TOWER_TARGETS)
$(SMACCMPILOT_MODULE)/src/ivory-px4-hw: $(SMACCMPILOT_MODULE)/src/ivory-bsp-stm32f4
	$(CABAL_INSTALL) $@/

$(SMACCMPILOT_MODULE)/src/flight: $(IVORY_TARGETS) $(TOWER_TARGETS)
$(SMACCMPILOT_MODULE)/src/flight: $(SMACCMPILOT_MODULE)/src/smaccm-mavlink
$(SMACCMPILOT_MODULE)/src/flight: $(SMACCMPILOT_MODULE)/src/ivory-hwf4wrapper
$(SMACCMPILOT_MODULE)/src/flight: $(SMACCMPILOT_MODULE)/src/ivory-bsp-stm32f4
$(SMACCMPILOT_MODULE)/src/flight: $(SMACCMPILOT_MODULE)/src/ivory-px4-hw
$(SMACCMPILOT_MODULE)/src/flight: $(SHARED)
$(SMACCMPILOT_MODULE)/src/flight: $(HXSTREAM)/ivory
	$(CABAL_INSTALL) $@/

################################################################################
# GCS Commsec

$(SHARED): $(IVORY_MODULE)/ivory
	$(CABAL_INSTALL) $@/

$(HXSTREAM)/hs:
	$(CABAL_INSTALL) $@/

$(HXSTREAM)/ivory: $(IVORY_TARGETS)
	$(CABAL_INSTALL) $@/

$(COMMSEC_GCS): $(HXSTREAM)/hs $(SMACCMPILOT_MODULE)/src/smaccm-mavlink $(SHARED)
	$(CABAL_INSTALL) $@/

$(COMMSEC_TEST): $(IVORY_TARGETS)
	$(CABAL_INSTALL) $@/

################################################################################
# Clean
.PHONY: clean
clean:
	rm -rf ./cabal-dev

.PHONY: veryclean
veryclean: clean
	find . -name "dist" | xargs rm -rf
	rm -rf $(RTV_TASK)/instrumented-decls
	rm -rf $(SMACCMPILOT_MODULE)/gcc-plugin


todopreview:
	curl https://api.github.com/markdown/raw \
		-X POST -H "Content-Type: text/x-markdown" \
		--data-binary @TODO.md  > todo.html
