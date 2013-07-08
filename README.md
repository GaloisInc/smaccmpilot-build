# [SMACCMPilot Build][smaccmpilotbuild]

An umbrella repository which organizes all of the dependencies required to build
the SMACCMPilot project.

## Prerequisites

A description of required prerequisites [is available on smaccmpilot.org][prereq].

[prereq]: http://smaccmpilot.org/software/prerequisites.html

## Contents

This repository is a convenient way to fetch the several git repositories
required to build SMACCMPilot, via the git submodule system
To fetch the submodules after cloning, run

```
        git submodule init
        git submodule update
```


## Makefile Options

The default make target `all` will build the Ivory compiler, runtime
verification tools, test applications, and the main SMACCMPilot application.

Currently, runtime verification tools are yet not required for the SMACCMPilot
applciation. You can disable building the runtime verification tools by invoking
make with the flag `RTV=0`, e.g.,

```
make RTV=0
```

Most users will not need to modify the Ivory or Tower library code. To speed up
builds where modifications are only made to the application code (i.e. inside
the smaccmpilot-stm32f4 subdirectory) you can invoke make with the flag
`COMPILER=0`, e.g.,

```
make COMPILER=0
```

## FreeRTOS

For convenience, the sources from the FreeRTOS project required to build for the
ARM Cortex-M4 microcontroller with the GCC toolchain are included.

## Copyright and License

This repository contains sources from the FreeRTOS project. The license file may
be found at `FreeRTOS/FreeRTOS/License/license.txt`

For all submodules, consult the information in that repository.

[smaccmpilotbuild]: http://github.com/GaloisInc/smaccmpilot-build

