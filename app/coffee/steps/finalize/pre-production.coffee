preProduction = require 'jade/steps/finalize/pre-production'

module.exports = class PreProduction

  constructor: ($el, onSubmit, extendTrial) ->
    @$node = $ preProduction( {} )
    $el.append @$node
    castShadows @$node
    lexify @$node
    $(".arrow-button", @$node).on 'click', (e)=>
      $(e.currentTarget).addClass 'ing'
      onSubmit()

  getInfo : () ->
    plan : "pre-production"
    meta :
      expectedLaunchDate : "#{$('select.month', @$node).val()}, #{$('select.year', @$node).val()}"
      helpNeeded         : $('.help-needed', @$node).val()
      contactChannelPref : $('.contact-pref', @$node).val()
      contactDetails     : $('.contact-details', @$node).val()

  destroy : () -> @$node.remove()
