Screen.backgroundColor = '#eee'

class RowItem extends Layer
	constructor: ( options = {} ) ->
		
		@grou
		
		super options
		
		# turn on draggable, but not horizontally
		@draggable.horizontal = false
		
		# if it doesn't exist, create an array on parent layer called items
		if not @parent.items then @parent.items = []
		
		
			
		# create a new item for this layer's position
		@current = 
			index: @parent.items.length
			layer: @
			midY: @midY
		
		# add it to the items array
		@parent.items.push( @current )
			
		#- Events:
		
		# when dragging starts, show that the layer is dragging
		@onDragStart @showDragStart
		
		# when the layer is dragged, look for a new position
		@onDrag @getNewPosition
				
		# when dragging ends, move to the current position and showDragEnd
		@onDragEnd -> 
			@takePosition( @current )
			@showDragEnd()
	
	# Functions:
	
	showDragStart: ->
		@bringToFront()
		@animate
			brightness: 85
			scale: 1.07
			shadowY: 2
			shadowBlur: 3
	
	showDragEnd: ->
		@animate
			brightness: 100
			scale: 1
			shadowY: 0
			shadowBlur: 0
	
	getNewPosition: ->
		above = @parent.items[ @current.index + 1 ]
		below = @parent.items[ @current.index - 1 ]
		
		if @midY > above?.midY
			above.layer.takePosition( @current )
			@takePosition( above, animate = false )
			
		else if @midY < below?.midY
			below.layer.takePosition( @current )
			@takePosition( below, animate = false )
	
	takePosition: ( position, animate = true ) ->
		@current = position
		position.layer = @
		if animate then @animate { midY: position.midY }


# Implementation:

card = new Layer
	point: Align.center
	height: Screen.height - 32, width: Screen.width - 32
	backgroundColor: "#FFF"

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
		