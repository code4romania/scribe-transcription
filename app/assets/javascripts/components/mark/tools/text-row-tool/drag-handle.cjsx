React = require 'react'

RADIUS = 8
STROKE_COLOR = 'white'
FILL_COLOR = 'black'
STROKE_WIDTH = 1.5

DESTROY_TRANSITION_DURATION = 0

module.exports = React.createClass
  displayName: 'DragHandle'

  getDefaultProps: ->
    x: 0
    y: 0
    rotate: 0

  dragHandle: ->
    console.log 'DRAG HANDLE...'
    
  render: ->
    console.log 'POSITION: ', @props.position
    transform = "
      translate(#{@props.position.x+200}, #{@props.position.y+100})
      rotate(#{@props.rotate})
      scale(#{1 / @props.tool.props.xScale}, #{1 / @props.tool.props.yScale})
    "
    <g className="clickable drawing-tool-delete-button" transform={transform} stroke={STROKE_COLOR} strokeWidth={STROKE_WIDTH} onClick={@dragHandle}>
      <circle r={RADIUS} fill={FILL_COLOR} />
    </g>
