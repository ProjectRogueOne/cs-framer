# Subnav
# Authors: Steve Ruiz
# Last Edited: 1 Nov 17

{ Colors } = require 'Colors'
{ NavButton } = require 'NavButton'
{ app } = require 'App'

class exports.Subnav extends ScrollComponent
	constructor: (options = {}) ->
		@__constructor = true
		@showLayers = options.showLayers ? false

		@_selected = undefined
		@buttons = []

		{ app } = require 'App'
		app.subnav = @

		_.defaults options,
			links: []

		# set forced values
		_.assign options,
			name: 'Subnav'
			backgroundColor: Colors.main
			height: 60
			width: Screen.width
			shadowY: 1
			scrollVertical: false
			contentInset: {left: 32, right: 32}

		super options

		#- layers
	
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

		#- events

		@on "change:selected", ->
			return if app.current is @selected.view

			app.showNext(@selected.view)
			@_scrollToSelected()

		#- set properties that required layers

		_.assign @,
			links: options.links
			selected: options.selected
	
	_scrollToSelected: =>

		w = @width - (@contentInset.left + @contentInset.right) - @selected.width

		@scrollToPoint(
			x: @selected.x - w/2, y: 0
			true
			curve: "spring(300, 35, 0)"
		)

	_addButton: (link) ->

		button = new NavButton
			name: if @showLayers then link.text else '.'
			parent: @content
			textTransform: 'uppercase'
			y: 15
			text: link.text
			height: 32
			padding: { top: 0, bottom: 0, left: 20, right: 20 }
			type: 'body1'
			value: @buttons.length
			group: @buttons
			view: link.view

		do (button) =>
			button.action = => @selected = button

	_positionButtons: =>
		last = undefined


		for button, i in @buttons
			button.x = (last?.maxX ? 0) + 8

			last = button

		@updateContent()

	_makeButtons: ->
		for button in @buttons
			button.destroy()

		@buttons = []

		for link in @links
			@_addButton(link)

		@_positionButtons()

	@define "selected",
		get: -> return @_selected
		set: (button) ->
			return if not button
			return if @__constructor
			return if @_selected is button

			@_selected = button

			@emit "change:selected", button, @

	@define "links",
		get: -> return @_links
		set: (array) ->
			return if @__constructor
			if not _.isArray(array)
				throw "Subnav's links should be an array."

			@_links = array
			@_makeButtons()