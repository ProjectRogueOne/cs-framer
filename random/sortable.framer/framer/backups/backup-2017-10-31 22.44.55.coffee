Screen.backgroundColor = '#eee'

class RowItem extends Layer
	constructor: ( options = {} ) ->
		
		@group = options.group ? throw 'RowItem needs a group'
		
		_.defaults options,
			width: Screen.width - 64
			height: 48
			position: i
			backgroundColor: '#CCC'
			animationOptions: { time : .3 }
		
		super options
		
		@states = 
			dragging:
				brightness: 85
				scale: 1.07
				shadowY: 2
				shadowBlur: 3
				
			notDragging:
				brightness: 100
				scale: 1
				shadowY: 0
				shadowBlur: 0
		
		# turn on draggable, but not horizontally
		@draggable.horizontal = false
		
		# create a new item for this layer's position
		@current = 
			index: @group.length
			layer: @
			midY: @midY
		
		# add it to the items array
		@group.push(@current)
			
		#- Events:
		
		# when dragging starts, show that the layer is dragging
		@onDragStart @_showDragStart
		
		# when the layer is dragged, look for a new position
		@onDrag @_getNewPosition
				
		# when dragging ends, move to the current position 
		# and show that the drag has ended
		@onDragEnd -> 
			@_takePosition( @current, true )
			@_showDragEnd()
	
	# Functions:
	
	_showDragStart: ->
		@bringToFront()
		@animate 'dragging'
	
	_showDragEnd: ->
		@animate 'notDragging'
	
	_getNewPosition: ->
		above = @parent.items[ @current.index + 1 ]
		below = @parent.items[ @current.index - 1 ]
		
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

card = new Layer
	point: Align.center
	height: Screen.height - 32, width: Screen.width - 32
	backgroundColor: "#FFF"
	
card.items = []

for i in _.range( 9 )
	item = new RowItem
		parent: card
		y: 32 + ( i * 64 )
		x: Align.center
		width: Screen.width - 64
		height: 48
		position: i
		backgroundColor: '#CCC'
		animationOptions: { time : .3 }
		group: card.items