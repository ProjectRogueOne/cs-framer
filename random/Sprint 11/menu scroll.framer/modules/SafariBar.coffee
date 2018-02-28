# Safari Bar
# Authors: Steve Ruiz
# Last Edited: 25 Sep 17

Type = require 'Mobile'
{ Colors } = require 'Colors'
{ Icon } = require 'Icon'

class exports.SafariBar extends Layer
	constructor: (options = {}) ->
		
		showNames = options.showNames ? false

		super _.defaults options,
			width: Screen.width
			height: 64
			backgroundColor: 'rgba(255, 255, 255, .97)'
			shadowY: 1
			shadowColor: 'rgba(0,0,0,.16)'
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
		
		# center content
		
		@urlField = new TextLayer
			name: if showNames then 'URL Field' else '.'
			parent: @
			backgroundColor: Colors.field
			x: Align.center
			y: @statusBar.maxY + 4
			width: @width - 20
			height: 30
			fontSize: 16
			color: '#000'
			textAlign: 'center'
			padding: {top: 6}
			animationOptions: @animationOptions
			text: '{url}'

		@refreshIcon = new Icon
			name: if showNames then 'Refresh Icon' else '.'
			parent: @urlField
			x: Align.right(-8)
			y: Align.center
			color: '#000'
			icon: 'refresh'
			animationOptions: @animationOptions

		@url = 'clearscore.com'
	
	setHeader: (options) ->
		null

	setURL: (url) ->
		@urlField.template = url

	setHeightByFactor: (factor = 1) ->
		@emit "change:factor", factor, @

		# set height with a factor between 0 (closed) and 1 (open)
		@height = Utils.modulate(
			factor, 
			[0, 1], 
			[38, @_fullHeight], 
			true
		)
		
		for layer in [@urlField]
			layer.y = Utils.modulate(
				factor, 
				[0, 1], 
				[10, @statusBar.maxY + 4], 
				true
			)

			layer.backgroundColor = new Color(Colors.field).alpha(factor)

			layer.scale = Utils.modulate(
				factor, 
				[0, 1], 
				[.7, 1], 
				true
			)

		@refreshIcon.opacity = factor
			
	setStatus: (scrollY) ->		
		if @height > 60 or scrollY < 0
			@open()
		else 
			@close()
			
	open: ->
		@emit "open", @
		@animate { height: @_fullHeight }
		@status = 'open'
		
		for layer in [@urlField]
			layer.animate 
				y: @statusBar.maxY + 4, 
				backgroundColor: 'rgba(230, 230, 232,1)'
				scale: 1

		@refreshIcon.animate { opacity: 1 }

	close: ->
		@emit "close", @
		@animate { height: 38 }
		@status = 'closed'
		
		for layer in [@urlField]
			layer.animate 
				y: 10, 
				backgroundColor: 'rgba(230, 230, 232,0)'
				scale: .7
	
		@refreshIcon.animate { opacity: 0 }

	fadeTo: (callback) -> null

	@define "url",
		get: -> return @_url
		set: (url) ->
			@_url = url
			@urlField.template = url