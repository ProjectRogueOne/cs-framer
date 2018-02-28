# Puller
# Authors: Steve Ruiz
# Last Edited: 29 Sep 17

{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
{ Text } = require 'Text'

class exports.Puller extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		showNames = options.showNames ? false

		options.fill ?= 'dark'
		options.text ?= 'Please review your details carefuly. They are key for us to be able to find your report. Should you spot a mistake simply press ‘Update’ to correct the information.'
		options.color?= 'white'

		super _.defaults options,
			width: Screen.width
			height: 64
			backgroundColor: Colors.main

		# fade out on close button tap
		@textLayer = new Text 
			name: if showNames then 'Text' else '.'
			parent: @
			y: 11
			x: 15
			type: 'body1'
			text: options.text
			color: options.color

		@height = @textLayer.maxY + 16

		delete @__constructor

		@fill = options.fill

	@define "fill",
		get: -> return @_fill
		set: (string) ->
			return if @__constructor
			@_fill = Colors.validate(string) ? Colors.primary
			@backgroundColor = @_fill