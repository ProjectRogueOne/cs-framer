# IOS Navigation Bar
# Authors: Steve Ruiz
# Last Edited: 29 Sep 17

Type = require 'Mobile'
{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
{ MobileHeader } = require 'MobileHeader'

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
			image: "images/statusBar_light.png"
		
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
			
			@text = new Type.H3
				name: 'Text'
				parent: @
				x: 8, 
				y: Align.center
				width: @width
				fontWeight: 600
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
			
			@text = new Type.H3
				name: 'Text'
				parent: @
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
			
			@text = new Type.H3
				name: 'Title'
				parent: @
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

		@on "load", (options) ->
			for layer in [@leftContent, @rightContent, @centerContent]
				layer.animate { opacity: 0, options: { time: .15 } }
			
			Utils.delay .2, =>
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

				for layer in [@leftContent, @rightContent, @centerContent]
					layer.animate { opacity: 1, options: { time: .25 } }

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
