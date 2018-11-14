// the example synth that will be controlled. note the standardized arguments: amp, freq, trig

s.options.memSize = 8192 * 8; // adjust multiplier to increase memory, just guessing on number

s.latency= 0.05;

s.waitForBoot{

//control bus
~sens1 = Bus.control(s, 1).set(0.0);

SynthDef( \sin, { | amp = 0.0, dur = 4, freq = 200, out = 0, trig = 0 |
	var env, sig, finalSig;
	env = EnvGen.kr( Env.linen( 0.001, dur, 0.1 ), trig, doneAction: 2 );
	sig = SinOsc.ar( freq * IRand( 1, 7), SinOsc.kr(0.2), amp );
	finalSig = sig * env * 0.6;
	Out.ar( out, Pan2.ar(finalSig) );
}).add;


// receive messages from another computer to change Synth at ~x

OSCdef(\listener, { | msg |
	switch( msg[1],
			'play', {
				var val;
				val = msg[3].linlin(0.0, 1.0, 200, 400);
				("freq is " + val).postln;
				~sens1.set(val);
				Synth( \sin, [ \amp, 0.8, \trig, 1, \freq, ~sens1.asMap, \dur, 10 ]);
			},
			'wobble', {
				var val;
				val = msg[2].linlin(0.0, 1.0, 200, 400);
				// ("freq is " + val).postln;
				~sens1.set(val);
		});
}, '/control');

"READY!".postln;


}
