PlanShim = require './shim/plans'
shim      = new PlanShim()

# Samplse Config
config =
  onCancel         : ()-> console.log "canceling.."
  currentPlan      : "opensource"
  paymentMethods   : paymentMethodShim.getPaymentMethods(),
  paymentMethod    : 'zumiez'
  planChangePath   : "/some/path"
  addPayMethodPath : "/some/path/add/pay"
  plans            : shim.getPlans()
  ###
  data:
    plan : "id-of-the-new-plan" - open-source, pre-production, small, startup, business, custom
    meta : hash of info specific to their plan
  ###
  changePlan  : (data, cb)-> console.log "Changing plan to : "; console.log data; cb()

app = new nanobox.PlanChooser( $("body"), config )
app.choosePlan()

# app.displayCurrentPlan( {plan:'startup'} )
