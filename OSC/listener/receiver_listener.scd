// listener example

s.latency= 0.05;

s.waitForBoot{

    // receive messages from somewhere else

    OSCdef(\listenerResponder, { | msg |

        msg.postln;

}, '/control');

};
