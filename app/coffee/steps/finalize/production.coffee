production          = require 'jade/steps/finalize/production'
contactUs           = require 'jade/steps/finalize/contact-us'
unavailableFeatures = require 'jade/unavailable-features'
Slider              = require 'slider'

module.exports = class Production

  constructor: ($el, nextStep, submitCb, @config) ->
    @$node = $ production( {plans:@sortPlans(), addPayMethodPath:@config.addPayMethodPath, planFeatures:@config.planFeatures} )
    $el.append @$node
    castShadows @$node
    lexify @$node
    @$arrowBtn = $(".arrow-button", @$node)
    hasPaymentMethod = @config.paymentMethod?

    # On submit
    @$arrowBtn.on 'click', (e)->
      # $(e.currentTarget).addClass 'ing'
      if !hasPaymentMethod
        nextStep()
      else
        submitCb()

    # Select their current plan
    @selectCurrentPlan()

    $("input:radio[name='plan']", @$node).on 'click', (e)=>
      @onChangePlan e.currentTarget.value, $(e.currentTarget).parents('.choice')

    # Don't make them change the payment method if they already have one
    if hasPaymentMethod
      @$arrowBtn.text "Submit"

  onChangePlan : (planId, $el) ->
    @removeWarning()
    @enableArrowBtn()
    if planId == 'custom'
      @showCustom()
      return
    else
      @hideCustom()

    unsupportedFeatures = @featuresNotFittingInPlan planId
    if unsupportedFeatures.length != 0
      @notifyPlanIsSmallerThanApp unsupportedFeatures, planId, $el

  notifyPlanIsSmallerThanApp : (unsupportedFeatures, newPlan, $el) ->
    @disableArrowBtn()
    @$warning = $ unavailableFeatures( {features:unsupportedFeatures, newPlan:newPlan} )
    $el.append @$warning
    castShadows @$warning
    $('#add-hours', @$warning).on 'click', ()=> @config.addDaysToTrial 1
    $('#close-it', @$warning).on 'click',  ()=> @$warning.remove(); @selectCurrentPlan()

  removeWarning : () ->
    if @$warning? then @$warning.remove()

  selectCurrentPlan : () ->
    # If they have a current production plan
    if @config.currentPlan.isProduction
      $("input:radio[value='#{@config.currentPlan.key.toLowerCase()}']", @$node).trigger 'click'
    # Else select the plan they fit into
    else
      plan = 'scalable'
      if @featuresNotFittingInPlan(plan).length != 0
        plan = 'critical'
      $("input:radio[value='#{plan}']", @$node).trigger 'click'

  showCustom : () ->
    @$contactUs = $ contactUs( {chatIsAvailable:window.Dashboard?.olark?.isAvailable} )
    $("#Custom", @$node).append @$contactUs
    $("#close-btn", @$contactUs).on 'click', (e)=> e.stopPropagation(); @hideCustom(); @selectCurrentPlan()
    $("#open-live-chat", @$contactUs).on 'click', ()=> Dashboard.olark.open()
    castShadows @$contactUs
    @disableArrowBtn()

  hideCustom : () ->
    if @$contactUs?
      @$contactUs.remove()
    @enableArrowBtn()

  getInfo : () =>
    info =
      plan : $("input:radio[name='plan']:checked", @$node).val()
      meta : {}

    info.planData = @getPlan info.plan

    if info.plan == 'custom'
      info.meta.totalServers = @total
      info.meta.cost         = @price

    return info

  getPlan : (planName) ->
    for key, plan of @config.plans.paid
      if key == planName
        return plan

    return null

  disableArrowBtn : () -> @$arrowBtn.addClass 'disabled'
  enableArrowBtn  : () -> @$arrowBtn.removeClass 'disabled'


  # ------------------------------------ Helpers

  featuresNotFittingInPlan : (plan) ->
    ar = []
    # Check if all the features currently used by the app are offered in this plan
    for feature in @config.featuresUsed
      if @config.plans.paid[plan].features.indexOf(feature) == -1
        ar.push feature

    return ar


  currentlyPaying : ()->
    for key, plan of @config.plans.paid
      if key == @config.currentPlan.key.toLowerCase()
        return true

  sortPlans : () ->
    ar = []
    for key, plan of @config.plans.paid
      plan.id = key
      ar.push plan

    ar.sort (a,b)->
      if a.max_price < b.max_price
        return -1
      else if a.max_price > b.max_price
        return 1
      else
        return 0

    return ar


  destroy : () -> @$node.remove()
