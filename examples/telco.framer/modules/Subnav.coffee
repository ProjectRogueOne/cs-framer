# Subnav
# Authors: Steve Ruiz
# Last Edited: 4 Oct 17

{ Colors } = require 'Colors'
{ NavButton } = require 'NavButton'
{ app } = require 'App'

class exports.Subnav extends ScrollComponent
	constructor: (options = {}) ->
		@__constructor = true
		@showLayers = options.showLayers ? false

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

		super options

		@on "change:links", (links) ->
			@_addLinks()
			@_postitionLinks()

		@on "change:selection", (view, button) ->
			@activeLink = button

			@scrollToPoint(
				x: button.x - ((@width - button.width) / 2), y: 0
				true
				curve: "spring(300, 35, 0)"
			)

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
	
	_addLink: (link) ->

		button = new NavButton
			name: if @showLayers then link.text else '.'
			parent: @content
			textTransform: 'uppercase'
			y: 15
			text: link.text
			height: 32
			padding: { top: 0, bottom: 0, left: 20, right: 20 }
			type: 'body1'
			value: @linkButtons.length
			group: @linkButtons

		button.view = link.view

		do (button) => 
			button.action = => 
				@emit "change:selection", button.view, button

	_removeLink: (link) ->
		button = _.find(@linkButtons, {'view': link.view})
		return if not button

		_.pull(@linksButtons, button)
		button.destroy()

		_postitionLinks()

	_postitionLinks: =>
		startX = 0

		for button, i in @linkButtons
			button.x = startX
			startX += button.width + 8

		@updateContent()

	_clearLinks: =>
		for link in @links
			@_removeLink(link)

	_addLinks: ->
		newLinks = @links
		@_clearLinks()
		for link in newLinks
			@_addLink(link)
		
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

			@emit "change:links", array, @