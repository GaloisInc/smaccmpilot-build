
# May 2015 Red Team Drop

This is the canonical documentation for the HACMS Phase 2 Red Team Drop from
Galois, as part of the HACMS Air Team.

Please note that http://smaccmpilot.org is unmaintained and very out of date.

## Hardware setup

We expect you to use two Pixhawks for this evaluation. You will also need:
- two USB micro B cables
- one CAN cable. This is a 4-pin df13 connector cable, with the power conductor
  (pin 1, the red wire on 3DR provided cables) cut or removed.
- one USB to serial adapter, with TX, RX, and Ground connected to a 6-pin df13
  connector. On Mac and Linux, we've found that FTDI based USB to serial
  adapters work reliably - others may not.

Pixhawk connector pinouts can be found [on the Pixhawk.org product
page](https://Pixhawk.org/modules/pixhawk).

One Pixhawk is designated the Server. This module will require power provided to
the USB connector, and one end of the CAN cable plugged into the CAN port.

The other Pixhawk is designated the Proxy. This module will require power (USB),
the other end of the CAN cable plugged into the CAN port, and the USB to serial
adapter plugged into the TELEM1 port.

## Software prerequisites

We support Mac (tested with OS X 10.10) and Linux (tested with Ubuntu 14.04
LTS).

Please install the following and put them in your path:
    - [GHC 7.8.4](https://www.haskell.org/ghc/download_ghc_7_8_4)
    - [Cabal 1.20 or higher](https://www.haskell.org/cabal/)
    - [gcc-arm-embedded](https://launchpad.net/gcc-arm-embedded)

Check that each tool is installed:

```
$ ghc --version
The Glorious Glasgow Haskell Compilation System, version 7.8.4
$ cabal --version
cabal-install version 1.22.0.0
using version 1.22.0.0 of the Cabal library
$ arm-none-eabi-gcc --version
arm-none-eabi-gcc (GNU Tools for ARM Embedded Processors) 4.8.4 20140526
(release) [ARM/embedded-4_8-branch revision 211358]
Copyright (C) 2013 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

Your `gcc-arm-embedded` installation may be newer than the example provided
here.

Then update cabal and install the `alex` and `happy` packages:

```
$ cabal update && cabal install alex happy
```

## Software setup

Clone the `smaccmpilot-build` repository, including all submodules, at the
`red-team-may-2015` tag:

```
$ git clone --recursive --branch red-team-may-2015 https://github.com/GaloisInc/smaccmpilot-build
```

Then go to the `smaccm-flight` package:

```
$ cd smaccmpilot-build/smaccmpilot-stm32f4/src/smaccm-flight
```

First, make the `create-sandbox` target to initialize a cabal sandbox and
install all dependencies of the project. This may take a bit of time. You should
only have to do this once after a fresh git clone.

```
$ make create-sandbox
```

When we created the tag, we made sure all of the cabal packages were constrained
so this built, based on the current state of Hackage. However, as new packages
are uploaded to Hackage, our build may break. Please contact us an if you get
any cabal errors while running `make create-sandbox`.

By default, we assume the software is being built for developers who are loading
it to the Pixhawk with a JTAG/SWD debugger. If you are *not* using a JTAG/SWD
debugger, and are instead using the Pixhawk's factory USB bootloader, create a
new file in `smaccm-flight` named `user.conf` containing the following lines:

```
[stm32]
bootloader="px4"
```

Then, you may build all binaries for the Pixhawk using the `test-fmu24` target.

```
$ make test-fmu24
```

Build output will appear in the `platform-fmu24` subdirectory.

## Uploading

If you are using a JTAG/SWD debugger, an ELF image for each application is built
at `platform-fmu24/<app>/image`. Sample instructions on loading such an image
with the Black Magic Probe JTAG/SWD debugger can be found in the [old
SMACCMPilot documentation](http://smaccmpilot.org/hardware/blackmagic.html)

If you are using the factory PX4 Project bootloader, a `.px4` image for each
application is built at `platform-fmu24/<app>/image.px4`. A copy of the PX4
project's firmware upload script, `px_uploader.py`, is also provided in each
app directory. (This upload script requires Python 2.5 or greater, and
`pyserial` python package.)

To use the included uploader, first determine the serial device that the factory
PX4 Project bootloader enumerates when the Pixhawk is connected to your
computer. On the Mac, this is typically `/dev/tty.usbmodem1`. On Linux, this is
typically `/dev/ttyACM0`. This path name is provided as an argument to the
upload application. Depending on your operating system, the path may change each
time you plug the Pixhawk in. You may pass a comma separated list of paths to
the upload application as well, e.g. `/dev/ttyACM0,/dev/ttyACM1,/dev/ttyACM2`.

The PX4 Project bootloader will only run for a short period after the Pixhawk
is powered on via USB. The upload application should be started before plugging
in the Pixhawk's USB cable.

```
$ python platform-fmu24/<app>/px_uploader.py --port <serial port> \
         platform-fmu24/<app>/image.px4
```

## Provided applications

### `comm-only-test`

This application tests the following functionality:

- Serial port datalink with GIDL messaging server. The serial port datalink uses
  the SMACCM commsec layer to encapsulate binary GIDL messages. The GIDl
  messaging server implements all attributes in the `controllable_vehicle_i`
  schema.
- RGB LED control. The Pixhawk's RGB LED (found underneath the ADC port) is
  controlled according to the value of the `rgb_led` GIDL attribute.

See instructions below in the *Communications Client* section on how to connect
a reference GIDL messaging client to the GIDL messaging server over the serial
datalink.

### `can-server-test`

This application tests the following functionality:

- CAN bus datalink with GIDL messaging. The CAN bus datalink is the only
  datalink implemented in this application - the serial port datalink will not
  be functional.
- Inertial sensor drivers. The `accel_output`, `gyro_output`, `mag_output`, and
  `baro_output` GIDL attributes will give the most recent samples polled from the
  Pixhawk sensors.
- RGB LED control, as in the `comm-only-test`.

Upload this application to the Pixhawk described as the Server in the hardware
description above.

### `can-proxy-test`

This application tests the following functionality:

- Serial port datalink. Uses the SMACCM commsec layer to encapsulate binary
  GIDL messages.
- CAN bus datalink. Sends and recieves CAN messages corresponding to those
  recieved and sent, respectively, by the `can-server-test` CAN bus datalink.
- GIDL message proxy between serial port and CAN bus datalinks. Messages valid
  to be sent to a `controllable_vehicle_i` schema are forwarded from the serial
  datalink to the CAN datalink, and messages valid to be recieved from that
  schema are forwarded from the CAN datalink to the serial datalink.

Upload this application to the Pixhawk described as the Proxy in the hardware
description above.


## Communications Client

Change to the `smaccm-comm-client` directory, which is found at
`smaccmpilot-build/smaccmpilot-stm32f4/src/smaccm-comm-client`.

First time after a fresh clone you will need to `make create-sandbox`, as you
did in `smaccm-flight`.

Then, you can use the provided shell script `gcs.sh`. Provide two arguments: the
path of the USB to serial adapter, and the baud rate `115200`.

On the Mac, a USB to serial adapter will typically enuerate two similarly named
devices, `/dev/cu.usbserial-XXXXXXXX`and`/dev/tty.usbserial-XXXXXXXX`. Use the
`/dev/cu.usbserial-XXXXXXX` file handle.

You may optionally pass the `--verbose` option to `gcs.sh` to monitor frames
sent to and from the server (Pixhawk). This option must be provided after the
serial path and baud rate.

SMACCMPilot uses symmetric key authenticating cryptography over the datalink.
Symmetric keys are specified in `smaccm-flight/keys.conf`.  The threat model for
this scheme is such that we assume a new secret pair of keys is created,
compiled into the Pixhawk firmware, and uploaded to the pixhawk for each
deployment, and the Pixhawk is powered on exactly once per deployment. We also
assume the communications client is started exactly once per deployment. If,
during bench evaluation, you restart either the Pixhawk or the communications
client, you will have to restart the other as well in order to restore correct
operation.

The communications client provides no direct user interface. Users may interact
with the commications client using HTTP on port 8080. The communications client
responds to HTTP GET requests at `/controllable_vehicle_i/<attribute>` for all
readable attributes, returning a JSON encoded value, and accepts HTTP POST
requests with a JSON encoded body at the same URL for all writable attributes.

Additionally, a web page based user interface is provided for some subset of the
attributes. You can open `http://localhost:8080/light.html` in a web browser to
control the Pixhawk's RGB LED.

## Communications Schema

The communications schema for SMACCMPilot is defined by a GIDL language
specification at

`smaccmpilot-build/smaccmpilot-stm32f4/src/smaccm-comm-schema/smaccm-comm-schema.gidl`

Specifically, all of the SMACCMPilot applications implement the
`controllable_vehicle_i` interface. This means they understand all of the
attributes (readable, writable, or read-writable values) specified in the
`controllable_vehicle_i` interface, and the `vehicle_i` parent interface.

GIDL streams are currently unused by all SMACCMPilot applications.

GIDL types have a straightforward encoding as Haskell datatypes and newtypes,
which in turn have a straightforward JSON encoding using the Haskell `aeson`
library defaults. In lieu of proper documentation, we recommend just looking at
the result of reading from the API, and POSTing a body that looks just like it.
