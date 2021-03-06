// the example synth that will be controlled. note the standardized arguments: amp, freq, trig

s.options.memSize = 8192 * 8; // adjust multiplier to increase memory, just guessing on number

s.latency= 0.05;

s.waitForBoot{

SynthDef( \sin, { | amp = 0.0, freq = 100, out = 0, partial = 1, trig = 0, wobble = 0 |
	var env, sig, finalSig;
	env = EnvGen.kr( Env.asr( 0.001, 0.9, 0.1 ), trig, doneAction: 2 );
		sig = SinOsc.ar( freq, SinOsc.kr(wobble), amp );
	finalSig = sig * env * 0.6;
	Out.ar( out, Pan2.ar(finalSig) );
}).add;

s.sync;

x = Synth( \sin, [ \amp, 0.9, \trig, 1, \freq, 200]);

s.sync;

// receive messages from another computer to change Synth at ~x

OSCdef(\sinResponder, { | msg |
	switch( msg[1],
		'wobble', {
		var val = msg[2].linlin(0.0, 1.0, 0.1, 10);
			("wobble "++val).postln;
				x.set(\wobble, val);
		});
}, '/control');

"READY!".postln;


}
