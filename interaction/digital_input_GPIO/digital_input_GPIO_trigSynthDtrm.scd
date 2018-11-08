// the example synth that will be controlled. note the standardized arguments: amp, freq, trig

s.latency= 0.05;

s.waitForBoot{

SynthDef( \sin, { | amp = 0.0, dur = 2, freq = 440, max = 900, min = 200, out = 0, trig = 0 |
	var env, sig, finalSig;
	env = EnvGen.kr( Env.linen( 0.001, dur, 0.1 ), trig, doneAction: 2 );
	sig = SinOsc.ar( Rand( min, max), 0.0, amp );
	finalSig = sig * env * 0.6;
	Out.ar( out, Pan2.ar(finalSig) );
}).add;

// receive messages from another computer to change Synth at ~x

OSCdef(\sinResponder, { | msg |
	switch( msg[1],
		'play', {
			"play sin".postln;
			Synth( \sin, [ \amp, 0.8, \dur, 4, \trig, 1]);
		},
		'vol', {
			("vol "++msg[2]).postln;
		});
}, '/control');

"READY!".postln;


}
