# StackView
# Authors: Steve Ruiz
# Last Edited: 27 Sep 17

class exports.StackView extends ScrollComponent
	constructor: (options = {}) ->
		showLayers = options.showLayers ? false

		# stack related
		@_stack = []
		@padding = options.padding ? {
			top: 16, right: 12, 
			bottom: 0, left: 12
			stack: 16
			}
		
		super _.defaults options,
			name: 'Stack View'
			size: Screen.size
			scrollHorizontal: false
			contentInset: { bottom: 16 }
		
		@mouseWheelEnabled = true
		@content.clip = false
		@content.backgroundColor = @backgroundColor
		@content.name = if options.showLayers then 'content' else '.'
		@content.padding = @padding

	# add a layer to the stack
	addToStack: (layers = [], frame = {}) =>
		if not _.isArray(layers) then layers = [layers]
		
		last = _.last(@stack)
		if last?
			startY = last.maxY + (@padding.stack ? 0)
		else
			startY = @padding.top ? 0
		
		for layer in layers

			layer.width = _.clamp(layer.width, 0, @width - (@padding.left + @padding.right))
			layer.parent = @content
			layer.x = frame.x ? _.clamp(layer.x, @padding.left, @width - layer.width - @padding.right)
			layer.y = frame.y ? startY
			@stack.push(layer)
			
			layer.on "change:height", => @moveStack(@)
			
		@updateContent()
	
	# pull a layer from the stack
	removeFromStack: (layer) =>
		_.pull(@stack, layer)
	
	# stack layers in stack, with optional padding and animation
	stackView: (
		animate = false, 
		padding = @padding.stack, 
		top = @padding.top, 
		animationOptions = {time: .25}
	) =>
	
		for layer, i in @stack
			
			if animate is true
				if i is 0 then layer.animate
					y: top
					options: animationOptions
					
				else layer.animate
					y: @stack[i - 1].maxY + padding
					options: animationOptions
			else
				if i is 0 then layer.y = top
				else layer.y = @stack[i - 1].maxY + padding
				
		@updateContent()
	
	# move stack when layer height changes
	moveStack: (layer) =>
		index = _.indexOf(@stack, layer)
		for layer, i in @stack
			if i > 0 and i > index
				layer.y = @stack[i - 1].maxY + @padding.stack
				
	
	# build with view as bound object
	build: (func) -> do _.bind(func, @)

	# refresh view
	refresh: -> null
	
	@define "stack",
		get: -> return @_stack
		set: (layers) ->
			layer.destroy() for layer in @stack
			@addToStack(layers)



		