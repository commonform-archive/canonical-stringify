inOrder = a: 1, b: 2
outOfOrder = b: 2, a: 1

describe 'canonical stringify', ->
  it 'round trips', ->
    canonical = canonicalStringify inOrder
    builtIn = JSON.stringify inOrder
    expected = JSON.parse builtIn
    JSON.parse(canonical).should.eql expected

  it 'serializes keys in consistent order', ->
    expected = canonicalStringify(outOfOrder)
    canonicalStringify(inOrder).should.eql expected
