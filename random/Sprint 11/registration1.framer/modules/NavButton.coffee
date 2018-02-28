# NavButton
# Authors: Steve Ruiz
# Last Edited: 27 Sep 17
 
{ Button } = require 'Button'

class exports.NavButton extends Button
	constructor: (options = {}) ->

		options.name ?= 'NavButton'
		options.type = 'body1'
		options.fill = 'transparent'
		options.color = 'white'
		options.textTransform = 'uppercase'
		options.padding = {left: 18, right: 18}
		options.toggle = true
		options.toggleLock = true
		options.height = 30

		super options

		@on "change:isOn", (isOn) ->
			@updateSiblings()
			if isOn
				@color = 'black'
				@fill = 'white'
			else
				@color = 'white'
				@fill = 'transparent'

	# override to remove toggled state
	showPressed: (isPressed) ->
		@animateStop()
		if isPressed then @animate {brightness: 80}
		else @animate {brightness: 100}