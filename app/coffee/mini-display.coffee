miniDisplay = require 'jade/mini-display'

module.exports = class MiniDisplay

  constructor: ($el, config) ->
    @findCurrentPlan config
    $node = $ miniDisplay( config )
    $el.append $node
    castShadows $node

  findCurrentPlan : (config) ->
    for key, planBucket of config.plans
      for planKey, plan of planBucket
        if planKey == config.currentPlan
          config.currentPlanDetails = plan
          return
    console.log "Unable to find a plan called : `#{config.currentPlan}`"
