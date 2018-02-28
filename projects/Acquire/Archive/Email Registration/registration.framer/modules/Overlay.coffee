# Overlay
# Authors: Steve Ruiz
# Last Edited: 29 Sep 17

{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
{ app } = require 'App'

class exports.Overlay extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		showNames = options.showNames ? false

		{ app } = require 'App'

		options.fill ?= 'main'

		_.assign options,
			y: app.header?.maxY
			height: Screen.height - app.header?.maxY
			width: Screen.width
			backgroundColor: Colors.main
			opacity: 0

		super _.defaults options,
			name: 'Overlay'

		@closeButton = new Icon
			parent: @
			x: Align.right(-20)
			y: 20
			color: 'white'
			type: 'close'

		# fade in on load
		@animate
			opacity: 1
			options:
				time: .15

		# fade out on close button tap
		@closeButton.onTap =>
			@onAnimationEnd @destroy

			@animate
				opacity: 0
				options:
					time: .25

		@onTap (event) -> event.stopPropagation()

		delete @__constructor

		@fill = options.fill

	@define "fill",
		get: -> return @_fill
		set: (string) ->
			return if @__constructor
			@_fill = Colors.validate(string) ? Colors.primary
			@backgroundColor = @_fill