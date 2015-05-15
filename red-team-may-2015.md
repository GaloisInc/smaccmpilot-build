
# May 2015 Red Team Drop

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
page](https://pixhawk.org/modules/pixhawk).

One pixhawk is designated the Server. This module will require power provided to
the USB connector, and one end of the CAN cable plugged into the CAN port.

The other pixhawk is designated the Proxy. This module will require power (USB),
the other end of the CAN cable plugged into the CAN port, and the USB to serial
adapter plugged into the TELEM1 port.

## Software prerequisites

We support Mac (tested with OS X 10.10) and Linux (tested with Ubuntu 14.04
LTS).

Please install the following and put them in your path:
    - [GHC 7.8.4]()
    - [Cabal 1.20 or higher]()
    - [gcc-arm-embedded](https://launchpad.net/gcc-arm-embedded)

Check that each tool is installed:

```
$ ghc --version
$ cabal --version
$ arm-none-eabi-gcc --version
```

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
it to the pixhawk with a JTAG/SWD debugger. If you are *not* using a JTAG/SWD
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

## Provided applications

### `comm-only-test`

todo

### `can-server-test`

todo

### `can-proxy-test`

todo

## Uploading

todo

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
sent to and from the server (pixhawk). This option must be provided after the
serial path and baud rate.

SMACCMPilot uses symmetric key authenticating cryptography over the datalink.
Symmetric keys are specified in `smaccm-flight/keys.conf`.  The threat model for
this scheme is such that we assume a new secret pair of keys is created,
compiled into the pixhawk firmware, and uploaded to the pixhawk for each
deployment, and the pixhawk is powered on exactly once per deployment. We also
assume the communications client is started exactly once per deployment. If,
during bench evaluation, you restart either the pixhawk or the communications
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
the result of reading from the API, and sending something that looks just like
it back.
