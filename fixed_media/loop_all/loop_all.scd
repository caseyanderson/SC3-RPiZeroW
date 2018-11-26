/*
loop_all.scd
Casey Anderson, 2018

play all files in a directory as one long loop

run the file from inside supercolliderStandaloneRPI1 as follows (edit to suit your needs):

	xvfb-run --auto-servernum ./sclang -a -l ~/supercolliderStandaloneRPI1/sclang.yaml /home/pi/SC3-RPiZeroW/fixed_media/loop_all/loop_all.scd /path/to/the/directory


TODO:
* need a keyboard interrupt of some sort that shuts SC down gracefully
*/


s.options.memSize = 8192 * 4; // adjust multiplier to increase memory

s.latency= 0.05;

s.waitForBoot{

	// setup array of buffers

	var theDir, thePath, bufList;


	// the directory containing all the samples

	theDir = thisProcess.argv[0].asString;


	// make the bufList

	bufList = List.new(0);


	// get the full path name

	thePath = PathName.new(theDir);


	//read each file into a buffer and add it to the bufList

	thePath.filesDo{ |file|

		bufList.add( Buffer.readChannel(s, file.fullPath, channels: 0 ) ); // this is a hack to eliminate accidental stereo buffers

	};

	s.sync;


	// convert bufList to an array called ~buffers

	~buffers = bufList.asArray;


	// the SynthDef //

	SynthDef(\play, { | amp = 0.0, buf, len, start = 0, trig = 1 |
		var env, sig;

		env = EnvGen.kr( Env.linen( 0.0, len, 0.01), trig,  doneAction: 2 );
		sig = PlayBuf.ar(1, buf, BufRateScale.kr( buf ), startPos: (start * BufFrames.kr(buf)), loop: 1) * env;
		Out.ar(0, sig);
}).add;


	// the Pbind

	~sample_player = Pbind(
	    \instrument, \play,
			\buf, Pxrand(~buffers, inf),
			\len, Pfunc { |e|
	      var dur, bDur, rDiv;
	      bDur = e[\buf].duration;
	      rDiv = rrand(2, 10);
	      dur = bDur / rDiv;
	    },
	    \start, Pwhite(0.0, 1.0, inf),
			\delta, Pkey(\len) /*+ Pwhite( 2, 10, inf)*/
	);

	s.sync;


	// run the Pattern!

	~playMe = ~sample_player.play;

	("PLAYING NOW!"++", Server Memory: "++s.options.memSize).postln;

};

/////////

/*
 ~playMe.stop;

// v2

// this way also works and may be more portable in the long-run
(
~sample_player = Pbind(
	\instrument, \play,
 	\buf, Pfunc({ |e| ~buffers.choose }),
 	\len, Pfunc({ |e| e[\buf].numFrames/e[\buf].sampleRate }),
 	\delta, Pkey(\len)
 );
*/
