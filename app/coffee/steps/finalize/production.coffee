production          = require 'jade/steps/finalize/production'
contactUs           = require 'jade/steps/finalize/contact-us'
unavailableFeatures = require 'jade/unavailable-features'
Slider              = require 'slider'

module.exports = class Production

  constructor: ($el, nextStep, submitCb, @config) ->
    @$node = $ production( {plans:@sortPlans(), addPayMethodPath:@config.addPayMethodPath} )
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
        $(e.currentTarget).addClass 'ing'

    $("input:radio[name='plan']", @$node).on 'click', (e)=>
      @onChangePlan e.currentTarget.value, $(e.currentTarget).parents('.choice')

    # Select their current plan
    @selectCurrentPlan()

    # Don't make them change the payment method if they already have one
    if hasPaymentMethod
      @$arrowBtn.text "Submit"

  onChangePlan : (planId, $el) ->
    @removeWarning()
    @enableArrowBtn()
    $('.choice', @$node).removeClass 'selected'
    $("##{planId}", @$node).addClass 'selected'
    plan = @config.plans.paid[planId]
    $("#plan-name", @$node).text plan.name
    $("#plan-cost", @$node).text plan.max_price

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
    $("#custom", @$node).append @$contactUs
    $("#close-btn", @$contactUs).on 'click', (e)=> e.stopPropagation(); @hideCustom(); @selectCurrentPlan()
    $("#open-live-chat", @$contactUs).on 'click', ()=> Dashboard.olark.open()
    $("#plan-cost", @$node).addClass 'custom'
    castShadows @$contactUs
    @disableArrowBtn()

  hideCustom : () ->
    if @$contactUs?
      @$contactUs.remove()
    $("#plan-cost", @$node).removeClass 'custom'
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
    @addPlanFeaturesAndDescriptions()
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

  # Just cosmetic. Add the features / descriptions to each plan
  addPlanFeaturesAndDescriptions : () ->
    baseFeatures = ["Nanobox Desktop", "Health Monitoring", "Simple Logging", "Console Tunneling", "SSL Encryption"]
    obj = {}

    obj.pet       =
      description : "Deploy your app to a single server we provision on your cloud provider"
      features    : baseFeatures

    obj.scalable  =
      description : "Deploy to servers we provision on your cloud provider. Scale up or down at any time via the simple dashboard"
      features    : baseFeatures.concat ["Load Balancing", "Horizontal Scaling", "Vertical Scaling", "Alerts / Triggers"]
    obj.critical  =
      description : "Deploy to servers we provision on your cloud provider. Scale up or down at any time via the simple dashboard<br/><br/>Add auto-scaling & database redundancy with a single click"
      features : obj.scalable.features.concat ["Auto Scaling", "DB Redundancy"]
    obj.custom    =
      description : "Mix and match features to build a plan that fits your needs"
      features    : ["On Premise Licencing", "Activity Logging", "Custom Support Options", "SLA"]

    for key, plan of @config.plans.paid
      plan.displayFeatures    = obj[key].features
      plan.displayDescription = obj[key].description


  destroy : () -> @$node.remove()
