# [SMACCMPilot Build][smaccmpilotbuild]

An umbrella repository which organizes all of the submodules for the SMACCMPilot
project, and provides a development environment as a Vagrant VM.

## Information

More information about the SMACCMPilot project on the web at
[smaccmpilot.org][].

Developers are encouraged to [join our mailing list][list] for project
updates.

[smaccmpilot.org]: http://smaccmpilot.org
[list]: http://community.galois.com/mailman/listinfo/smaccmpilot

## Development Environment

See the [`development-environment`][development-environment] directory to set up
a [Vagrant][] virtual machine for building the SMACCMPilot codebase.

[Vagrant]: https://vagrantup.com
[development-environment]: https://github.com/GaloisInc/smaccmpilot-build/tree/master/development-environment

## Submodules

This repository is a convenient way to fetch the several git repositories
required to build SMACCMPilot, via the git submodule system.
To fetch the submodules after cloning, run

```
        git submodule init
        git submodule update
```

The following submodules are included:

------

### [`gec`: Galois Embedded Crypto][gec]

[gec]: https://github.com/GaloisInc/gec

------
### [`gidl`: Galois Interface Description Language][gidl]

[gidl]: https://github.com/GaloisInc/gidl

------
### [`ivory`: Ivory Language][ivory]

[ivory]: https://github.com/GaloisInc/ivory

------
### [`ivory-rtverification`: Ivory Language Runtime Verification][ivory-rtverification]

[ivory-rtverification]: https://github.com/GaloisInc/ivory-rtverification

------
### [`ivory-tower-posix`: Tower backend for Posix][ivory-tower-posix]

[ivory-tower-posix]: https://github.com/GaloisInc/ivory-tower-posix

------
### [`ivory-tower-stm32`: Tower backend for STM32 Microcontroller][ivory-tower-stm32]

[ivory-tower-stm32]: https://github.com/GaloisInc/ivory-tower-stm32

------
### [`smaccmpilot-SiK`: SMACCMPilot-compatible firmware for SiK Radio][smaccmpilot-SiK]

[smaccmpilot-SiK]: https://github.com/GaloisInc/smaccmpilot-SiK

------
### [`tower`: Tower Language][tower]

[tower]: https://github.com/GaloisInc/tower

------
### [`tower-camkes-odroid`: Tower Language backend for SEL4 Camkes with ODroid BSP][tower-camkes-odroid]

[tower-camkes-odroid]: https://github.com/GaloisInc/tower-camkes-odroid

------
## Copyright and License

All Ivory, Tower, and SMACCMPilot code is copyright 2013-2015 [Galois,
Inc.](http://galois.com) and licensed with the BSD 3-Clause License.

For more details, consult the information in each submodule.

[smaccmpilotbuild]: http://github.com/GaloisInc/smaccmpilot-build

## Contributing

This project adheres to the
[Contributor Covenant code of conduct](CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code. Please report unaccpetable
behavior to [smaccm@galois.com](mailto:smaccm@galois.com).

