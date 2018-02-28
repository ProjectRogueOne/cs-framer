Screen.backgroundColor = '#FFF'

class RowItem extends Layer
	constructor: ( options = {} ) ->
		
		@group = options.group ? throw 'RowItem needs a group'
		
		_.defaults options,
			x: Align.center
			width: Screen.width - 64
			height: 48
			backgroundColor: '#CCC'
			animationOptions: { time : .3 }
		
		super options
		
		@states = 
			dragging:
				brightness: 85
				scale: 1.07
				shadowY: 2
				shadowBlur: 3
		
		_.omit(@states.default, ['x', 'y'])
		
# 		print @states.default
# 				
# 			notDragging:
# 				brightness: 100
# 				scale: 1
# 				shadowY: 0
# 				shadowBlur: 0
		
		# turn on draggable, but not horizontally
		@draggable.enabled = true
		@draggable.horizontal = false
		
		# create a new item for this layer's position
		@current = 
			index: @group.length
			layer: @
			midY: @midY
		
		# add it to the items array
		@group.push(@current)
			
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
			@_takePosition( @current, true )
			@animate 'default'
	
	# Functions:
	
	_getNewPosition: ->
		above = @group[ @current.index + 1 ]
		below = @group[ @current.index - 1 ]
		
		if @midY > above?.midY
			above.layer._takePosition( @current, true )
			@_takePosition( above, false )
			
		else if @midY < below?.midY
			below.layer._takePosition( @current, true )
			@_takePosition( below, false )
	
	_takePosition: ( position, animate = true ) ->
		@current = position
		position.layer = @
		if animate then @animate { midY: position.midY }


# Implementation:

items = []

for i in _.range( 9 )
	item = new RowItem
		y: 32 + ( i * 64 )
		group: items