# Flex Row
# Authors: Steve Ruiz
# Last Edited: 21 Nov 17

class exports.FlexRow extends Layer
	constructor: (options = {}) ->
		
		_.assign @,
			gutter: 0
			breakpoints:
				xs: 
					name: 'xsmall'
					width: 360
					gutter: 16
				s: 
					name: 'small'
					width: 600
					gutter: 24
				m: 
					name: 'medium'
					width: 1024
					gutter: 24
				l: 
					name: 'large'
					width: 1440
					gutter: 24
				xl: 
					name: 'xlarge'
					width: 1920
					gutter: 24
				inf:
					name: 'xxlarge'
					width: 9999
					gutter: 24

			minWidth: undefined
			maxWidth: undefined
			fullWidth: undefined
		
		_.assign options,
			backgroundColor: null
			
		_.defaults options,
			minWidth: 0
			maxWidth: 600
			fullWidth: false
		
		for breakpoint in ['xs', 's', 'm', 'l', 'xl']
			_.defaults options[breakpoint],
				width: @breakpoints[breakpoint].width
				gutter: @breakpoints[breakpoint].gutter
		
		super options
		
		_.assign @,
			minWidth: options.minWidth
			maxWidth: options.maxWidth
			fullWidth: options.fullWidth
			
		@content = new Layer
			parent: @
			width: @width
			name: 'content'
			backgroundColor: null
			
		throttledSetSize = Utils.debounce .15, @setSize
		
		@content.on "change:children", @centerContent
		@on "change:size", throttledSetSize
		Events.wrap(window).addEventListener "resize", throttledSetSize
		Framer.Device.on "change:deviceType", =>
			Utils.delay 0, throttledSetSize
		
		@setSize()
		
	centerContent: =>
		@content.x = Align.center()
		return if @content.children.length <= 0
		
		for child in @content.children
			child.width = @content.width
			child.x = 0
		
	getBreakpoint: =>
		bp = undefined
		
		for breakpoint, size of @breakpoints
			bp = @breakpoints[breakpoint]
			if @width < size.width
				return bp
	
	setSize: =>
		_.assign @,
			width: Screen.width
			height: _.maxBy(@content.children, 'maxY')?.maxY ? 64
		
		@content.height = @height
			
		@breakpoint = @getBreakpoint()
		@maxWidth ?= Screen.width
		
		width = _.clamp(@width - (@breakpoint?.gutter ? 0), @minWidth, @maxWidth)
		if @fullWidth then width = @width
		
		_.assign @content,
			width: width
			x: Align.center()
		
		@centerContent()
		
		if @width is Screen.width
			return
		
		Utils.delay .25, => @setSize()
		
	@define "fullWidth",
		get: -> return @_fullWidth
		set: (bool) ->
			@_fullWidth = bool