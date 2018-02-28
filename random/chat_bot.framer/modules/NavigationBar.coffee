# Navigation Bar

Type = require 'Type'
{ colors } = require 'Colors'
{ Icon } = require 'Icon'

class exports.NavigationBar extends Layer
	constructor: (options = {}) ->
		
		showNames = options.showNames ? false
		
		super _.defaults options,
			width: Screen.width
			height: 64
			backgroundColor: 'rgba(255, 255, 255, .97)'
			shadowY: 2
			shadowColor: colors.pale
			shadowBlur: 3
			clip: true
			animationOptions: { time: .15 }
			
		@_fullHeight = @height
		@status = 'open'

		@statusBar = new Layer
			name:if showNames then 'Status Bar' else '.'
			parent: @
			width: @width
			height: Screen.width * (40/750)
			image: "images/statusBar_light.png"
		
		# left content
		
		@leftContent = new Layer
			name: if showNames then 'Left Content' else '.'
			parent: @
			backgroundColor: null
			x: 0
			y: @statusBar.height
			height: @height - @statusBar.height
			width: @width * .33
			animationOptions: @animationOptions
		
		do _.bind( ->
			
			@action = -> null
			@onTap -> @action()
			
			@icon = new Icon
				name: 'Icon'
				parent: @
				x: 8, 
				y: Align.center
				color: colors.tint
				icon: 'star-outline'
				visible: false
			
			@text = new Type.H2
				name: 'Text'
				parent: @
				x: 8, 
				y: Align.center
				width: @width
				fontWeight: 600
				color: colors.tint
				textTransform: "capitalize"
				text: '{value}'
				visible: false
			
		, @leftContent )
		
		# right content
		
		@rightContent = new Layer
			name: if showNames then 'Right Content' else '.'
			parent: @
			backgroundColor: null
			x: Align.right
			y: Align.bottom
			height: @height - @statusBar.height
			width: @width * .33
			animationOptions: @animationOptions
		
		do _.bind( ->
			
			@action = -> null
			@onTap -> @action()
			
			@icon = new Icon
				name: 'Icon'
				parent: @
				x: Align.right(-8)
				y: Align.center
				color: colors.tint
				icon: 'star-outline'
				visible: false
			
			@text = new Type.H2
				name: 'Text'
				parent: @
				x: Align.right(-8)
				y: Align.center
				width: @width
				fontWeight: 600
				textAlign: 'right'
				textTransform: "capitalize"
				color: colors.tint
				text: '{value}'
				visible: false
			
		, @rightContent )
		
		# center content
		
		@centerContent = new Layer
			name: if showNames then 'Center Content' else '.'
			parent: @
			backgroundColor: null
			x: Align.center
			y: Align.bottom
			height: @height - @statusBar.height
			width: @width * .33
			animationOptions: @animationOptions
			
		do _.bind( ->
			
			@action = -> null
			@onTap -> @action()
			
			@text = new Type.H2
				name: 'Title'
				parent: @
				x: 0
				y: Align.center
				width: @width
				fontWeight: 500
				textAlign: 'center'
				textTransform: "capitalize"
				color: colors.bright
				text: '{value}'
				visible: false
			
		, @centerContent )
	
	setHeader: (options) ->
		side = options.side
		icon = options.icon ? undefined
		text = options.text ? undefined
		action = options.action ? -> null
		title = options.title ? undefined
		
		@centerContent.text.visible = title?
		@centerContent.text.template = title
		
		set = ->
			@action = action
			@icon.visible = icon?
			@icon.icon = icon
			@text.visible = text?
			@text.template = text
		
		iconDistance = undefined
		textDistance = undefined

		if icon? and text?
			iconDistance = 8
			textDistance = 32 
		else
			iconDistance = 12
			textDistance = 16

		switch side
			when 'left'
				do _.bind(set, @leftContent )
				@leftContent.icon.x = iconDistance
				@leftContent.text.x = textDistance
			when 'right'
				do _.bind(set, @rightContent )
				@rightContent.icon.x = Align.right(-iconDistance)
				@rightContent.text.x = Align.right(-textDistance)
	
	setHeightByFactor: (factor = 1) ->
		# set height with a factor between 0 (closed) and 1 (open)
		@height = Utils.modulate(
			factor, 
			[0, 1], 
			[@statusBar.height, @_fullHeight], 
			true
		)
		
		for layer in [@leftContent, @rightContent, @centerContent]
			layer.opacity = factor
			layer.y = Utils.modulate(
				factor, 
				[0, 1], 
				[0, @statusBar.height], 
				true
			)
			
	setStatus: (scrollY) ->		
		if @height > (@_fullHeight / 2) or scrollY < 0
			@open()
		else 
			@close()
			
	open: ->
		@animate { height: @_fullHeight }
		@status = 'open'
		
		for layer in [@leftContent, @rightContent, @centerContent]
			layer.animate { opacity: 1, y: @statusBar.height }
		
	close: ->
		@animate { height: 20 }
		@status = 'closed'
		
		for layer in [@leftContent, @rightContent, @centerContent]
			layer.animate { opacity: 0, y: 0 }
	
	fadeTo: (callback) ->
		for layer in [@leftContent, @rightContent, @centerContent]
			layer.animate { opacity: 0 }
			
		Utils.delay .25, => 
			callback()
			for layer in [@leftContent, @rightContent, @centerContent]
				layer.animate { opacity: 1 }