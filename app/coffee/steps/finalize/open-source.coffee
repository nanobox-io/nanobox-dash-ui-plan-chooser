openSource = require 'jade/steps/finalize/open-source'

module.exports = class OpenSource

  constructor: ($el) ->
    @$node = $ openSource( {} )
    $el.append @$node
    castShadows @$node

  destroy : () -> @$node.remove()
