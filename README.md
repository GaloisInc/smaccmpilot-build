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

See the `development-environment/` directory to set up a [Vagrant][] virtual
machine for building the SMACCMPilot codebase.

## Contents

This repository is a convenient way to fetch the several git repositories
required to build SMACCMPilot, via the git submodule system.
To fetch the submodules after cloning, run

```
        git submodule init
        git submodule update
```

## Copyright and License

For all submodules, consult the information in that repository.

[smaccmpilotbuild]: http://github.com/GaloisInc/smaccmpilot-build

