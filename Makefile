export PATH := $(shell stack path --local-bin-path):$(PATH)

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

DOCS_STACK          ?= stack --stack-yaml $(PWD)/stack.yaml
DOCS_BIN_PATH       ?= $(shell $(DOCS_STACK) path --bin-path)
DOCS_LOCAL_PKGDB    ?= $(shell $(DOCS_STACK) path --local-pkg-db)
DOCS_SNAPSHOT_PKGDB ?= $(shell $(DOCS_STACK) path --snapshot-pkg-db)

.PHONY: docs
docs:
	$(DOCS_STACK) haddock
	$(DOCS_STACK) install standalone-haddock
	(export PATH=$(DOCS_BIN_PATH); \
	 standalone-haddock --package-db $(LOCAL_PKGDB) \
			    --package-db $(SNAPSHOT_PKGDB) \
			    -o docs $(PACKAGES))
	tar -cf docs.tar docs/
	make -C smaccmpilot-org build
	make -C ivorylang-org build

clean:
	stack clean
