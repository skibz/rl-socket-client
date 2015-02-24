net = require('net')
readline = require('readline')
{EventEmitter} = require('events')

module.exports = class RLSocketClient extends EventEmitter

  socket = new net.Socket()
  socket.setNoDelay(true)

  socket
    .on 'lookup', (err, address, family) ->
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
    .on 'end', ->
      console.log('CONNECTION CLOSED')

  rl = readline.createInterface(
    input: process.stdin
    output: process.stdout
  )
  
  constructor: (opts) ->
    @host = opts.host ? null
    @port = opts.port ? null
    @prompt = opts.prompt ? '> '
    @lineEnding = opts.lineEnding ? '\r\n'
    @autoConnect = opts.autoConnect ? false

    unless @host and @port
      throw new Error('A socket host and port are required.')

    rl.setPrompt(@prompt)

    rl
      .on 'SIGINT', ->
        rl.question 'Really quit? (y/n) ', (res) ->
          return rl.prompt() if (res is 'n')
          rl.close()
          socket.end()
      .on 'SIGCONT', ->
        rl.prompt()
      .on 'line', (text) =>
        socket.write("#{text}#{@lineEnding}")

    @connect() if @autoConnect

  connect: =>
    socket.connect @port, @host, =>
      console.log('ESTABLISHED CONNECTION to %s:%d', @host, @port)
      rl.prompt()
      @emit('connected')
      return @

  write: (text) =>
    socket.write("#{text}#{@lineEnding}")
    return @
