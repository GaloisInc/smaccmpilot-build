
CABAL         := cabal-dev -s $(CURDIR)/cabal-dev
CABAL_INSTALL := $(CABAL) install --force-reinstalls

IVORY_TARGETS := \
	ivory/ivory \
	ivory/ivory-opt \
	ivory/ivory-backend-c \
	ivory/ivory-examples \
	ivory/ivory-bitdata \
	ivory/ivory-hw

IVORY_SUBMODULE := ./ivory

TOWER_TARGETS := \
	tower/ivory-tower \
	tower/ivory-tower-freertos

TOWER_SUBMODULE := ./tower

SMACCMPILOT_TARGETS := \
	smaccmpilot/ivory-bsp-stm32f4 \
	smaccmpilot/ivory-bsp-hwf4wrapper \
	smaccmpilot/ivory \
	smaccmpilot/mavlink

SMACCMPILOT_SUBMODULE := ./smaccmpilot-stm32f4

.PHONY: all $(IVORY_TARGETS) $(TOWER_TARGETS) $(SMACCMPILOT_TARGETS)
all: $(SMACCMPILOT_TARGETS) $(TOWER_TARGETS) 

ivory: $(IVORY_TARGETS)

ivory/ivory:
	$(CABAL_INSTALL) $(IVORY_SUBMODULE)/ivory

ivory/ivory-opts: ivory/ivory
	$(CABAL_INSTALL) $(IVORY_SUBMODULE)/ivory-opts

ivory/ivory-backend-c: ivory/ivory ivory/ivory-opts
	$(CABAL_INSTALL) $(IVORY_SUBMODULE)/ivory-backend-c

ivory/ivory-examples: ivory/ivory ivory/ivory-opts ivory/ivory-backend-c
	$(CABAL_INSTALL) $(IVORY_SUBMODULE)/ivory-examples

ivory/ivory-bitdata: ivory/ivory-backend-c
	$(CABAL_INSTALL) $(IVORY_SUBMODULE)/ivory-bitdata

ivory/ivory-hw: ivory/ivory-bitdata
	$(CABAL_INSTALL) $(IVORY_SUBMODULE)/ivory-hw

tower/ivory-tower: $(IVORY_TARGETS)
	$(CABAL_INSTALL) $(TOWER_SUBMODULE)/ivory-tower

tower/ivory-tower-freertos: $(IVORY_TARGETS) tower/ivory-tower
	$(CABAL_INSTALL) $(TOWER_SUBMODULE)/ivory-tower-freertos

smaccmpilot/ivory: $(IVORY_TARGETS) $(TOWER_TARGETS)
smaccmpilot/ivory: smaccmpilot/mavlink smaccmpilot/ivory-bsp-hwf4wrapper
	$(CABAL_INSTALL) $(SMACCMPILOT_SUBMODULE)/ivory

smaccmpilot/mavlink: $(IVORY_TARGETS)
	$(CABAL_INSTALL) $(SMACCMPILOT_SUBMODULE)/smaccm-mavlink

smaccmpilot/ivory-bsp-stm32f4: $(IVORY_TARGETS)
	$(CABAL_INSTALL) $(SMACCMPILOT_SUBMODULE)/bsp/ivory/ivory-bsp-stm32f4

smaccmpilot/ivory-bsp-hwf4wrapper: $(IVORY_TARGETS)
	$(CABAL_INSTALL) $(SMACCMPILOT_SUBMODULE)/bsp/ivory/ivory-bsp-hwf4wrapper


.PHONY: clean
clean:
	rm -rf ./cabal-dev

.PHONY: veryclean
veryclean: clean
	rm -rf $(IVORY_SUBMODULE)/ivory/dist
	rm -rf $(IVORY_SUBMODULE)/ivory-opts/dist
	rm -rf $(IVORY_SUBMODULE)/ivory-backend-c/dist
	rm -rf $(IVORY_SUBMODULE)/ivory-bitdata/dist
	rm -rf $(IVORY_SUBMODULE)/ivory-hw/dist
	rm -rf $(TOWER_SUBMODULE)/ivory-tower/dist
	rm -rf $(TOWER_SUBMODULE)/ivory-tower-freertos/dist
	rm -rf $(SMACCMPILOT_SUBMODULE)/ivory/dist
	rm -rf $(SMACCMPILOT_SUBMODULE)/smaccm-mavlink/dist
	rm -rf $(SMACCMPILOT_SUBMODULE)/bsp/ivory/ivory-bsp-stm32f4
	rm -rf $(SMACCMPILOT_SUBMODULE)/bsp/ivory/ivory-bsp-hwf4wrapper
