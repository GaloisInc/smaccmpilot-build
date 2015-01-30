
# TODO

## Drivers

- fix CAN driver, can examples
- ppm in driver
- fix copter motor drivers

- F427 peripherals
- fmu 2.4 sensors
    - basic platform bringup (vector, linker script)
    - todo:
        - power managment: turn on power busses, report faults
        - lsm303d (spi)
        - lg3d20h (spi) - optional
        - ms5611  (spi)
        - px4io interface
    - untested:
        - mpu6k (spi)

- ms5611 calibration application needs to be written & tested

## Application code

- unified driver test app
    - output sensor readings, ppm
    - send motor outputs from input

- mavlink unit tests

- flight subsystem unit tests
  - sensor fusion only
  - user input only

# optional / later

- F103 peripheral drivers
- CortexM3 support from FreeRTOS & build system
- fmu 2.4 io
    - basic platform bringup (vector, linker script)
    - ivory-bsp-stm32 generalized where possible
    - gpio
    - ppm in
    - pwm out
    - uart
    - px4fmu interface

