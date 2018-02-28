# Switch
# Authors: Steve Ruiz
# Last Edited: 28 Sep 17

{ Icon } = require 'Icon'

class exports.Switch extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		@_isOn
		options.isOn ?= false

		_.assign options,
			width: 47, height: 28, borderRadius: 14
			color: '#e2e2e2'
			backgroundColor: 'rgba(0,0,0,.54)'
			animationOptions: {time: .15}

		super _.defaults options,
			name: 'Switch'

		@knob = new Layer
			name: 'Knob', parent: @
			x: 2, y: Align.center()
			width: 24, height: 24, borderRadius: 12
			backgroundColor: '#FFFFFF'
			animationOptions: {time: .15}
		
		offset = if Framer.Device.context.scale is 1 then 0 else 0

		@knobIcon = new Icon
			parent: @knob
			width: 14
			height: 14
			y: offset
			x: Align.center
			color: '#e2e2e2'
			icon: 'close'

		@on "change:isOn", @update
		@onTap -> @isOn = !@isOn

		delete @__constructor

		@isOn = options.isOn


	update: =>
		@animateStop()

		if @isOn
			@color = '#404f5d'
			@animate {backgroundColor: '#404f5d'}
			@knob.animate {x: Align.right(-2)}

			@knobIcon.color = '#404f5d'
			@knobIcon.icon = 'check'

		else 
			@color = '#e2e2e2'
			@animate {backgroundColor: '#e2e2e2'}
			@knob.animate {x: 2}

			@knobIcon.color = '#e2e2e2'
			@knobIcon.icon = 'close'


	@define "isOn",
		get: -> return @_isOn
		set: (bool) ->
			return if @__constructor
			return if bool is @_isOn
			
			@_isOn = bool
			
			@emit "change:isOn", bool, @
