# NavButton
# Authors: Steve Ruiz
# Last Edited: 4 Oct 17
 
{ Button } = require 'Button'

class exports.NavButton extends Button
	constructor: (options = {}) ->

		# set forced options

		_.assign options,
			toggle: true
			toggleLock: true

		# set default options

		super _.defaults options,
			name: 'NavButton'
			type: 'body'
			color: 'black'
			fill: 'transparent'
			size: 'auto'
			padding: { left: 18, right: 18, top: 5, bottom: 5 }

		# events

		@on "change:isOn", -> @showToggled()

	showToggled: =>
		if @isOn
			@color = 'black'
			@fill = 'white'
		else
			@color = 'white'
			@fill = 'transparent'

	showPressed: (isPressed) ->
		@animateStop()
		if isPressed
			@animate {brightness: 80}
		else 
			@animate {brightness: 100}