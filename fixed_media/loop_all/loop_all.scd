/*
loop_all.scd
Casey Anderson, 2018

play all files in a directory as one long loop

TODO:
* make a way to specify directory path when launching script
* make a routine: 1. scramble ~buffers, 2. play each sample, loop
* need a keyboard interrupt of some sort that shuts SC down gracefully
*/


// s.options.memSize = 8192 * 4; // adjust multiplier to increase memory

// s.latency= 0.05;

(

// setup array of buffers

var numChn = 1, theDir, thePath, bufList;


// the directory containing all the samples

theDir = "~/Desktop/uSAMPLES";


// make the bufList

bufList = List.new(0);


// get the full path name

thePath = PathName.new(theDir);


//read each file into a buffer and add it to the bufList

thePath.filesDo{ |file|

	bufList.add( Buffer.read(s, file.fullPath ) ); // this is a hack to eliminate accidental stereo buffers

};

// convert bufList to an array called ~buffers

~buffers = bufList.asArray;

)


// routine starts here

~buffers = ~buffers.scramble; // reorder samples

