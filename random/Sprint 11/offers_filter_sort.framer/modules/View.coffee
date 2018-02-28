# View
# Authors: Steve Ruiz
# Last Edited: 25 Sep 17

Type = require 'Mobile'
{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
Flow = require 'Flow'
flow = Flow.flow

class exports.View extends ScrollComponent
	constructor: (options = {}) ->

		flow = Flow.flow

		# stack related
		@_stack = []
		@padding = options.padding ? {
			top: 16, right: 0, 
			bottom: 0, left: 16
			stack: 16
			}

		@_startScroll = undefined
		
		# header
		@left = options.left
		@right = options.right
		@title = options.title
		
		@onLoad = options.onLoad ? -> null
		
		super _.defaults options,
			name: options.title ? 'View'
			size: Screen.size
			scrollHorizontal: false
			backgroundColor: Colors.page
			shadowSpread: 1
			shadowColor: Colors.pale 
			shadowBlur: 3
			contentInset: {top: flow.header.height + 16, bottom: 241}
		
		@content.clip = false
		
		@content.on "change:children", (change) =>			
			for layer in change.added
				layer.on "change:height", =>
					@stackView()
				
		@onScrollStart => @_startScroll = @scrollPoint
		@onScroll @adjustHeader
		@onScrollEnd => flow.header.setStatus(@scrollPoint.y)
	
	adjustHeader: =>
		currentY = @scrollPoint.y
		startY = @_startScroll?.y ? @scrollPoint.y
		distance = currentY - startY
		
		switch flow.header.status
			when 'open'
				closeFactor = Utils.modulate(
					distance, 
					[96, 160], 
					[1, 0], 
					true
				)
				flow.header.setHeightByFactor(closeFactor)
				@emit "change:closeFactor", closeFactor
			when 'closed'
				openFactor = Utils.modulate(
					distance, 
					[-96, -160], 
					[0, 1], 
					true
				)
				flow.header.setHeightByFactor(openFactor)
				@emit "change:openFactor", openFactor

	
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

	refresh: -> null

	@define "stack",
		get: -> return @_stack
		set: (layers) ->
			layer.destroy() for layer in @stack
			@_stack = []
			@addToStack(layers)
			