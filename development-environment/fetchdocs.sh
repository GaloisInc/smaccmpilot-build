#! /usr/bin/env bash
if [ -d haddocks ]; then
	rm -rf haddocks
fi
vagrant scp :smaccmpilot-build/docs haddocks
if [ -d ivorylang.org ]; then
	rm -rf ivorylang.org
fi
vagrant scp :smaccmpilot-build/ivorylang-org/_site ivorylang.org
if [ -d smaccmpilot.org ]; then
	rm -rf smaccmpilot.org
fi
vagrant scp :smaccmpilot-build/smaccmpilot-org/_site smaccmpilot.org
