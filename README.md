## rl-socket-client: the readline socket client

[![Build Status](https://travis-ci.org/io-digital/rl-socket-client.svg)](https://travis-ci.org/io-digital/rl-socket-client)
[![Coverage Status](https://coveralls.io/repos/io-digital/rl-socket-client/badge.svg)](https://coveralls.io/r/io-digital/rl-socket-client)
[![NPM](https://nodei.co/npm/rl-socket-client.png?mini=true)](https://nodei.co/npm/rl-socket-client/)

we ought to just pretend it stands for [rocketlauncher](http://ioquake3.org/wp/wp-content/themes/ioq3-deboy/explodedView.png)-socket-client. that's way cooler, right?

this module was designed for apps that require a basic tty interface for socket programs - a tcp chat client, for instance. it affords tab-completion and a simple api.

#### api

- `#connect()`: initiate a connection to the given `host` and `port`
- `#on(event)`: currently the only event emitted is `connected`
- `#write(text)`: programmatically send `text` over the wire

#### usage

```js
var rlsc = require('rl-socket-client');

new rlsc({
    host: '192.168.128.100',
    port: 1829,
    prompt: '% ',
    lineEnding: '\n',
    connect: true,
    completions: ['ls', 'pwd', 'cat', 'echo']
});

// or

var client = new rlsc({
    host: '192.168.128.100',
    port: 1829
}).connect();

client.on('connected', function() {
    client.write('blah blah...');
});
```
