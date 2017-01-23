StepManager = require 'step-manager'
Category    = require 'steps/category'
Finalize    = require 'steps/finalize'

class PlanChooser

  constructor: (@$el, @config) ->
    @stepManager = new StepManager @$el, @config.onCancel
    @createSteps()

  createSteps : () ->
    $holder   = @stepManager.build()
    @category = new Category $holder
    @finalize = new Finalize $holder

    @stepManager.addSteps [@category, @finalize]

window.nanobox ||= {}
nanobox.PlanChooser = PlanChooser
