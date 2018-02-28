# IOS Navigation Bar
# Authors: Steve Ruiz
# Last Edited: 29 Sep 17

# Todo: 
# Replace the status bar image with three SVG layers, so that it works on all device sizes.

Type = require 'Mobile'
{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
{ MobileHeader } = require 'MobileHeader'
{ Text } = require 'Text'

class exports.IOSBar extends MobileHeader
	constructor: (options = {}) ->
		@__constructor = true
		showNames = options.showNames ? false
		options.name = 'iOS Navigation Bar'

		super options

		# status bar

		@statusBar = new Layer
			name: 'Status Bar'
			parent: @
			width: @width
			height: Screen.width * (40/750)
			image: "modules/cs-ux-images/ios_status_bar.png"
		
		@_closedHeight = @statusBar.height

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
				color: Colors.tint
				icon: 'star-outline'
				visible: false
			
			@text = new Text
				name: 'Text'
				type: 'body'
				parent: @
				x: 8, 
				y: Align.center
				width: @width
				color: Colors.tint
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
				color: Colors.tint
				icon: 'star-outline'
				visible: false
			
			@text = new Text
				name: 'Text'
				parent: @
				type: 'body'
				x: Align.right(-8)
				y: Align.center
				width: @width
				fontWeight: 600
				textAlign: 'right'
				textTransform: "capitalize"
				color: Colors.tint
				text: '{value}'
				visible: false
			
		, @rightContent )

		delete @__constructor
		
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
			
			@text = new Text
				name: 'Text'
				parent: @
				type: 'body'
				x: 0
				y: Align.center
				width: @width
				fontWeight: 500
				textAlign: 'center'
				textTransform: "capitalize"
				color: Colors.bright
				text: '{value}'
				visible: false
			
		, @centerContent )

		@on "change:factor", (factor) ->
			for layer in [@leftContent, @rightContent, @centerContent]
				layer.opacity = factor
				layer.y = Utils.modulate(
					factor, 
					[0, 1], 
					[0, @statusBar.height], 
					true
				)

		@on "change:status", (status) ->
			switch status
				when 'open'
					for layer in [@leftContent, @rightContent, @centerContent]
						layer.animate { opacity: 1, y: @statusBar.height }
				when 'closed'
					for layer in [@leftContent, @rightContent, @centerContent]
						layer.animate { opacity: 0, y: 0 }

	setSide: (side, options = {}) =>
		icon = options.icon ? undefined
		text = options.text ? undefined
		action = options.action ? -> null
		
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
			textDistance = 36 
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

		
	setHeader: (title, left, right) ->

		@centerContent.onAnimationEnd _.once =>
			@setSide('left', left)
			@setSide('right', right)
			
			@centerContent.text.visible = title?
			@centerContent.text.template = title

			for layer in [@leftContent, @rightContent, @centerContent]
				layer.animateStop()
				layer.animate { opacity: 1, options: { time: .25 } }

		for layer in [@leftContent, @rightContent, @centerContent]
			layer.animate { opacity: 0, options: { time: .15 } }
		
