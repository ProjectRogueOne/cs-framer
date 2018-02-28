# Puller
# Authors: Steve Ruiz
# Last Edited: 21 Nov 17

{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
{ Text } = require 'Text'
{ FlexRow } = require 'FlexRow'

class exports.Puller extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		options.showNames = true

		@_fill
		@_text

		# set default properties

		_.defaults options,
			name: if options.showNames then 'Puller' else '.'
			width: Screen.width
			height: 64
			arrow: true
			fill: 'main'
			text: 'Please review your details carefuly. They are key for us to be able to find your report. Should you spot a mistake simply press ‘Update’ to correct the information.'
			clip: false

		super options

		# layers

		# text layer

		@textLayer = new Text 
			name: if options.showNames then 'Text' else '.'
			parent: @
			y: 16
			x: 15
			width: @width - 30
			type: 'body1'
			text: options.text
			color: Colors.white

		@height = @textLayer.maxY + 16

		if options.arrow
			@arrow = new Layer
				name: if options.showNames then 'Arrow' else ''
				parent: @
				height: 16
				width: 16
				rotation: 45
				backgroundColor: @backgroundColor
				x: 16
				y: Align.bottom(8)

			@arrow.sendToBack()

		delete @__constructor

		# assign properties that require layers

		@on "change:backgroundColor", =>
			@arrow?.backgroundColor = @backgroundColor

		_.assign @,
			text: options.text 
			fill: options.fill

		@throttledSetSize = Utils.throttle .05, @_setSize
		@on "change:size", @throttledSetSize

		@_setSize()

	_setSize: =>
		width = _.clamp(@width - 32, null, 1127)
		@textLayer?.width = width
		@textLayer?.x = Align.center()

		@height = @textLayer.maxY + 16

		@arrow?.x = @textLayer.x
		@arrow?.y = Align.bottom(8)

		@emit "setSize"

	@define "fill",
		get: -> return @_fill
		set: (string) ->
			return if @__constructor

			@_fill = Colors.validate(string) ? Colors.primary
			@backgroundColor = @_fill

	@define "text",
		get: -> return @_text
		set: (string) ->
			return if @__constructor

			@_text = string
		
			@textLayer.text = string





