module.exports = class PlansShim

  constructor: () ->

  getPlanFeatures : () ->
    platform:
      label: "Nanobox Platform"
      description: ""
    small_server:
      label: "Single Small Server"
    mult_servers:
      label: "Unlimited Servers"
      description: ""
    triggers:
      label: "Alerts / Triggers"
      description: ""
    auto_scaling:
      label: "Auto Scaling"
      description: ""
    data_redundancy:
      label: "DB Redundancy"
      description: ""
    on_premise:
      label: "On Premise License"
      description: ""
    activity_logger:
      label: "Activity Logger"
      description: ""
    custom_support:
      label: "Custom Support"
      description: ""
    sla:
      label: "SLA"
      description: ""
  getPlans : () ->
    paid:
      tinker:
        name: 'Tinker'
        description: 'WIP description for Small.'
        max_price: 9.0
        is_disabled: true
        features:[
          "platform"
          "small_server"
        ]

      core:
        name: 'Core'
        description: 'WIP description for Startup.'
        max_price: 99.0
        features:[
          "platform"
          "mult_servers"
          "triggers"
        ]
      flex:
        name: 'Flex'
        description: 'WIP description for Business.'
        max_price: 299.0
        features:[
          "platform"
          "mult_servers"
          "triggers"
          "auto_scaling"
          "data_redundancy"
        ]
      custom:
        name: 'Custom'
        description: 'WIP description for Custom'
        max_price: 'custom'
        features:[
          "on_premise"
          "activity_logger"
          "custom_support"
          "sla"
        ]
    unPaid:
      trial:
        name: '10 Day Free Trial'
        description: '10 Day Free Trial for new apps.'
        free_days: 10
        max_servers: 1
        max_collaborators: 1
        max_triggers: 1
        max_price: 0.0

      opensource:
        name: 'Open Source'
        description: 'Free Tinker for open-source and personal projects.'
        max_servers: 1
        max_collaborators: 1
        max_triggers: 1
        max_price: 0.0
