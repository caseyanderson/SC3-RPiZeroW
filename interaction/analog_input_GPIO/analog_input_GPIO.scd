// the example synth that will be controlled. note the standardized arguments: amp, freq, trig

s.options.memSize = 8192 * 8; // adjust multiplier to increase memory, just guessing on number

s.latency= 0.05;

s.waitForBoot{

SynthDef( \sin, { | amp = 0.0, freq = 200, out = 0, trig = 0 |
	var env, sig, finalSig;
	env = EnvGen.kr( Env.asr( 0.001, 0.9, 0.1 ), trig, doneAction: 2 );
	sig = SinOsc.ar( freq * IRand( 1, 6), 0.0, amp );
	finalSig = sig * env * 0.6;
	Out.ar( out, Pan2.ar(finalSig) );
}).add;

s.sync;

x = Synth( \sin, [ \amp, 0.3, \trig, 1]);

s.sync;

// receive messages from another computer to change Synth at ~x

OSCdef(\sinResponder, { | msg |
	switch( msg[1],
		'vol', {
			("vol "++msg[2]).postln;
				x.set(\amp, msg[2].asFloat);
		});
}, '/control');

"READY!".postln;


}
