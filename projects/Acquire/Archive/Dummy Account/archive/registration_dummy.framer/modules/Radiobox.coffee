# Radiobox
# Authors: Steve Ruiz
# Last Edited: 27 Sep 17

{ Icon } = require 'Icon'
{ Colors } = require 'Colors'

class exports.Radiobox extends Icon
	constructor: (options = {}) ->

		@_group = undefined
		options.group ?= []
		options.color ?= "black"
		options.offColor ?= "black"

		super _.defaults options,
			name: 'Radiobox'
			animationOptions: {time: .15}
			icon: 'radiobox-blank'
			toggle: true
			toggleLock: true
			action: -> null

		@on "change:isOn", ->
			@updateIcon()
			@updateSiblings()

	updateIcon: =>
		@icon = if @isOn then 'radiobox-marked' else 'radiobox-blank' 

	updateSiblings: =>
		if @isOn then sib.isOn = false for sib in _.without(@group, @)
		@group.selected = @