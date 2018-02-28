# Checkbox
# Authors: Steve Ruiz
# Last Edited: 27 Sep 17

{ Icon } = require 'Icon'
{ Colors } = require 'Colors'

class exports.Checkbox extends Icon
	constructor: (options = {}) ->
		@__constructor = true

		@_group = undefined

		options.checked ?= false
		options.color ?= "black"
		options.offColor ?= "black"

		super _.defaults options,
			name: 'Checkbox'
			icon: 'checkbox-blank-outline'
			toggle: true
			action: -> null
			animationOptions: {time: .15}

		@on "change:isOn", @updateIcon

		delete @__constructor

		@checked = options.checked

	updateIcon: =>
		@icon = if @isOn then 'checkbox-marked' else 'checkbox-blank-outline' 

	@define "group",
		get: -> return @_group
		set: (array) ->
			return if array is @_group
			@_group = array

			# add this checkbox to the group array if not in it already
			if not _.includes(@_group, @) then @_group.push(@)

	@define "checked",
		get: -> return @isOn
		set: (bool) ->
			return if @__constructor
			@isOn = bool