module.exports = class PlansShim

  constructor: () ->

  currentlyUsedFeatures : () -> ['triggers', 'data_redundancy']



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
    'unpaid':
      'internal':
        'name': 'Internal'
        'description': 'A plan for internal, company apps.'
        'max_price': 0
        'hidden': true
        'features': [
          'horizontal_scaling'
          'vertical_scaling'
          'triggers'
          'auto_scaling'
          'db_redundancy'
        ]
      'trial':
        'name': '10 Day Free Trial'
        'description': '10 Day Free Trial for new apps.'
        'free_days': 10
        'max_price': 0
        'features': [
          'horizontal_scaling'
          'vertical_scaling'
          'triggers'
          'auto_scaling'
          'db_redundancy'
        ]
      'pre-production':
        'name': 'Pre-Production'
        'description': 'WIP description for Pre-Production.'
        'free_days': 5
        'max_price': 0
        'features': [
          'horizontal_scaling'
          'vertical_scaling'
          'triggers'
          'auto_scaling'
          'db_redundancy'
        ]
      'opensource':
        'name': 'Open Source'
        'description': 'Free Tinker plan for open-source projects.'
        'max_price': 0
        'features': []
    'paid':
      'scalable':
        'name': 'Scalable'
        'description': 'Deploy to servers we provision on your cloud provider. Scale up or down at any time via the simple dashboard.'
        'paid': true
        'max_price': 99
        'features': [
          'horizontal_scaling'
          'vertical_scaling'
          'triggers'
          'auto_scaling'
          'db_redundancy'
        ]
        'displayFeatures': [
          'Nanobox Desktop'
          'Health Monitoring'
          'Simple Logging'
          'Console Tunneling'
          'SSL Encryption'
          'Load Balancing'
          'Horizontal Scaling'
          'Vertical Scaling'
          'Alerts / Triggers'
        ]
        'displayDescription': 'Deploy to servers we provision on your cloud provider. Scale up or down at any time via the simple dashboard'
        'id': 'scalable'
      'critical':
        'name': 'Critical'
        'description': 'Deploy to servers we provision on your cloud provider. Scale up or down at any time via the simple dashboard. Add auto-scaling & database redundancy with a single click.'
        'paid': true
        'max_price': 299
        'is_disabled': true
        'features': [
          'horizontal_scaling'
          'vertical_scaling'
          'triggers'
        ]
        'displayFeatures': [
          'Nanobox Desktop'
          'Health Monitoring'
          'Simple Logging'
          'Console Tunneling'
          'SSL Encryption'
          'Load Balancing'
          'Horizontal Scaling'
          'Vertical Scaling'
          'Alerts / Triggers'
          'Auto Scaling'
          'DB Redundancy'
        ]
        'displayDescription': 'Deploy to servers we provision on your cloud provider. Scale up or down at any time via the simple dashboard<br/><br/>Add auto-scaling & database redundancy with a single click'
        'id': 'critical'
      'custom':
        'name': 'Custom'
        'description': 'WIP description for Custom.'
        'paid': true
        'max_price': 'custom'
        'features': [
          'horizontal_scaling'
          'vertical_scaling'
          'triggers'
          'auto_scaling'
          'db_redundancy'
          'custom'
        ]
        'displayFeatures': [
          'On Premise Licencing'
          'Activity Logging'
          'Custom Support Options'
          'SLA'
        ]
        'displayDescription': 'Mix and match features to build a plan that fits your needs'
        'id': 'custom'
      'pet':
        'name': 'Pet Project'
        'description': 'Deploy your app to a single server we provision on your cloud provider.'
        'paid': true
        'max_price': 9
        'features': []
        'displayFeatures': [
          'Nanobox Desktop'
          'Health Monitoring'
          'Simple Logging'
          'Console Tunneling'
          'SSL Encryption'
        ]
        'displayDescription': 'Deploy your app to a single server we provision on your cloud provider'
        'id': 'pet'
