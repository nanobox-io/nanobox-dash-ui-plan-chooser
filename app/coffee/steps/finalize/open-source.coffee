openSource = require 'jade/steps/finalize/open-source'

module.exports = class OpenSource

  constructor: ($el, onSubmit) ->
    @$node = $ openSource( {} )
    $el.append @$node
    castShadows @$node
    $(".arrow-button", @$node).on 'click', ()-> onSubmit()

  destroy : () -> @$node.remove()

  getInfo : () ->
    plan : 'opensource'
    meta :
      projectDescription : $("textarea", @$node).val()
