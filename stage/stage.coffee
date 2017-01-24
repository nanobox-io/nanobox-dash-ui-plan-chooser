app = new nanobox.PlanChooser( $("body"), config )

# Samplse Config
config =
  onCancel    : ()-> console.log "canceling.."
  changePlan  : (data, cb)-> console.log "Changing plan to : "; console.log data; cb()
  currentPlan : "pre-production"


app.choosePlan config

# app.displayCurrentPlan()
