
# TODO

## Drivers

- fmu 2.4 sensors
    - power managment: report faults
    - px4io interface
    - tri-color led (i2c)
    - lg3d20h (spi) - optional

## Application code

- unified driver test app
    - output sensor readings, ppm
    - send motor outputs from input

- mavlink unit tests

- flight subsystem moved to tower 9
    - unit tests
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

