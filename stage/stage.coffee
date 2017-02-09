PlanShim = require './shim/plans'
shim      = new PlanShim()

# Samplse Config
config =
  onCancel          : ()-> console.log "canceling.."
  paymentMethods    : []#paymentMethodShim.getPaymentMethods(),
  paymentMethod     : 'personal'
  planChangePath    : "/some/path"
  addPayMethodPath  : "/some/path/add/pay"
  appDestroyPath    : "/some/path/to/destroy"
  plans             : shim.getPlans()
  planFeatures      : shim.getPlanFeatures()
  currentPlan       :
    isProduction : true
    key          : "tinker"
    name         : "Small"
  ###
  data:
    plan : "id-of-the-new-plan" - opensource, pre-production, small, startup, business, custom
    meta : hash of info specific to their plan
  ###
  changePlan  : (data, cb)-> console.log "Changing plan to : "; console.log data; cb()

# config = require './shim/sample.json'

showMiniDisplay = false
app = new nanobox.PlanChooser( $(".holder"), config )

if !showMiniDisplay
  app.choosePlan()
else
  $('.holder').css width:640, margin:"0 auto", 'margin-top':60;
  app.displayCurrentPlan()

window.Dashboard =
  olark:
    isAvailable: true
    open: ()-> console.log 'opening live chat..'
