/*
loop_one.scd
Casey Anderson, 2018

quick and dirty example for looping a sound file forever

TODO:
* make a way to specify filepath for sample when launching script

*/

s.latency= 0.05;

s.waitForBoot{

	SynthDef(\play, { | amp = 0.0, buf= 0, trig = 0 |
		var env, sig;

		env = EnvGen.kr( Env.asr( 0.0, 0.95, 0.05), trig,  doneAction: 0 );
		sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf), loop: 1) * env;
		Out.ar(0, sig);
	}).add;

	s.sync;
	// setup buffer

	~buf = Buffer.read( s, "/home/pi/frogs.wav");

	s.sync;

	// run the synth

	Synth.new(\play, [\amp, 0.9, \buf, ~buf, \trig, 1]);

};
