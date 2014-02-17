'use strict'

ESCAPABLE = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g
gap = null
indent = null
META =
  '\b': '\\b'
  '\t': '\\t'
  '\n': '\\n'
  '\f': '\\f'
  '\r': '\\r'
  '"' : '\\"'
  '\\': '\\\\'
rep = null

quote = (string) ->
  ESCAPABLE.lastIndex = 0
  if ESCAPABLE.test(string)
    val = string.replace ESCAPABLE, (a) ->
      c = META[a]
      if typeof c == 'string'
        return c
      else
        return '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4)
    return '"' + val + '"'
  else
    return '"' + string + '"'

str = (key, holder) ->
  mind = gap
  value = holder[key]

  if typeof rep == 'function'
    value = rep.call(holder, key, value)

  switch typeof value
    when 'string' then return quote(value)

    when 'number'
      if isFinite(value)
        return String(value)
      else
        return 'null'

    when 'boolean', 'null' then return String(value)

    when 'object'
      return 'null' if !value

      gap += indent
      partial = []

      if Object.prototype.toString.apply(value) == '[object Array]'
        length = value.length
        for i in [0...value.length]
          partial[i] = str(i, value) || 'null'

        if partial.length == 0
          v = '[]'
        else
          if gap
            v = '[\n' + gap + partial.join(',\n' + gap) + '\n' + mind + ']'
          else
            v = '[' + partial.join(',') + ']'
        gap = mind
        return v

        if rep && typeof rep == 'object'
          length = rep.length
          for k in rep
            if typeof k == 'string'
              v = str(k, value)
              if (v)
                partial.push(quote(k) + (if gap then ': ' else ':') + v)

      else # an actual Object
        # Sort the object's keys
        sortedKeys = Object.keys(value).sort()
        for k in sortedKeys
          if Object.prototype.hasOwnProperty.call(value, k)
            v = str(k, value)
            if v
              partial.push(quote(k) + (if gap then ': ' else ':') + v)

        if partial.length == 0
          v = '{}'
        else
          if gap
            v = '{\n' + gap + partial.join(',\n' + gap) + '\n' + mind + '}'
          else
            v = '{' + partial.join(',') + '}'
        gap = mind
        return v

stringify = (value, replacer, space) ->
  gap = ''
  indent = ''

  if typeof space == 'number'
    indent += ' ' for i in [0..(space -1)]
  else if typeof space == 'string'
    indent = space

  rep = replacer
  replacerType = typeof replacer
  if replacer && replacerType != 'function' &&
      (replacerType != 'object' || typeof replacer.length != 'number')
    throw new Error('JSON.stringify')

  return str('', {'': value})

if module? && module.exports?
  module.exports = stringify
else
  window.canonicalStringify = stringify
