# Checkbox
# Authors: Steve Ruiz
# Last Edited: 28 Sep 17

{ Text } = require 'Text'

class exports.Toggle extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		options.isOn ?= false

		super _.defaults options,
			name: 'Toggle'
			height: 24
			width: 108
			borderWidth: 1
			borderColor: 'rgba(151, 151, 151, 1.000)'
			backgroundColor: 'rgba(216, 216, 216, 1.000)'
			borderRadius: 24
			animationOptions: { time: .15 }

		@closedLabel = new Text
			parent: @
			x: Align.right(-2)
			y: Align.center(1)
			scale: .8
			type: 'caption'
			text: 'CLOSED'
			color: 'black'
			animationOptions: @animationOptions

		@knob = new Layer
			parent: @
			width: 46
			height: 24
			borderRadius: 24
			backgroundColor: 'rgba(255, 255, 255, 1.000)'
			animationOptions: @animationOptions

		@openLabel = new Text
			parent: @knob
			x: Align.center
			y: Align.center(1)
			scale: .8
			type: 'caption'
			text: 'OPEN'
			color: 'black'
			animationOptions: @animationOptions

		delete @__constructor

		@onTap -> @isOn = !@isOn
		
		@isOn = options.isOn

	@define "isOn",
		get: -> return @_isOn
		set: (bool) ->
			return if @__constructor
			return if bool is @_isOn
			
			@_isOn = bool
			@emit("change:isOn", @_isOn, @)
			@update()

	update: ->
		if @_isOn
			@knob.animate {x: Align.right()}
			@openLabel.animate { opacity: 1 }
			@closedLabel.animate { opacity: 0 }
		else 
			@knob.animate {x: 0}
			@openLabel.animate { opacity: 0 }
			@closedLabel.animate { opacity: 1 }
