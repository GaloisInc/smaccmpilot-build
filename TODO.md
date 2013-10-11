# TODO

## Pat

- datalink / gcs with sik: debug high loss rates / intermittent operation

- mavlink implementation:
    - check real gps integration

- further checks to make sure HIL flying properly
    - mavelous integration will help here
- test GPS code moving around outdoors, check dop / valid fix threshold
- test AHRS with GPS integration: spot check? compare to ArduCopter?

- test smaccm-SiK performance, look for bugs at high rates
    - once complete, document, send to red team

- ground control station upgrades
    - user input (gamepad)
    - viewer via mavelous
    - arming, mode change via MAVLink command

- tower haddock documentation

## James

- flight mode multiplexer for testing gains, tuning 3dr quad

## Lee

## Anyone

- smaccm-SiK polling & reporting in CommsecServer
- sensor fusion: inertial sensors with position (APM calls this AP_InetialNav)
- upgrade stabilization loop to arducopter 2.9 (or is 3.x different, improved?)
- altitude hold / throttle controller
- loiter position hold controller
- mavlink command to set target position (APM calls this guided mode)

# Longer term issues:

- nonvolatile memory backing for parameter code. Probably best to wait until
  a pure ivory/tower impl of EEPROM/FRAM storage so we don't do the same work
  twice

- Commsec adoption in community. Continue conversations with Nikos and Lorenz
    - documentation (specification)
    - a port to PX4 Stack (C) and new APM Planner (QT/C++) as an optional
      feature (enabled by default, hopefully)
    - keying story, and ship with default keys
    - adopting hx framed 3DR Radio protocol, via smaccm-sik or otherwise?

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

