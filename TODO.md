
# TODO

## Build/OS

- SCB, Flash peripherals need register & peripheral defs filled out
- Startup SCB, RCC, Flash initialization code

- generalize STM32F4:
    - F405 peripherals
    - F427 peripherals

- generalize STM32:
    - Common peripheral drivers
    - F103 peripheral drivers
    - F4xx peripheral drivers

- CortexM3 support from FreeRTOS & build system

## Drivers

- fmu 1.7 sensors complete:
    - mpu6k (spi)
    - ms5611 (i2c)
    - hmc5883l (i2c)

- fmu 2.4 sensors
    - basic platform bringup (build/linker scripts)
    - todo:
        - power managment: turn on power busses, report faults
        - lsm303d (spi)
        - lg3d20h (spi) - optional
        - ms5611  (spi)
        - px4io interface
    - untested:
        - mpu6k (spi)

- fmu 2.4 io
    - basic platform bringup (build/linker scripts)
    - ivory-bsp-stm32f4 renamed, generalized where possible
    - gpio
    - ppm in
    - pwm out
    - uart
    - px4fmu interface

- ms5611 calibration application needs to be written & tested

## Application code

- unified driver test app
    - output sensor readings, ppm
    - send motor outputs from input


