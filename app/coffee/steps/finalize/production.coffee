production = require 'jade/steps/finalize/production'
Slider     = require 'slider'

module.exports = class Production

  constructor: ($el, onSubmit, @config) ->
    @$node = $ production( {plans:@sortPlans(), addPayMethodPath:@config.addPayMethodPath} )
    $el.append @$node
    castShadows @$node
    lexify @$node
    $(".arrow-button", @$node).on 'click', ()-> onSubmit()
    @addPaymentMethodChooser()

    # Select their current plan
    if @currentlyPaying()
      $("input:radio[value='#{@config.currentPlan.toLowerCase()}']").trigger 'click'
    else
      $("input:radio[value='startup']").trigger 'click'

    if @config.paymentMethods.length == 0
      $(".finalize").addClass "no-payment-methods"

    @addSlider()

  addPaymentMethodChooser : () ->
    @payMethods = new nanobox.PaymentMethods $(".pay-holder", @$node), @config, false
    @payMethods.createMicroChooser @config.paymentMethod, (newPayMethod)-> console.log newPayMethod

  getInfo : () ->
    info =
      plan : $("input:radio[name='plan']:checked", @$node).val()
      meta :
        paymentMethod : @payMethods.getMicroChooserVal()

    if info.plan == 'custom'
      info.meta.totalServers = @total
      info.meta.cost         = @price


    return info


  # ------------------------------------ 'Custom' plan

  addSlider : () ->
    $customNode     = $(".choice#Custom", @$node)
    slider          = new Slider($customNode, @onTotalChanged, 50, 20, 1000, 20)
    @$customServers       = $ '.servers', $customNode
    @$customPrice         = $ '.cost', $customNode
    @$customTriggers      = $ '.cost', $customNode
    @$customCollaborators = $ '.collaborators', $customNode

    @onTotalChanged 50

  onTotalChanged : (newTotal) =>
    @updateCustomServerTotal newTotal, Math.floor(@calculatePrice(newTotal))

  updateCustomServerTotal : (@total, @price) ->
    @$customServers.text       @total + " Servers"
    # @$customCollaborators.text total + " Collaborators"
    # @$customTriggers.text total
    @$customPrice.text @price

  calculatePrice : (instances) ->
    # administrative costs
    a = 10
    # base cost for a server, never drops below this per server
    b = 9.01273045
    # fading cost per server, this part goes down to basically 0 after a while
    f = 9.98726955
    # speed of fading. It's exponential
    s = 0.9685048376
    # shorthand for number of instances
    i = instances;

    return (Math.round((a + i * b + i * f * Math.pow(s, (i - 1)))*100)/100);

  # ------------------------------------ Helpers

  currentlyPaying : ()->
    for key, plan of @config.plans.paid
      if plan.name.toLowerCase() == @config.currentPlan.toLowerCase()
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
