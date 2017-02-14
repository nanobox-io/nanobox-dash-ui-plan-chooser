finalizeProduction = require 'jade/steps/finalize-production'
planSummary        = require 'jade/steps/plan-summary'
Step               = require './step'

module.exports = class FinalizeProduction extends Step

  constructor: ($el, @onSubmit, @config, @getPlanInfo) ->
    @$node = $ finalizeProduction( {addPayMethodPath:@config.addPayMethodPath, plan:{name:"asdf"}} )
    $el.append @$node
    lexify @$node
    super()
    @isProduction = true
    @addPaymentMethodChooser()
    @$summary = $(".summary", @$node)
    $(".arrow-button", @$node).on 'click', (e)=>
      $(e.currentTarget).addClass 'ing'
      @submit()

    if @config.paymentMethods.length == 0
      $(".holder", @$node).addClass "no-payment-methods"

  addPaymentMethodChooser : () ->
    @payMethods = new nanobox.PaymentMethods $(".pay-holder", @$node), @config, false
    @payMethods.createMicroChooser @config.paymentMethod, (newPayMethod)-> console.log newPayMethod

  addPlanInfo : (planInfo) ->
    @$summary.empty()
    $planSummary = $ planSummary( {plan:planInfo} )
    @$summary.append $planSummary
    castShadows @$summary

  submit : () =>
    info = @getPlanInfo()
    info.meta.paymentMethod = @payMethods.getMicroChooserVal()
    @onSubmit info

  activate  : ()-> @addPlanInfo @getPlanInfo()
  getTitle  : () -> "Select a Payment Method and Submit"
