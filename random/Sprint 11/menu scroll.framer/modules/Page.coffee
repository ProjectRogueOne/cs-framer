# Page
# Authors: Steve Ruiz
# Last Edited: 20 Sep 17

class exports.Page extends ScrollComponent
	constructor: (options = {}) ->
		
		# stack related
		@_stack = []
		@padding = options.padding ? {
			top: 16, right: 0, 
			bottom: 0, left: 16
			stack: 16
			}
		
		# header settings
		@left = options.left
		@right = options.right
		@title = options.title
		
		super _.defaults options,
			size: Screen.size
			scrollHorizontal: false
			backgroundColor: Screen.backgroundColor
			
		@content.backgroundColor = Screen.backgroundColor
		
		# collapsing header related
		@_startScroll = undefined
		@onScrollStart => @_startScroll = @scrollPoint
	
	# add a layer to the stack
	addToStack: (layers = []) =>
		if not _.isArray(layers) then layers = [layers]
		
		for layer in layers
			layer.parent = @content
			layer.x = @padding.left ? 0
			layer.y = @padding.top ? 0
			@stack.push(layer)
		
		@stackView()
	
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
	
	# build with page as bound object
	build: (func) -> do _.bind(func, @)

	# refresh page
	refresh: -> null
	
	@define "stack",
		get: -> return @_stack
		set: (layers) ->
			layer.destroy() for layer in @stack
			@_stack = []
			@addToStack(layers)
			