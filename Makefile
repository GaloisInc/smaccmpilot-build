

STANDALONE_HADDOCK ?= standalone_haddock
HADDOCK_PKGDB ?= $(PWD)/.cabal-sandbox/x86_64-linux-ghc-7.8.4-packages.conf.d

PACKAGES:= ivory/ivory \
	ivory/ivory-artifact \
	ivory/ivory-backend-c \
	ivory/ivory-eval \
	ivory/ivory-hw \
	ivory/ivory-model-check \
	ivory/ivory-opts \
	ivory/ivory-quickcheck \
	ivory/ivory-serialize \
	ivory/ivory-stdlib \
	tower/tower \
	tower/tower-aadl \
	tower/tower-config \
	tower/tower-hal \
	ivory-tower-posix \
	tower-camkes-odroid \
	ivory-tower-stm32/ivory-bsp-stm32 \
	ivory-tower-stm32/ivory-bsp-tests \
	ivory-tower-stm32/ivory-freertos-bindings \
	ivory-tower-stm32/tower-freertos-stm32 \
	gec \
	smaccmpilot-stm32f4/src/ivory-px4-hw \
	smaccmpilot-stm32f4/src/smaccm-comm-client \
	smaccmpilot-stm32f4/src/smaccm-comm-schema/smaccm-comm-schema-native \
	smaccmpilot-stm32f4/src/smaccm-comm-schema/smaccm-comm-schema-tower \
	smaccmpilot-stm32f4/src/smaccm-commsec \
	smaccmpilot-stm32f4/src/smaccm-datalink \
	smaccmpilot-stm32f4/src/smaccm-flight \
	smaccmpilot-stm32f4/src/smaccm-ins

default:
	make -C smaccmpilot-stm32f4

.PHONY: docs-sandbox
docs-sandbox:
	cabal sandbox init
	echo "documentation: True" >> cabal.sandbox.config
	cabal sandbox add-source $(PACKAGES)
	cabal install $(PACKAGES)

.PHONY: docs
docs:
	$(STANDALONE_HADDOCK) --package-db  $(HADDOCK_PKGDB) -o docs $(PACKAGES)
	tar -cf docs.tar docs/

clean:
	-rm cabal.sandbox.config
	-rm -rf .cabal-sandbox
	-rm -rf dist
