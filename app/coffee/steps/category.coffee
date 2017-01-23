Step = require './step'
category =  require 'jade/steps/category'

module.exports = class Category extends Step

  constructor: ($el) ->
    @$node = $ category( {} )
    $el.append @$node

  getTitle : () -> "Specify app type / phase"
