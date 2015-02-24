net = require('net')
readline = require('readline')

module.exports = class RLSocketClient

  socket = new net.Socket
  rl = readline.createInterface(
    input: process.stdin
    output: process.stdout
  )
  
  constructor: () ->
    @host = opts.host ? null
    @port = opts.port ? NaN
    @prompt = opts.prompt ? '> '
    @lineEnding = opts.lineEnding ? '\r\n'
    @autoConnect = opts.autoConnect ? false

    unless @host and @port
      throw new Error('A socket host and port are required.')

    rl.setPrompt(@prompt)
    rl.on 'SIGINT', ->
      rl.question 'Really quit? (y/n) ', (res) ->
        if (res is 'y')
          rl.close()
          socket.end()
          process.exit(0)
        rl.prompt()
    .on 'SIGCONT', -> rl.prompt()
    .on 'line', (text) -> socket.write("#{text}#{@lineEnding}")
    socket.on 'lookup', (err, address, family) ->
      console.error(err) if (err)
      console.log('SOCKET HOST ADDRESS LOOKUP')
      console.log('HOST ADDRESS', address)
      console.log('HOST FAMILY', family)
    .on 'data', (data) ->
      console.log(data.toString())
      rl.prompt()
    .on 'timeout', ->
      console.log('CONNECTION TIMEOUT')
      socket.end()
    .on 'error', (err) ->
      console.error('CONNECTION ERROR', err)
      socket.destroy()
    .on 'end', -> console.log('CONNECTION CLOSED')

    @connect() if autoConnect

  connect: =>
    socket.connect @port, @host, =>
      console.log('ESTABLISHED CONNECTION to %s:%d', @host, @port)
      rl.prompt()
