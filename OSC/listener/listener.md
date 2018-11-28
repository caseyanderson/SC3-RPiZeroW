## listener

### Reference

* [Open Sound Control](http://opensoundcontrol.org/)
* [OSC Communication](http://doc.sccode.org/Guides/OSC_communication.html) (from the SC3 docs)


### Pre-Flight

* [python-osc](): `pip3 install python-osc`


### Open Sound Control

#### Intro

[Open Sound Control](http://opensoundcontrol.org/), frequently referred to simply as `OSC`, is a communication protocol for sending information across a computer network. `OSC` is an incredibly important component of SC, as SC is comprised of two **separate** applications (`sc-synth` and `sc-language`) that communicate with each other over `OSC` via your computer's internal network. Fortunately one can communicate via `OSC` with any other computer on the **same WIFI network** provided we **know that computer's IP Address**. What follows is a brief example of sending a message from one computer to another followed by a quick sound making example.

To receive messages via `OSC` one typically uses one of two `UGens` in `SC`: `OSCdef` or `OSCfunc`. Note that the structure in SC that we looked at extensively last week, the `SynthDef`, has a similar ending to `OSCdef`. In both cases `def` is short for `definition` and refers to the ability to reference the `Synth`, or `OSC`, objects by name. This naming feature is an important tool for our organizational purposes so I strongly urge you to focus on `OSCdef` for all message receiving purposes over a network.


#### OSCdef

```supercollider
OSCdef(\listenerResponder, { | msg, time, addr, recvPort |

  msg.postln;

}, '/control');
```

Above is the basic format for an `OSCdef` (identical to [receiver_listener.scd](OSC/listener/receiver_listener.scd)). Note the following:

* Similar to a `SynthDef`, the first important piece of information we need to give to SC is the name of this `OSCdef`, which must be prepended with a `\`. In this example the name, or definition on the server, of the OSCdef is `\listenerResponder`
* The name of the `OSCdef` is followed by a comma and then a `function block` (remember, anything between `{...}` is a function and we often refer to a complete function as a `block`) which defines what this particular `OSCdef` does when it receives a message. This structure still closely resembles the structure of a `SynthDef`
* Next we define arguments (between bars `||`). The argument to focus on here is `msg`, the others you probably will not need to actively use.
* Currently the only thing that happens in the function block is a `.postln` statement. In other words, all this `OSCdef` does currently is display whatever message it received in the `post` window
* Finally we have the `path`, a symbol that defines the label for this particular message. Here our OSCdef will only respond to messages that begin with `'/control'`. Note that the `path` contains **both** single quotes and a `/`


#### NetAddr

```supercollider
~x = NetAddr("127.0.0.1", 57120);
~x.sendMsg('/control', 'hello!');
```

In the above example I define a `NetAddr`, or a destination computer on the network, and then send a message to it. As I have it above the full message will be: `[ /control, hello! ]` which will be sent to any destination on the same computer (`127.0.0.1` is internal network on the device sending the message) listening for messages that begin with the `/control`.


### send_osc.py

`OSC` is available for a wide range of applications and languages. If one needs to trigger an `OSC` message from a button press, for example, one could do that in `Python` via the `python-osc` module. An example of sending messages from Python to SC can be seen at [send_osc.py](OSC/listener/send_osc.py).


#### run the example

1. make both files executable: `sudo chmod +x send_osc.py receiver_listener.scd`
2. run the SC file (on your laptop)
3. run the Python file (on your RPi): `python3 send_osc.py --ip "LAPTOPIPADDRESS"`

If everything worked properly one should see something like the following in the SC post window:

```supercollider
[ /control, 0.39507311582565 ]
[ /control, 0.070989534258842 ]
[ /control, 0.59285795688629 ]
[ /control, 0.27045303583145 ]
[ /control, 0.6490324139595 ]
[ /control, 0.99734354019165 ]
[ /control, 0.6361175775528 ]
[ /control, 0.43457522988319 ]
[ /control, 0.026228973641992 ]
[ /control, 0.58365857601166 ]
```

Note the following:
* we use `argparse` here to both set defaults as well as provide a command line interface. In this case the arguments are `--ip`, with a default of `127.0.0.1`, and `--port`, with a default of `57120`. If one is sending to a **different** computer one would need to provide that computer's `IP Address` like so: `python3 send_osc.py --ip "IPADDRESS"`
* we create a `upd_client` object, store it at `client`, and then pass the `ip` and `port` for our message destination to it
* finally, a `for` loop is used to send ten random numbers to the destination
