PlanShim = require './shim/plans'
shim      = new PlanShim()

# Samplse Config
config =
  onCancel          : ()-> console.log "canceling.."
  paymentMethods    : paymentMethodShim.getPaymentMethods(),
  paymentMethod     : 'personal'
  planChangePath    : "/some/path"
  addPayMethodPath  : "/some/path/add/pay"
  plans             : shim.getPlans()
  currentPlan       :
    key           : "opensource"
    name          : "Open Source"
    customServers : 450
  ###
  data:
    plan : "id-of-the-new-plan" - opensource, pre-production, small, startup, business, custom
    meta : hash of info specific to their plan
  ###
  changePlan  : (data, cb)-> console.log "Changing plan to : "; console.log data; cb()

showMiniDisplay = true
app = new nanobox.PlanChooser( $(".holder"), config )

if !showMiniDisplay
  app.choosePlan()
else
  $('.holder').css width:640, margin:"0 auto", 'margin-top':60;
  app.displayCurrentPlan()
