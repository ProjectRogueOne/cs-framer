# NavButton
# Authors: Steve Ruiz
# Last Edited: 3 Oct 17
 
{ Button } = require 'Button'

class exports.NavButton extends Button
	constructor: (options = {}) ->

		# set forced options

		_.assign options,
			type: 'body1'
			fill: 'transparent'
			color: 'white'
			textTransform: 'uppercase'
			padding: {left: 18, right: 18}
			toggle: true
			toggleLock: true
			height: 30

		# set default options

		super _.defaults options,
			name: 'NavButton'

		# events

		@on "change:isOn", (isOn) ->
			@updateSiblings()
			if isOn
				@color = 'black'
				@fill = 'white'
			else
				@color = 'white'
				@fill = 'transparent'

	showPressed: (isPressed) ->
		@animateStop()
		if isPressed then @animate {brightness: 80}
		else @animate {brightness: 100}