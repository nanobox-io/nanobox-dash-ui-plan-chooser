production = require 'jade/steps/finalize/production'

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

  addPaymentMethodChooser : () ->
    @payMethods = new nanobox.PaymentMethods $(".pay-holder", @$node), @config, false
    @payMethods.createMicroChooser @config.paymentMethod, (newPayMethod)-> console.log newPayMethod

  getInfo : () ->
    plan : $("input:radio[name='plan']:checked", @$node).val()
    paymentMethod : @payMethods.getMicroChooserVal()


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
