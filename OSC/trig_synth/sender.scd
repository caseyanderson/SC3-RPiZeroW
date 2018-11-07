s.boot;

// setup

(
~ip = "";
~x = NetAddr(~ip, 57120);
)

// sending messages

// make the synth

~x.sendMsg('/control', 'run');

// turn the other computer's sin on

~x.sendMsg('/control', 'play');


// turn the other computer's sin off

~x.sendMsg('/control', 'stop');


// change the other computer's sin's volume (try different numbers between 0.0 and 1.0)

~x.sendMsg('/control', 'vol', 0.99 );
