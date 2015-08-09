# Integrated build instructions

These instructions are to build the integrated demo, including the camera
virtual machine and the commsec "proxy" that takes encrypted queries over serial
from a ground control station, decrypts them, passes them over CAN to the
Pixhawk, and then relays the response.

## Setup

We assume you have Haskell build tools (GHC >= 7.8, and cabal). These
instructions are known to work only on Linux and OSX.

```
> cabal update
> git clone git://github.com/GaloisInc/smaccmpilot-build.git
> cd smaccmpilot-build
> git checkout git checkout origin/feature/tower9
> git submodule init
> git submodule update
> cd smaccmpilot-build/smaccmpilot-stm32f4/src/smaccm-flight
> make create-sandbox
```

## Build the ODROID app

We assume you've already DD'ed a microSD card with the Linux filesystem.

```
> cd smaccmpilot-stm32f4/src/smaccm-flight
> make smaccmpilot-odroid
```

This creates a directory, `smaccmpilot`.

```
> mv smaccmpilot /june-drop-odroid-manifest/apps/smaccmpilot
```

Make sure you have a file `RAMSES_PATH.mk` in
`june-drop-odroid-manifest/apps/` containing

```
RAMSES_PATH=/<ABSOLUTE_PATH>/phase2/ramses-demo
```

where `phase2` is the repo https://github.com/smaccm/phase2

```
> cd june-drop-odroid-manifest/apps/smaccmpilot
> make
```
This creates the Camkes components and should be ready for seL4 build.

```
> cd june-drop-odroid-manifest
```

Add to the Kconfig the app `smaccmpilot` and the lib `libsmaccmpilot`. Make a
defconfig. Remember to turn on Camkes read/write caching to cut down on build
times.

## Build the Pixhawk app

```
> cd smaccmpilot-build/smaccmpilot-stm32f4/src/smaccm-flight
> make platform-fmu24/standalone-flight
```

This creates a directory `platform-fmu24/standalone-flight/`

```
> cd platform-fmu24/standalone-flight/
```

Flash the Pixhawk with the file `image`. Follow instructions here:
<http://smaccmpilot.org/hardware/blackmagic.html>

## Testing

### Wiring

 * CAN connect Pixhawk and Odroid (or proxy Pixhawk)
 * Connect the ODROID telem UART (or proxy Pixhawk's "TELEM 1") to the laptop
 * Usual cables for ODROID console, booting
 * Power the Pixhawk via USB

### Running

You should be able to run the camera VM (get instructions from Rockwell
Collins).

We'll focus here on testing the proxy app:

```
> cd smaccmpilot-build/smaccmpilot-stm32f4/src/smaccm-comm-client
> make create-sandbox
> make
> ./gcs.sh <serial-device (/dev/ttyXXX)> 57600 —verbose
```

Where this is the device connected to the ODROID telem. `gcs.sh` is the ground
control station and will listen to requests over HTTP.

Now browse to <http://127.0.0.1:8080/attitude.html>. You should see a 3D
rendered cube representing the current orientation of your Pixhawk.
However, it will be mostly static until you complete a calibration
procedure.

To calibrate the Pixhawk's sensors, pick up the Pixhawk and spin it
around in every direction you can, including flipping it upside down.
Then set it down and don't move it for a moment.

If you were thorough enough in your Pixhawk-spinning efforts, you should
see the cube snap to a new position, and then follow your movements
faithfully. (Note that each time you power-cycle the Pixhawk, you'll
have to recalibrate it.)

### Manual status requests

The ground control station web UI makes various requests via a RESTful
JSON API, and you can issue the same requests by hand for
troubleshooting.

In a new terminal, run e.g.,

```
curl http://localhost:8080/controllable_vehicle_i/gyro_output
```

You should see output like

{"samplefail":false,"time":{"unTimeMicros":322631000},"initfail":false,"temperature":34.224117,”sample
{"z":-0.9756098,"x":-2.195122,"y":0.42682928}}

(The first query may not succeed---`^C` on curl then try again if so.)

If no output is given in the `curl` terminal, the app is not working.
