## loop one file forever

### Materials
* laptop (with internet connection)
* Raspberry Pi Zero W (or **RPiZeroW**)
* Sound File (**.wav** or **.aiff**)

### Pre-flight

1. **microSD** card prep
2. build **SC3** for **RPiZeroW** (steps [here](https://github.com/redFrik/supercolliderStandaloneRPI1))


### Sound File

1. Acquire or locate a **.wav** / **.aiff** file (note: SC3 does not support **MP3** because **MP3** is not [free software](https://en.wikipedia.org/wiki/Free_software))
2. From your laptop, and in the **Terminal**, send the file to the **RPiZeroW**: `scp FILENAME.wav pi@HOSTNAME.local:/home/pi`
3. In the **Terminal** `ssh` to your RPi: `ssh pi@HOSTNAME.local`, enter password


### loop_one.scd

```bash
s.options.memSize = 8192 * 4; // adjust multiplier to increase memory

s.latency= 0.05;

s.waitForBoot{

	SynthDef(\play, { | amp = 0.0, buf, trig = 0 |
		var env, sig;

		env = EnvGen.kr( Env.asr( 0.0, 0.95, 0.05), trig,  doneAction: 0 );
		sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf), loop: 1) * env;
		Out.ar(0, sig);
	}).add;

	// setup buffer

	~buf = Buffer.read( s, "/home/pi/samples/frogs_medium.wav");

	// wait for sync message from server

	s.sync;

	// run the synth

	Synth.new(\play, [\amp, 0.9, \buf, ~buf, \trig, 1]);

	("PLAYING NOW!"++", Server Memory: "++s.options.memSize).postln;

};
```
