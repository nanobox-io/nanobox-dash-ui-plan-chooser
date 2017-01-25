StepManager = require 'step-manager'
Category    = require 'steps/category'
Finalize    = require 'steps/finalize'
MiniDisplay = require 'mini-display'

class PlanChooser

  constructor: (@$el, @config) ->

  displayCurrentPlan : () ->
    @miniDisplay = new MiniDisplay @$el, @config

  choosePlan : () ->
    @stepManager = new StepManager @$el, @config.onCancel
    @createSteps()
    if @config.currentPlan?
      # If ther current plan is either open-source or pre-production...
      if @config.currentPlan == "opensource" || @config.currentPlan == "pre-production"
        @category.setPlan @config.currentPlan
      # else, if in production, only show the production plans
      else
        @stepManager.nextStep()
        @stepManager.hide()

  createSteps : () ->
    $holder   = @stepManager.build()
    @category = new Category $holder, @stepManager.nextStep
    @finalize = new Finalize $holder, @category.getChoice, @config, @submit

    @stepManager.addSteps [@category, @finalize]

  # Todo : add error handling here
  submit : (data) =>
    if data.plan != @config.currentPlan
      @config.changePlan data, (results={})=>
        if !results.error?
          setTimeout ->
            window.location.reload()
          ,
            600


window.nanobox ||= {}
nanobox.PlanChooser = PlanChooser
