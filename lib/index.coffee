net = require('net')
readline = require('readline')
{EventEmitter} = require('events')

module.exports = class RLSocketClient extends EventEmitter

  rl = null
  socket = null
  
  constructor: (opts) ->
    @host = opts.host ? null
    @port = opts.port ? null
    @prompt = opts.prompt ? '> '
    @lineEnding = opts.lineEnding ? '\r\n'
    @completions = opts.completions ? []
    @autoConnect = opts.connect ? false

    unless @host and @port
      throw new Error('A socket host and port are required.')

    socket = new net.Socket()
    socket.setNoDelay(true)
    
    rl = readline.createInterface(
      input: process.stdin
      output: process.stdout
      completer: (line) =>
        hits = @completions.filter((cmd) -> cmd.indexOf(line) is 0)
        return [hits, line] if hits.length
        return [@completions, line]
    )

    rl.setPrompt(@prompt)

    rl.on('SIGINT', ->
      rl.question('Really quit? (y/n) ', (res) ->
        return rl.prompt() if (res is 'n')
        ((rl.close() and socket.end() and process.exit(0)) or (process.exit(128)))
      )
    ).on('SIGCONT', ->
      rl.prompt()
    ).on('line', (text) =>
      socket.write("#{text}#{@lineEnding}")
    )

    socket.on('lookup', (err, address, family) ->
      console.error(err) if (err)
      console.log('SOCKET HOST ADDRESS LOOKUP')
      console.log('HOST ADDRESS', address)
      console.log('HOST FAMILY', family)
    ).on('data', (data) ->
      console.log(data.toString())
      rl.prompt()
    ).on('timeout', ->
      console.log('CONNECTION TIMEOUT')
      socket.end()
    ).on('error', (err) ->
      console.error('CONNECTION ERROR', err)
      socket.destroy()
    ).on('end', ->
      console.log('CONNECTION CLOSED')
    )

    @connect() if @autoConnect

  connect: =>
    socket.connect(@port, @host, =>
      process.nextTick( => @emit('connected'))
      console.log('ESTABLISHED CONNECTION to %s:%d', @host, @port)
      rl.prompt()
      return @
    )

  write: (text) =>
    console.log(text)
    socket.write("#{text}#{@lineEnding}")
    return @
