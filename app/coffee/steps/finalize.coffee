Step          = require './step'
finalize      = require 'jade/steps/finalize'
Production    = require 'steps/finalize/production'
PreProduction = require 'steps/finalize/pre-production'
OpenSource    = require 'steps/finalize/open-source'

module.exports = class Finalize extends Step

  constructor: ($el, @getChoice, @config, @mainSubmitCb, @nextStep, @addProductionFinalStep, @removeProductionFinalStep) ->
    @choice = ""
    @$node  = $ finalize( {} )
    $el.append @$node
    super()

  activate : () ->
    choice = @getChoice()
    return if @choice == choice
    @choice = choice

    if @display?
      @display.destroy()

    switch @choice
      when 'open-source'
        @display = new OpenSource(@$node, @submitCb)
      when 'pre-production'
        @display = new PreProduction(@$node, @submitCb)
      when 'production'
        @addProductionFinalStep()
        @display = new Production(@$node, @nextStep, @config)
        return

    @removeProductionFinalStep()

  getInfo : () =>
    @display.getInfo()

  submitCb : () =>
    @mainSubmitCb @getInfo()

  getTitle  : () ->
    if @choice == "production"
      "Choose a plan"
    else
      "Finalize"
