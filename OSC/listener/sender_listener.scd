s.boot;

// setup

(
~ip = "";
~x = NetAddr(~ip, 57120);
)


// send a message

~x.sendMsg('/control', 'hello');
