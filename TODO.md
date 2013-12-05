# TODO

## Pat

### Priority

- Documentation
    - todo:
        - Defined behaviors of GCS MAVLink protocol

    - refactoring:
        - software/flight-components.md needs some content, diagram
        - software/gcs.md could probably use a diagram or two
        - software/gcs-gamepad.md sharley making a diagram

    - hardware pages need content:
        - rc controller taranis
        - check d4r-ii ppm behavior
        - add rc controllers to sidebar when complete

- Flight Behavior Changes:
    - armed means idle motor outputs: sensible safe default
    - flightmode refactored into fields:
        - armed              ::= safe | disarmed | armed
        - stabilizer control ::= ppm  | mavlink  | auto
        - throttle control   ::= ppm  | autothrottle
        - autothrottle ctl   ::= ppm  | mavlink  | auto

- GPS position hold
    - GPS check dop / valid fix threshold
    - AHRS with GPS integration: spot check? compare perf to ArduCopter?
    - accelerometer, gyro, magnetometer calibration needs to be improved,
    - Build position/velocity estimator using GPS position, GPS velocity,
      accelerometer
    - control velocity via stabilizer user input, control position with velocity

- tower/AADL high priority:
    - unified solution for stable, unique names: part done
        - create a uniqueness checker to give warnings during aadl output
          rather than the long feedback cycle through the RC aadl toolchain
        - use human-provided names without automatic uniqueness when
          possible and punt the bad names back to the user
        - smaccmpilot parameter code needs to somehow generate meaningful
          names. (Should I ask James to look at this, or figure it out myself?)
    - generate SMACCM\_SYS property set
        - need someone to send me the canonical version

### When Time Permits

- smaccm-sik:
    - flow control: any changes to radio firmware needed for full info?
    - can no longer reproduce TDM hang or no-traffic hang on a single set of
      radios with frequency hopping turned off
    - tdm loop hang is 'solved' by watchdog

- onboard datalink:
    - flow control: integrate stream rate scheduler with radio-status - slow
      down stream rates if packet loss is high

- smaccm-gcs-gateway:
    - link management / flow control
    - go back to using pipes ??


- tower/AADL unknown priority:
    - AADL property output for extern (e.g. apm blob) required semaphores,
      task entrypoints.
        - what is the syntax for this?
        - should I do this, or just leave it to Mike?


- mavelous:
    - why is pfd altitude tape borked?
    - radio reporting
    - flight mode reporting
    - arm/disarm, flight mode change


## James


## Lee

- By Nov. drop
    - soft vs. hard realtime for heartbeats in GCS?
    - code review of commsec
    - documentation update

- By demo
    - RV task for commsec messages
    - Ivory model-checker

- When there's time
    - fix the model checker timeouts (program under test is too big now!)

## Tom

- commsec documentation (specification)
    - including keying arrangement for wider adoption

## Anyone

- loiter position hold controller
- mavlink command to set target position (APM calls this guided mode)

# Longer term issues:

- Ivory lang bit packing primitives:
    - needs either packing/unpacking as a primitive
    - or some sort of complement cast for transforming UintN <-> SintN bitwise
    - Also need a way to marshal floats & doubles to/fro bytes without the FFI
    - once done, replace ugly code in device drivers, ffi code in mavlink

- nonvolatile memory backing for parameter code. Probably best to wait until
  a pure ivory/tower impl of EEPROM/FRAM storage so we don't do the same work
  twice

- haddock documentation:
    - tower
    - various smaccmpilot libraries
    - gcs code
    - smaccmpilot app

- better grouping of related tasks/comm primitives at the tower level
    - graphviz of the big smaccmpilot app is stumbling towards uselessness
    - internally, change to trees instead of lists of Nodes/dataports/channels

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

