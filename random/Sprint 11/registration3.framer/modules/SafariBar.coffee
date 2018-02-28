# Safari Bar
# Authors: Steve Ruiz
# Last Edited: 25 Sep 17

Type = require 'Mobile'
{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
{ MobileHeader } = require 'MobileHeader'

class exports.SafariBar extends MobileHeader
	constructor: (options = {}) ->
		@__constructor = true
		showNames = options.showNames ? false

		options.url ?= 'clearscore.com'
		@status = 'open'

		# always collapse
		options.collapse = true

		super options

		# status bar

		@statusBar = new Layer
			name: 'Status Bar'
			parent: @
			width: @width
			height: Screen.width * (40/750)
			image: "images/statusBar_light.png"
		
		@_closedHeight = @statusBar.height

		# url field
		
		@urlField = new TextLayer
			name: if showNames then 'URL Field' else '.'
			parent: @
			backgroundColor: Colors.field1
			x: Align.center
			y: @statusBar.maxY + 4
			width: @width - 20
			height: 30
			fontSize: 16
			color: '#000'
			textAlign: 'center'
			padding: {top: 6}
			animationOptions: @animationOptions
			borderRadius: 8
			text: '{url}'

		# refresh icon
		
		@refreshIcon = new Icon
			name: if showNames then 'Refresh Icon' else '.'
			parent: @urlField
			x: Align.right(-8)
			y: Align.center
			color: '#000'
			icon: 'refresh'
			animationOptions: @animationOptions

		delete @__constructor

		@url = options.url 
			
		@on "change:factor", (factor) ->
			for layer in [@urlField]
				layer.y = Utils.modulate(
					factor, 
					[0, 1], 
					[10, @statusBar.maxY + 4], 
					true
					)

				layer.backgroundColor = new Color(Colors.field1).alpha(factor)

				layer.scale = Utils.modulate(
					factor, 
					[0, 1], 
					[.7, 1], 
					true
					)

			@refreshIcon.opacity = factor
				
		@on "change:status", (status) ->
			switch status
				when 'open'
					for layer in [@urlField]
						layer.animate 
							y: @statusBar.maxY + 4, 
							backgroundColor: Colors.field1
							scale: 1

					@refreshIcon.animate { opacity: 1 }
				when 'close'
					for layer in [@urlField]
						layer.animate 
							y: 10, 
							backgroundColor: new Color(Colors.field1).alpha(0)
							scale: .7
				
					@refreshIcon.animate { opacity: 0 }

	@define "url",
		get: -> return @_url
		set: (url) ->
			return if @__constructor 

			@_url = url
			@urlField.template = url