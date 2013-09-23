# TODO

## Pat

- 3dr radio firmware: mostly fixed, need to add fast signal strength
  getters and integrate with SMACCMPilot.Flight.Datalink.
- hil sim as a one-click checked into src/gcs/mavlink
- tower haddock documentation

## James

- Get parameter code into master w/o nonvolatile memory backing
- Tune stabilize loops for the big ArduCopter frame, notify
  red team so they can test their vehicle with FMU17+PWM out

## Lee

- Commsec into master

## Everyone

- Implement APMCopter's alt hold, loiter, guided mode in Ivory
  - Leonard will probably be available to give a hand with high level spec
    during week of Sept 30.

# Longer term issues:

- nonvolatile memory backing for parameter code. Probably best to wait until
  a pure ivory/tower impl of EEPROM/FRAM storage so we don't do the same work
  twice

- Commsec adoption in community. Will require:
    - documentation (specification)
    - a port to PX4 Stack (C) and new APM Planner (QT/C++) as an optional
      feature (enabled by default, hopefully)
    - keying story, and ship with default keys
    - any remaining concerns from Lorenz and Tridge?
    - finishing hx framed 3DR Radio firmware would be gravy

- we don't have a story for CI testing with HIL. Will this become enough of a
  pain point to warrant some sort of automatic testing?

- smaccmpilot.org software documentation
    - latest work on standalone_apahrs, tower, parameters, datalink, etc etc
    - give it a twice over before Jan 14 PI meeting but just let it decay in the meantime

- try new cabal sandboxes and/or create a build system that doesn't Suck The Joy
  Out of Developing Haskell (TM)

## Pixhawk HW platform
- separate sensor IO from AP_AHRS sensor fusion; elimintate AP_HAL completely from AP_AHRS
    - AP_Scheduler depends on gnarly HWF4 timer code, which is also directly
      connected to RCInput ppm timer. So, first move that functionality out
      to ivory-px4-hardware / ivory-stm32f4-bsp, get rid of userinput_capture
    - Finish I2C driver in ivory-stm32f4-bsp
    - Rewrite all FMU17 uses of hwf4 SPI and I2C in terms of
      ivory-stm32f4-bsp, as general-purpose library code in ivory-px4-hardware
- implement sensor IO in Ivory for Pixhawk, port exisiting ppm/pwm code

# Goals

- Ivory and Tower should Help A Lot Of People

