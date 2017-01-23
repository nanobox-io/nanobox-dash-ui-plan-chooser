Step     = require './step'
category = require 'jade/steps/category'

module.exports = class Category extends Step

  constructor: ($el, nextStepCb) ->
    @$node = $ category( {} )
    $el.append @$node
    castShadows @$node
    lexify()

    $(".continue", @$node).on 'click', nextStepCb


  getChoice : () => $("input:radio[name='app-type']:checked").val()
  getTitle  : () -> "Specify app type / phase"
