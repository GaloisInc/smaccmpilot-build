# [SMACCMPilot Build][smaccmpilotbuild]

An umbrella repository which organizes all of the dependencies required to build
the SMACCMPilot project.

## Contents

This repository is a convenient way to fetch the several git repositories
required to build SMACCMPilot, via the git submodule system
To fetch the submodules after cloning, run

```
        git submodule init
        git submodule update
```

## FreeRTOS

For convenience, the sources from the FreeRTOS project required to build for the
ARM-CortexM4 microcontroller with the GCC toolchain are included.

## Copyright and License

This repository contains sources from the FreeRTOS project. The license file may
be found at `FreeRTOS/FreeRTOS/License/license.txt`

For all submodules, consult the information in that repository.


[smaccmpilotbuild]: http://github.com/GaloisInc/smaccmpilot-build

