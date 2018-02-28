# Sortable
# Authors: Steve Ruiz
# Last Edited: 6 Oct 17

{ Container } = require 'Container'

class exports.Sortable extends Container
	constructor: ( options = {} ) ->
		
		@positions = options.positions ? throw 'Sortable needs a positions property (array).'
		
		_.defaults options,
			x: Align.center
			width: Screen.width - 64
			height: 48
			backgroundColor: '#CCC'
			animationOptions: { time : .3 }
			padding: 16

		last = _.last(@positions)

		if last? 
			delete options.y
			options.midY = last.midY + options.height + options.padding

		super options
		
		@states = 
			dragging:
				brightness: 85
				scale: 1.07
				shadowY: 2
				shadowBlur: 3
				
		delete @states.default.x
		delete @states.default.y
		
		# turn on draggable, but not horizontally
		@draggable.enabled = true
		@draggable.horizontal = false
		@draggable.propagateEvents = false
		
		# create a new item for this layer's position
		@position = 
			index: @positions.length
			layer: @
			midY: @midY
		
		# add it to the items array
		@positions.push(@position)
			
		#- Events:
		
		# when dragging starts, bring the layer to the front and
		# show that the layer is dragging
		@onDragStart ->
			@bringToFront()
			@animate 'dragging'
		
		# when the layer is dragged, look for a new position
		@onDrag @_getNewPosition
				
		# when dragging ends, move to the current position 
		# and show that the drag has ended
		@onDragEnd -> 
			@_takePosition( @position, true )
			@animate 'default'
	
	# Functions:
	
	_getNewPosition: ->
		above = @positions[ @position.index + 1 ]
		below = @positions[ @position.index - 1 ]
		
		return if below?.midY < @midY < above?.midY

		if @midY > above?.midY
			above.layer._takePosition( @position, true )
			@_takePosition( above, false )
			
		else if @midY < below?.midY
			below.layer._takePosition( @position, true )
			@_takePosition( below, false )
	
	_takePosition: ( position, animate = true ) ->
		@position = position
		position.layer = @
		if animate then @animate { midY: position.midY }