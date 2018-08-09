
s.waitForBoot( action: {

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

}.fork);