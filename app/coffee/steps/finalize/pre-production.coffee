preProduction = require 'jade/steps/finalize/pre-production'

module.exports = class PreProduction

  constructor: ($el) ->
    console.log 'h...'
    @$node = $ preProduction( {} )
    $el.append @$node
    castShadows @$node
    lexify @$node

  destroy : () -> @$node.remove()
