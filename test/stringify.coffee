stringify = require '../canonical-stringify.coffee'

inOrder = a: 1, b: 2
outOfOrder = b: 2, a: 1

describe 'canonical stringify', ->
  it 'round trips', ->
    canonical = stringify inOrder
    builtIn = JSON.stringify inOrder
    JSON.parse(canonical).should.eql(JSON.parse(builtIn))

  it 'serializes keys in consistent order', ->
    stringify(inOrder).should.eql(stringify(outOfOrder))
