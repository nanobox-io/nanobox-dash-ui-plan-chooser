slider = require 'jade/steps/finalize/slider'

module.exports = class Slider

  constructor: ($el, onTotalChangeCb, @currentTotal=10, @lowerLimit=1, @upperLimit=40, @incrament=1) ->
    $node = $ slider( {} )
    $el.append $node
    console.log "hi"

    @steps = @upperLimit
    @build($el)
    @updateTotal @currentTotal
    @cb =  onTotalChangeCb

  build : ($el)->
    @$node      = $(".slider")
    @$body      = $ 'body'
    @$dragger   = $ ".dragger", @$node
    @$tracks    = $ ".tracks"
    @$track     = $ ".track"
    @trackWidth = @$tracks.width()
    @stepSize   = @trackWidth / @steps

    # On Mousedown
    @$dragger.on "mousedown", ()=>

      # Add drag listener
      @$body.on "mousemove", (e)=>
        perc = (e.pageX - @$tracks.offset().left) / @trackWidth

        # Must be a percentage between 0 and 1
        if perc > 1      then perc = 1
        else if perc < 0 then perc = 0

        incrament   = 20
        total       =  Math.round( (@upperLimit * perc) / incrament )*incrament
        # Don't allow 0
        if total < @lowerLimit then total = @lowerLimit

        @updateTotal total

      # Remove Events on release
      @$body.on "mouseup", ()=>
        @$body.off "mousemove"
        @$body.off "mouseup"

  updateTotal : (total) ->
    if total == @total then return
    @total = total

    pos = total * @stepSize
    @$dragger.css left  : "#{ pos }px"
    @$track.css   width : pos

    if @cb then @cb total

  destroy : () ->
    @$dragger.off()
    @$node.remove()

window.Slider = Slider
