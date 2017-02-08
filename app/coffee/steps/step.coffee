stepError = require 'jade/step-error'
module.exports = class Step

  constructor: () -> @isProduction = false
  getTitle   : () -> console.log 'Overwrite `getTitle` in extending class'
  destroy    : () ->
  activate   : () -> # Some steps use it, most don't
  deactivate : () -> # Some steps use it, most don't

  showErrors : (error) ->
    @clearError()
    @$stepError = $ stepError( {error:error} )
    @$node.prepend @$stepError

  clearError : () ->
    if @$stepError?
      @$stepError.remove()
