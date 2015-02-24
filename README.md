# rl-socket-client, the readline socket client

we ought to just pretend it stands for rocketlauncher-socket-client. that's way cooler, right?

this module was designed for applications requiring a tty context along-side a tcp socket context (a tcp chat client, for instance)

##### usage

```js
var rlsc = require('rl-socket-client');

new rlsc({
    host: '192.168.128.100',
    port: 3000,
    prompt: '% ',
    lineEnding: '\n',
    autoConnect: true
});
```
