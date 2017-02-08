production = require 'jade/steps/finalize/production'
contactUs  = require 'jade/steps/finalize/contact-us'
Slider     = require 'slider'

module.exports = class Production

  constructor: ($el, nextStep, @config) ->
    @$node = $ production( {plans:@sortPlans(), addPayMethodPath:@config.addPayMethodPath, planFeatures:@config.planFeatures} )
    $el.append @$node
    castShadows @$node
    lexify @$node
    @$arrowBtn = $(".arrow-button", @$node)
    @$arrowBtn.on 'click', (e)->
      # $(e.currentTarget).addClass 'ing'
      nextStep()

    # Select their current plan
    @selectCurrentPlan()

    $("input:radio[name='plan']", @$node).on 'click', (e)=>
      if e.currentTarget.value == 'custom'
        @showCustom()
      else
        @hideCustom()

  selectCurrentPlan : () ->
    if @currentlyPaying()
      $("input:radio[value='#{@config.currentPlan.key.toLowerCase()}']", @$node).trigger 'click'
    else
      $("input:radio[value='startup']", @$node).trigger 'click'

  showCustom : () ->
    @$arrowBtn.addClass 'disabled'
    @$contactUs = $ contactUs( {chatIsAvailable:window.Dashboard?.olark?.isAvailable} )
    $("#Custom", @$node).append @$contactUs
    $("#close-btn", @$contactUs).on 'click', ()=> @hideCustom(); @selectCurrentPlan()
    $("#open-live-chat", @$contactUs).on 'click', ()=> Dashboard.olark.open()
    castShadows @$contactUs

  hideCustom : () ->
    if @$contactUs?
      @$contactUs.remove()
    @$arrowBtn.removeClass 'disabled'


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

  # ------------------------------------ Helpers

  currentlyPaying : ()->
    for key, plan of @config.plans.paid
      if plan.name.toLowerCase() == @config.currentPlan.key.toLowerCase()
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
