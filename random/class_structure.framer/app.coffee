class Card extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		#-  Private properties:

		@_starred
		options.starred ?= false

		#-  Assigned options:

		_.assign options,
			width: 240
			borderRadius: 16
			height: 320

		#-  Default options:

		_.defaults options,
			name: 'Card'
			backgroundColor: '#FFF'
			shadowY: 1
			shadowBlur: 3
		
		super options

		#- Layers:

		@starLayer = new Layer
			parent: @
			x: Align.right(-16)
			y: 16
			width: 24
			height: 24
			borderRadius: 12

		#- Events:

		@starLayer.onTap => @starred = !@starred
		
		@on "change:starred", @toggleStar

		#-  Kickoff:

		delete @__constructor

		@starred = options.starred

	#-  Class methods:

	toggleStar: =>
		if @starred
			@starLayer.backgroundColor = "orange"
			return

		@starLayer.backgroundColor = "grey"

	#-  Definitions:

	@define "starred",
		get: -> return @_starred
		set: (value) ->
			return if @__constructor

			@_starred = value

			@emit "change:starred", value, @

card = new Card
