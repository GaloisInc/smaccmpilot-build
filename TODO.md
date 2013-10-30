# TODO

## Pat

- tower/AADL high priority:
    - unified solution for stable, unique names:
        - create a uniqueness checker to give warnings during aadl output
          rather than the long feedback cycle through the RC aadl toolchain
        - use human-provided names without automatic uniqueness when
          possible and punt the bad names back to the user
        - smaccmpilot parameter code needs to somehow generate meaningful
          names. (Should I ask James to look at this, or figure it out myself?)
    - generate SMACCM\_SYS property set
        - need someone to send me the canonical version

- smaccm-sik:
    - document issues:
        - we may be close to solving the no-traffic hang, if its related
          to buffering
        - tdm loop hang is 'solved' by watchdog
    - flow control: any changes to radio firmware needed for full info?

- smaccm-gcs-gateway:
    - go back to using pipes
    - smaccm-SiK reporting: another socket? just stderr?
    - link managment
        - pack multiple mavlink packets into crypto frame
        - flow control

- onboard datalink:
    - check radio-status decode for bugs
    - flow control: integrate stream rate scheduler with radio-status
    - pack multiple mavlink packets into crypto frame

- tower/AADL lower priority:
    - make sure AADL target is part of jenkins build
    - arbitrary AADL properties per Tower node
    - AADL property output for extern (e.g. apm blob) required semaphores,
      task entrypoints.
        - what is the syntax for this?
        - should I do this, or just leave it to Mike?

- apm blob should be ready for others to work with.
    - echronos hookup for the isrs:
        - I2C: i2c2
        - SPI: just spi1
        - narrow down exactly which timers are needed?
    - can we get rid of eeprom? not going to worry about now

- After Nov 31 Drop:
    - test GPS code moving around outdoors, check dop / valid fix threshold
    - test AHRS with GPS integration: spot check? compare to ArduCopter?

## James

- check to make sure HIL flying properly

- altitude hold / throttle controller
- upgrade stabilization loop to arducopter 2.9 (or is 3.x different, improved?)

- flight tuning 3dr quad
    - need to create wiring harness for the Galois 3dr quad

## Lee

- fix the model checker timeouts (program under test is too big now!)
- fact check & update smaccmpilot.org
- RV task for commsec messages
- Add requires filtering in QuickCheck generation?
- Ivory model-checker

## Tom

- commsec documentation (specification)
    - including keying arrangement for wider adoption

## Anyone

- sensor fusion: inertial sensors with position (APM calls this AP_InertialNav)
- loiter position hold controller
- mavlink command to set target position (APM calls this guided mode)

# Longer term issues:

- nonvolatile memory backing for parameter code. Probably best to wait until
  a pure ivory/tower impl of EEPROM/FRAM storage so we don't do the same work
  twice

- smaccmpilot.org software documentation
    - latest work on standalone_apahrs, tower, parameters, datalink, etc etc
    - give it a twice over before Jan 14 PI meeting but just let it decay in the meantime

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

