# Subnav
# Authors: Steve Ruiz
# Last Edited: 3 Oct 17

{ Colors } = require 'Colors'
{ NavButton } = require 'NavButton'
{ app } = require 'App'

class exports.Subnav extends ScrollComponent
	constructor: (options = {}) ->
		@__constructor = true

		{ app } = require 'App'
		app.subnav = @

		@linkButtons = []
		@activeLink

		options.links ?= []

		# set forced values
		_.assign options,
			name: 'Subnav'
			backgroundColor: Colors.main
			height: 60
			width: Screen.width
			shadowY: 1
			scrollVertical: false
			contentInset:
				{left: 32, right: 32}

		super _.defaults options

		# layers
	
		@fadeRight = new Layer
			name: if @showLayers then 'Right Fade Overlay' else '.'
			parent: @
			height: @height
			width: 32
			x: Align.right
			gradient: new Gradient
				start: 'rgba(64, 79, 93, 0.000)'
				end: 'rgba(64, 79, 93, 1.000)'
				angle: 90

		@fadeLeft = new Layer
			name: if @showLayers then 'Left Fade Overlay' else '.'
			parent: @
			height: @height
			width: 32
			gradient: new Gradient
				start: 'rgba(64, 79, 93, 1.000)'
				end: 'rgba(64, 79, 93, 0.000)'
				angle: 90

		delete @__constructor

		# set properties that require layers

		@links = options.links
	
	makeLinks: ->
		startX = 0

		layer?.destroy() for layer in @linkButtons

		@linkButtons = []

		for link, i in @links
			button = new NavButton
				name: if @showLayers then link.label else '.'
				parent: @content
				size: 'auto'
				type: 'body'
				color: 'black'
				fill: 'transparent'
				x: startX
				y: 16
				text: link.label
				group: @linkButtons
				value: i

			startX = button.maxX + 8

			# when button is tapped, emit the selection
			button.view = link.view

			do (button) => 
				button.action = => 
					@activeLink = button.view

					@scrollToPoint(
						x: button.x - ((@width - button.width) / 2), y: 0
						true
						curve: "spring(300, 35, 0)"
					)

					@emit "change:selection", button.view

			@linkButtons.push(button)

		@updateContent()
		
		# activate first button as default

		if _.every(@linkButtons, ['isOn', false])
			return if !@linkButtons[0]
			@linkButtons[0].isOn = true
			@linkButtons[0].action()

	@define "links",
		get: -> return @_links
		set: (array) ->
			return if @__constructor
			if not _.isArray(array)
				throw "Subnav's links should be an array."

			@_links = array
			@makeLinks()