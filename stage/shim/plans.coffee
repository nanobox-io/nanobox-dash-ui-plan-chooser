module.exports = class PlansShim

  constructor: () ->

  getPlans : () ->
    paid:
      small:
        name: 'Small'
        description: 'WIP description for Small.'
        max_servers: 1
        max_collaborators: 1
        max_triggers: 1
        max_price: 29.0
        is_disabled: true

      startup:
        name: 'Startup'
        description: 'WIP description for Startup.'
        max_servers: 5
        max_collaborators: 5
        max_triggers: 5
        max_price: 99.0

      business:
        name: 'Business'
        description: 'WIP description for Business.'
        max_servers: 20
        max_collaborators: 20
        max_triggers: 20
        max_price: 299.0

      custom:
        name: 'Custom'
        description: 'WIP description for Custom'
        min_servers: 21
        max_servers: 'unlimited'
        max_collaborators: 'unlimited'
        max_triggers: 'unlimited'
        max_price:
          admin_cost: 10.0
          base_cost: 9.01273045
          fading_cost: 9.98726955
          fading_speed: 0.9685048376
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
