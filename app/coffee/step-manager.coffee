stepManager    = require 'jade/step-manager'

module.exports = class StepManager

  constructor: (@$el, @cancelCb) ->
    @$node = $ stepManager( {} )
    @$el.append @$node


  build : () ->
    $(".ui-btn.back", @$node).on 'click', ()=> @previousStep()

    @$wrapper     = $ '.step-wrapper', @$node
    @$steps       = $ ".steps", @$node
    @$currentStep = $ "#current-step", @$node
    @$stepTitle   = $ ".step-title", @$node
    $(".ui-btn.cancel", @$node).on "click", @cancelCb

    castShadows @$node
    return $('.steps', @$node)

  addSteps : (steps) ->
    @$allSteps    = $ ".step", @$node
    @steps = new Sequin( steps )
    @$allSteps.css width: @$el.width()
    @slideToCurrentStep()

  slideToCurrentStep : ()->
    if @currentStep?
      @currentStep.deactivate()
    @currentStep = @steps.currentItem()
    @currentStep.activate()
    @$currentStep.text @steps.currentItemIndex+1
    @$stepTitle.text @currentStep.getTitle()

    $(".plan-step", @$node).removeClass 'active'
    @currentStep.$node.addClass 'active'
    left = - @steps.currentItem().$node.position().left

    me = @
    setTimeout ()->
      me.$steps.css left: left
    , 100

    # If it's the last item, change the next button to submit
    @$node.removeClass 'submit'
    @$node.removeClass 'first'

    if @steps.isAtLastItem()
      @$node.addClass 'submit'
    else if @steps.currentItemIndex == 0
      @$node.addClass 'first'

  nextStep : () =>
    @steps.next()
    @slideToCurrentStep()

  previousStep : () =>
    @steps.prev()
    @slideToCurrentStep()

  destroy : ()->
    @$el.empty()
    $(".ui-btn.cancel", @$node).off()
    $(".ui-btn.back", @$node).off()
    @$allSteps = @$node = @steps = @currentStep = @$stepTitle = @$wrapper = null
