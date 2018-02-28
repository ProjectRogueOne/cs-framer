# Checkbox
# Authors: Steve Ruiz
# Last Edited: 25 Sep 17

{ Icon } = require 'Icon'
{ Colors } = require 'Colors'

class exports.Checkbox extends Icon
	constructor: (options = {}) ->

		@_group = undefined

		super _.defaults options,
			name: '.'
			animationOptions: {time: .15}
			icon: 'checkbox-blank-outline'
			color: Colors.main
			toggle: true
			action: -> null

		@on "change:isOn", @updateIcon

	updateIcon: =>
		@icon = if @isOn then 'checkbox-marked' else 'checkbox-blank-outline' 

	@define "group",
		get: -> return @_group
		set: (array) ->
			return if array is @_group
			@_group = array

			# add this checkbox to the group array if not in it already
			if not _.includes(@_group, @) then @_group.push(@)