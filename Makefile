# -*- Mode: makefile-gmake; indent-tabs-mode: t; tab-width: 2 -*-
# please use tabs (8 width)

# Set warnings as errors by default.  Modify this in your Config.mk.
# GHC_FLAGS := -Werror

# Optionally includes the following vars:
#   CONFIG_PLATFORMS	: which platform (freertos, echronos, etc) to build
#   DEFAULT_TARGET		: default Makefile target
#   GHC_FLAGS					: GHC flags
#   EXTRA FLAGS				: extra falgs for cabal (e.g., verbose==1)
-include Config.mk

# Set GHC_OPTS if it was defined in Config.mk.
ifeq ($(strip $(GHC_FLAGS)),)
GHC_OPTS =
else
GHC_OPTS = --ghc-options=$(GHC_FLAGS)
endif

#PLATFORMS := px4fmu17_ioar_freertos,px4fmu17_ioar_aadl
PLATFORMS := px4fmu17_ioar_freertos
# Set the PLATFORMS var if it wasn't set in Config.mk.
export CONFIG_PLATFORMS ?= $(PLATFORMS)

# Important: this should be defined with '=', not ':='.  This is because we may
# generate ...smacm-mavlink/smaccm-mavlink.cabal (SMAVLINK_CABAL target), so
# this variable needs to be determined at *use* time.
ALL_CABAL_PKGS = $(shell find . -name "*.cabal" -exec dirname {} \;)

# Set the DEFAULT_BUILD TARGET, if not already assigned.
DEFAULT_TARGET ?= smaccmpilot-all
.PHONY: all
all: $(DEFAULT_TARGET)

include mavlink.mk

smaccmpilot-all: cabal-build c-build

cabal-build: .cabal-sandbox
	cabal sandbox add-source $(ALL_CABAL_PKGS)
	# Make the top-level cabal package.
	cabal install $(GHC_OPTS) $(EXTRA_FLAGS)

.cabal-sandbox: $(MAKEFILE_LIST) $(SMAVLINK_CABAL)
	cabal sandbox init

c-build: cabal-build
	@$(MAKE) -C smaccmpilot-stm32f4 allplatforms

## Cleaning ##########################################################

sandbox-clean: libs-clean
	rm -rf .cabal-sandbox
	find . -name "dist" | xargs rm -rf

libs-clean:
	find . -name "cabal.sandbox.config" | xargs rm -rf

clean:
	$(MAKE) -C smaccmpilot-stm32f4 clean
	@echo "Clean in the top level does not remove your cabal sandbox."
	@echo "If you want to remove your cabal sandbox, use the 'sandbox-clean' target"

