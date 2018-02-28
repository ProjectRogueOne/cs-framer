# Puller
# Authors: Steve Ruiz
# Last Edited: 4 Oct 17

{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
{ Text } = require 'Text'

class exports.Puller extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		showNames = options.showNames ? false

		@_fill
		options.fill ?= 'dark'

		@_text
		options.text ?= 'Please review your details carefuly. They are key for us to be able to find your report. Should you spot a mistake simply press ‘Update’ to correct the information.'

		# set forced properties

		_.assign options,
			fill: 'main'

		# set default properties

		super _.defaults options,
			width: Screen.width
			height: 64

		# layers

		# text layer

		@textLayer = new Text 
			name: if showNames then 'Text' else '.'
			parent: @
			y: 11
			x: 15
			width: @width - 30
			type: 'body1'
			text: options.text
			color: Colors.white

		@height = @textLayer.maxY + 16

		delete @__constructor

		# assign properties that require layers

		_.assign @,
			text: options.text 
			fill: options.fill

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
			@height = @textLayer.maxY + 16




