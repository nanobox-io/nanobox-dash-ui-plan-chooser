StepManager        = require 'step-manager'
Category           = require 'steps/category'
Finalize           = require 'steps/finalize'
FinalizeProduction = require 'steps/finalize-production'
MiniDisplay        = require 'mini-display'

class PlanChooser

  constructor: (@$el, @config) ->

  displayCurrentPlan : () ->
    @miniDisplay = new MiniDisplay @$el, @config

  choosePlan : () ->
    @stepManager = new StepManager @$el, @config.onCancel
    @createSteps()
    if @config.currentPlan.key?
      # If ther current plan is either open-source or pre-production...
      if !@config.currentPlan.isProduction
        @category.setPlan @config.currentPlan.key
      # else, if in production, only show the production plans
      else
        @stepManager.nextStep()
        @stepManager.hide()

  createSteps : () ->
    $holder             = @stepManager.build()
    @category           = new Category $holder, @stepManager.nextStep
    @finalize           = new Finalize $holder, @category.getChoice, @config, @submit, @stepManager.nextStep, @addFinalizeProduction, @removeFinalizeProduction
    @finalizeProduction = new FinalizeProduction $holder, @submit, @config, @finalize.getInfo

    @stepManager.addSteps [@category, @finalize]

  addFinalizeProduction : () =>
    @stepManager.addStep @finalizeProduction

  removeFinalizeProduction : () =>
    @stepManager.removeLastStep()

  # Todo : add error handling here
  submit : (data) =>
    # if data.plan != @config.currentPlan.key
    @config.changePlan data, (results={})=>
      if !results.error?
        setTimeout ->
          # window.location.reload()
          console.log "saving.."
        ,
          600


window.nanobox ||= {}
nanobox.PlanChooser = PlanChooser
