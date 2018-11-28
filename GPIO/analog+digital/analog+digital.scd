// the example synth that will be controlled. note the standardized arguments: amp, freq, trig

s.options.memSize = 8192 * 8; // adjust multiplier to increase memory, just guessing on number

s.latency= 0.05;

s.waitForBoot{

//control bus
~sens1 = Bus.control(s, 1).set(0.0);

SynthDef( \sin, { | amp = 0.0, dur = 4, freq = 200, maxDelay = 2.0, out = 0, trig = 0, wobble = 1 |
		var env, sig, finalSig;
		env = EnvGen.kr( Env.linen( 0.001, dur, 0.1 ), trig, doneAction: 2 );
		sig = SinOsc.ar( freq * IRand( 1, 7), DelayN.ar(SinOsc.kr(wobble), maxDelay, Rand(0.5, maxDelay)), amp );
		finalSig = sig * env * 0.6;
		Out.ar( out, Pan2.ar(finalSig) );
	}).add;


// receive messages from another computer to change Synth at ~x

OSCdef(\listener, { | msg |
	switch( msg[1],
			'play', {
				var val;
				val = msg[3].linlin(0.0, 1.0, 0.1, 15);
				("wobble is " + val).postln;
				~sens1.set(val);
				Synth( \sin, [ \amp, 0.8, \dur, 10, \trig, 1, \wobble, ~sens1.asMap ]);
			},
			'wobble', {
				var val;
				val = msg[2].linlin(0.0, 1.0, 0.01, 10);
				~sens1.set(val);
		});
}, '/control');


"READY!".postln;

}
