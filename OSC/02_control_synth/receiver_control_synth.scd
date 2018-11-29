// sin receiver example

s.latency= 0.05;

s.waitForBoot{

    // the example synth that will be controlled. note the standardized arguments: amp, freq, trig

    SynthDef( \sin, { | amp = 0.0, freq = 440, out = 0, trig = 0 |
        var env, sig, finalSig;
        env = EnvGen.kr( Env.asr( 0.001, 0.9, 0.001 ), trig, doneAction: 0 );
        sig = SinOsc.ar( freq, 0.0, amp );
        finalSig = sig * env * 0.6;
        Out.ar( out, Pan2.ar(finalSig) );
    }).add;


    // receive messages from another computer to change Synth at ~x

    OSCdef(\sinResponder, { | msg |

        msg.postln;

        switch( msg[1],
            'run',{
                "starting the synth".postln;
                ~x = Synth( \sin, [ \freq, 400, \amp, 0.8]);
            },
            'play', {
                "play sin".postln;
                ~x.set(\trig, 1);
            },
            'stop', {
                "stop sin".postln;
                ~x.set(\trig, 0);
            },
            'vol', {
                ("vol "++msg[2]).postln;
                ~x.set(\amp, msg[2].asFloat );
        },
            'free', {
                "freeing synth".postln;
                ~x.free;
            });
}, '/control');

};
