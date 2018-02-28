# Checkbox
# Authors: Steve Ruiz
# Last Edited: 20 Sep 17

{ Icon } = require 'Icon'

class exports.Checkbox extends Icon
	constructor: (options = {}) ->

		super _.defaults options,
			name: 'Checkbox'
			animationOptions: {time: .15}
			icon: 'checkbox-blank-outline'
			color: '#404F5D'
			onColor: '#404F5D'
			toggle: true
			action: -> null

		@on "change:isOn", -> 
			@icon = if @isOn then 'checkbox-marked' else 'checkbox-blank-outline' 