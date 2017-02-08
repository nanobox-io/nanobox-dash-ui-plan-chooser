Step     = require './step'
category = require 'jade/steps/category'

module.exports = class Category extends Step

  constructor: ($el, nextStepCb) ->
    @$node = $ category( {} )
    $el.append @$node
    castShadows @$node
    lexify()

    $(".continue", @$node).on 'click', nextStepCb
    super()

  setPlan   : (plan) -> $("input:radio[value='#{plan}']", @$node).trigger 'click'
  getChoice : () => $("input:radio[name='app-type']:checked", @$node).val()
  getTitle  : () -> "Specify app type / phase"
