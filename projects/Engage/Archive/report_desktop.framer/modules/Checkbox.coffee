# Checkbox
# Authors: Steve Ruiz
# Last Edited: 1 Nov 17

{ Icon } = require 'Icon'
{ Colors } = require 'Colors'

class exports.Checkbox extends Icon
	constructor: (options = {}) ->
		@__constructor = true

		@_group = undefined

		_.defaults options,
			name: 'Checkbox'
			icon: 'checkbox-blank-outline'
			toggle: true
			checked: false
			color: 'black'
			offColor: 'black'
			action: -> null
			animationOptions: {time: .15}

		super options

		@on "change:isOn", @updateIcon

		delete @__constructor

		_.assign @,
			checked: options.checked
			isOn: options.isOn

	updateIcon: =>
		if @isOn
			@icon = 'checkbox-marked'
			return

		@icon = 'checkbox-blank-outline' 

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
			return if bool is @isOn
			
			@isOn = bool

			@emit "change:checked", bool, @