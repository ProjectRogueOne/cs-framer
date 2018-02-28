# Overlay
# Authors: Steve Ruiz
# Last Edited: 18 Oct 17

{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
{ app } = require 'App'

class exports.Overlay extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		showNames = options.showNames ? false

		{ app } = require 'App'

		# set forced options

		_.assign options,
			y: app.header?.maxY
			height: Screen.height
			width: Screen.width
			backgroundColor: Colors.main
			opacity: 0
			animationOptions:
				time: .25

		# set default options

		super _.defaults options,
			name: 'Overlay'
			suicide: true

		@suicide = options.suicide

		# layers

		@closeButton = new Icon
			name: if @showNames then "Close" else "."
			parent: @
			x: Align.right(-25)
			y: 23
			color: 'white'
			type: 'close'

		# events

		@onTap (event) -> event.stopPropagation()
		@closeButton.onTap @hide
		
		@closeButton.onTap =>
			if app.current is @
				app.showPrevious()

		# set properties that need layers

		delete @__constructor

	show: ->
		@bringToFront()

		@visible = true

		@animate
			opacity: 1
			options:
				curve: 'easeIn'

	hide: =>

		@animate
			opacity: 0
			options:
				curve: 'easeOut'

		if @suicide then @onAnimationEnd _.once(-> @destroy())