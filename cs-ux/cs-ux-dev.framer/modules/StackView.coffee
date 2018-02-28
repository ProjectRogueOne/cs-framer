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


		Framer.Device.on "change:deviceType", =>
			Utils.delay .15, @stackView

	# add a layer to the stack
	addToStack: (layer, frame = {}, update = true) =>
		last = _.last(@stack)

		@stack.push(layer)

		if layer is _.head(@stack)
			startY = @padding.top
			layer._stackDiff = frame.y ? 0
		else
			startY = last.maxY
			layer._stackDiff = (@padding.stack ? 0) + (frame.y ? 0)

		_.assign layer,
			parent: @content
			width: _.clamp(layer.width, 0, @width - (@padding.left + @padding.right))
			x: frame.x ? _.clamp(layer.x, @padding.left, @width - layer.width - @padding.right)
			y: startY + layer._stackDiff

		layer.on "change:height", => @moveStack(@)
		
		if update then @updateContent()

		return @

	addLayersToStack: (layerOptions) =>
		for option, i in layerOptions
			@addToStack(option.layer, option.frame, false)

	
	# pull a layer from the stack
	removeFromStack: (layer) =>
		_.pull(@stack, layer)
	
	# stack layers in stack, with optional padding and animation
	stackView: (
		animate = false, 
		padding = @padding.stack ? 0, 
		top = @padding.top ? 0, 
		animationOptions = {time: .25}
	) =>

		animate = false
		last = undefined

		for layer, i in @stack
			
			if animate is true
				if i is 0 then layer.animate
					y: top
					options: animationOptions
					
				else layer.animate
					y: last.maxY + layer._stackDiff
					options: animationOptions
			else
				if i is 0
					layer.y = top
				else 
					layer.y = last.maxY + layer._stackDiff

			last = layer
		
		@contentInset.top = @padding.top ? 0
		@contentInset.bottom = @padding.bottom ? 0
		@updateContent()
	
	# move stack when layer height changes
	moveStack: (layer) =>
		index = _.indexOf(@stack, layer)
		for layer, i in @stack
			return if i is 0
			return if i < index

			last = @stack[i - 1]
			layer.y = (last?.maxY ? 0) + layer._stackDiff

		@updateContent()
	
	# build with view as bound object
	build: (func) -> do _.bind(func, @)

	# refresh view
	refresh: -> null
	
	@define "stack",
		get: -> return @_stack
		set: (layers) ->
			layer.destroy() for layer in @stack
			@addToStack(layers)



		