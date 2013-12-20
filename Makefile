# -*- Mode: makefile-gmake; indent-tabs-mode: t; tab-width: 2 -*-
# please use tabs (8 width)

-include Config.mk

PLATFORMS := px4fmu17_ioar_freertos,px4fmu17_ioar_aadl
export CONFIG_PLATFORMS ?= $(PLATFORMS)

ALL_CABAL_PKGS := $(shell find . -name "*.cabal" -exec dirname {} \;)
PACKAGES ?= $(ALL_CABAL_PKGS)

.PHONY: all
all: smaccmpilot-all

include mavlink.mk

# Currently, EXTRA_FLAGS can be -fwerror, passing -Werror to GHC, or -fdebug-qq, to
# debug the quasiquoter.
smaccmpilot-all: .cabal-sandbox
	@cabal install $(EXTRA_FLAGS) $(PACKAGES)
	@$(MAKE) -C smaccmpilot-stm32f4 allplatforms

.cabal-sandbox: $(MAKEFILE_LIST) $(SMAVLINK_CABAL)
	@cabal sandbox init
	@cabal sandbox add-source $(ALL_CABAL_PKGS)

sandbox-clean:
	rm -rf cabal.sandbox.config .cabal-sandbox
	find . -name "dist" | xargs rm -rf

clean:
	$(MAKE) -C smaccmpilot-stm32f4 clean
	@echo "Clean in the top level does not remove your cabal sandbox."
	@echo "If you want to remove your cabal sandbox, use the 'sandbox-clean' target"

