production = require 'jade/steps/finalize/production'

module.exports = class Production

  constructor: ($el, onSubmit) ->
    @$node = $ production( {} )
    $el.append @$node
    castShadows @$node
    lexify @$node
    $(".arrow-button", @$node).on 'click', ()-> onSubmit()

  getInfo : () ->
    plan : $("input:radio[name='plan']:checked", @$node).val()

  destroy : () -> @$node.remove()
