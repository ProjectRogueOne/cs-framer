# Progress Bar 
# Authors: Steve Ruiz
# Last Edited: 5 Oct 17

class exports.ProgressBar extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		@showLayers = options.showLayers ? true

		{ app } = require 'App'

		@min = 0

		@max = 100

		@_value
		options.value ?= 66

		# set forced properties

		_.assign options,
			backgroundColor: '#DFDFDF'
			borderRadius: 999
			height: 12

		# set default properties

		super _.defaults options,
			name: 'Progress Bar'
			animationOptions:
				time: .5

		# layers

		@complete = new Layer 
			parent: @
			height: @height
			width: @width
			borderRadius: @borderRadius
			borderWidth: 1
			borderColor: '#979797'
			backgroundColor: '#d7d7d7'
		
		delete @__constructor

		# assign properties that required layers

		_.assign @,
			value: options.value

	_showValue: ->
		@complete.width = Utils.modulate(@value, [@min, @max], [0, @width])

	@define "value",
		get: -> return @_value
		set: (value) ->
			return if @__constructor
			@_value = value

			@_showValue()

			@emit "change:value", value, @