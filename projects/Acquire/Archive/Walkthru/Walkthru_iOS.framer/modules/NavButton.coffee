# NavButton
# Authors: Steve Ruiz
# Last Edited: 1 Nov 17
 
{ Button } = require 'Button'
{ app } = require 'App'

class exports.NavButton extends Button
	constructor: (options = {}) ->

		{ app } = require 'App'

		# set forced options

		_.assign options,
			toggle: true
			toggleLock: true

		# set default options
		_.defaults options,
			name: 'NavButton'
			type: 'body'
			color: 'white'
			fill: 'transparent'
			size: 'auto'
			view: undefined
			padding: { left: 18, right: 18, top: 5, bottom: 5 }

		super options

		# events

		@view = options.view

		@on "change:isOn", @showToggled

		@showToggled()

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