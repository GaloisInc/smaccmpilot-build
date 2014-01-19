# TODO

## Pat

### Priority

- Documentation
    - software/flight-components.md needs some content, finish up diagram
    - add gamepad diagram
    - go through and audit broken markdown links
    - hardware pages need content:
        - rc controller taranis
        - check d4r-ii ppm behavior
        - add rc controllers to sidebar when complete
    - check & push tom's commsec documentation

    - params
    - navigation
    - gamepad button functionality

### When Time Permits

- fixups:
    - datalink: radio_stat is total nonsense, either fix it or remove it

- params:
    - platform polymorphic defaults


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
    - set MAVLink message stream rates separately

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

## Lee

- for demo:
    - RV task for commsec messages
    - Ivory model-checker
    - Audit Frama-c (potential) bugs

- Ivory issues (w/ help from Trevor)
    - Fix naming soundness issue (Template Haskell)
    - Insert checks for left/right shifts

- Ivory paper
    - Define semantics


# Longer term issues:
- Haskell Mavlink generator.
  - Use it for current messages (e.g., GCS Radio).

- Ivory lang bit packing primitives:
    - needs either packing/unpacking as a primitive
    - or some sort of complement cast for transforming UintN <-> SintN bitwise
    - Also need a way to marshal floats & doubles to/fro bytes without the FFI
    - once done, replace ugly code in device drivers, ffi code in mavlink

- lang/bitdata bug in SPI code
    - not used by flight code yet
    - not obviously user error, is the lang doing something wrong here?

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
- PX4IOv2 driver for IO expansion
    - when time permits, rewrite IOv2 SW in Ivory too
