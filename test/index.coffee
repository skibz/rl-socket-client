{expect} = require('chai')
rlsc = require('../lib')

describe 'rl-socket-client', ->

  describe 'constructor', ->

    it 'should throw an error if the required options are not given', ->

      client = -> new rlsc()
      expect(client).to.throw(Error)

    it 'shoudln\'t throw an error if the required options are given', ->

      client = -> new rlsc(host: 'abc', port: 123)
      expect(client).to.not.throw(Error)
