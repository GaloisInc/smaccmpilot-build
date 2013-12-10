# -*- Mode: makefile-gmake; indent-tabs-mode: t; tab-width: 8 -*-
# please use tabs (8 width)

# List of top-level packages to install when building the
# entire system.  Dependencies will be automatically installed
# and updated as necessary.
PACKAGES := smaccmpilot smaccm-gcs-gateway ivory-bsp-tests
export CONFIG_PLATFORMS := px4fmu17_ioar_freertos,px4fmu17_ioar_aadl

.PHONY: all
all: smaccmpilot-all

smaccmpilot-all: .cabal-sandbox
	@cabal install $(PACKAGES)
	@$(MAKE) -C smaccmpilot-stm32f4 allplatforms

.cabal-sandbox: $(MAKEFILE_LIST)
	@cabal sandbox init
	@cabal sandbox add-source `find . -name "*.cabal" -exec dirname {} \;`

sandbox-clean:
	rm -rf cabal.sandbox.config .cabal-sandbox
	@find . -name "dist-sandbox-*" | xargs rm -rf

clean:
	@$(MAKE) -C smaccmpilot-stm32f4 clean
	@echo "Clean in the top level does not remove your cabal sandbox."
	@echo "If you want to remove your cabal sandbox, use the 'sandbox-clean' target"
