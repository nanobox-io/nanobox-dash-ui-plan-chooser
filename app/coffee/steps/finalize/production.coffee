production = require 'jade/steps/finalize/production'

module.exports = class Production

  constructor: ($el) ->
    @$node = $ production( {} )
    $el.append @$node
    castShadows @$node
    lexify @$node

  destroy : () -> @$node.remove()
