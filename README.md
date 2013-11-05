# [SMACCMPilot Build][smaccmpilotbuild]

An umbrella repository which organizes all of the dependencies required to build
the SMACCMPilot project.

## Information

More information about the SMACCMPilot project on the web at
[smaccmpilot.org][].

Developers are encouraged to [join our mailing list][list] for project
updates.

[smaccmpilot.org]: http://smaccmpilot.org
[list]: http://community.galois.com/mailman/listinfo/smaccmpilot

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

The default make target will build the Ivory compiler, runtime verification
tools, test applications, and the main SMACCMPilot application.  It will also
run make inside the `smaccmpilot-stm32f4` subdirectory.

## FreeRTOS

For convenience, the sources from the FreeRTOS project required to build for the
ARM Cortex-M4 microcontroller with the GCC toolchain are included.

## Copyright and License

This repository contains sources from the FreeRTOS project. The license file may
be found at `FreeRTOS/FreeRTOS/License/license.txt`

For all submodules, consult the information in that repository.

[smaccmpilotbuild]: http://github.com/GaloisInc/smaccmpilot-build

