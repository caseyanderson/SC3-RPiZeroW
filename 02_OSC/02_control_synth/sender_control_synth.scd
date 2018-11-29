s.boot;

// setup

(
~ip = "";
~x = NetAddr(~ip, 57120);
)

// sending messages

// make the synth

~x.sendMsg('/control', 'run');


// turn the synth on

~x.sendMsg('/control', 'play');


// turn the synth off

~x.sendMsg('/control', 'stop');


// change the synth's volume (try different numbers between 0.0 and 1.0)

~x.sendMsg('/control', 'vol', 0.99 );


// free the synth

~x.sendMsg('/control', 'stop');
