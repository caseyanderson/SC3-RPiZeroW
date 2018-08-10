// loop_all.scd

(
var numChn = 1, theDir, thePath, bufList;

// the directory containing all the samples
theDir = "~/Desktop/uSAMPLES";

// make the bufList
bufList = List.new(0);

thePath = PathName.new(theDir);
thePath.filesDo{ |file|
	file.fullPath.postln;

	bufList.add( Buffer.read(s, file.fullPath ) );


};

~buffers = bufList.asArray;

// check to make sure everything is mono
bufList.size.do({|buf, x|
	if( buf.numChannels != numChn, {
		~buffers.removeAt(x);
		(buf.path++" is not "++numChn++" , removing from ~buffers!").postln;
	});
});

)
