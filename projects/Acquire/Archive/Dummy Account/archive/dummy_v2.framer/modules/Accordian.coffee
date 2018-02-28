# Accordian
# Authors: Steve Ruiz
# Last Edited: 6 Oct 17

{ Icon } = require 'Icon'
{ Text } = require 'Text'
{ Divider } = require 'Divider'
{ Container } = require 'Container'

class exports.Accordian extends Container
	constructor: (options = {}) ->
		@__constructor = true
		@showLayers = options.showLayers ? true

		@_isOpen
		options.isOpen ?= false

		@_title
		options.title ?= "Content"

		@_subtitle

		@_icon

		# set forced properties

		_.assign options,
			fill: 'white'
			border: 'black'
			borderWidth: 1
			clip: true
			animationOptions:
				time: .25

		# set default properties

		super _.defaults options,
			name: 'Accordian'
			size: 'full'

		# layers

		@toggleButton = new Icon
			parent: @
			x: Align.right(-16)
			y: (@height - 24) / 2
			color: 'grey'
			type: 'accordian'
			direction: 'down'

		@titleLayer = new Text
			parent: @
			x: 16
			y: Align.center
			color: 'grey'
			type: 'body1'
			text: ''

		@subtitleLayer = new Text
			parent: @
			x: 16
			y: Align.center(8)
			color: 'grey'
			type: 'body1'
			text: ''

		@iconLayer = new Icon
			parent: @
			x: 16
			y: Align.center
			color: 'grey'
			icon: 'menu'

		@divider = new Divider
			parent: @
			x: 0
			y: @height
			width: @width


		delete @__constructor

		# events

		@on "change:isOpen", @_toggle

		@toggleButton.onTap => @isOpen = !@isOpen

		# assign properties that required layers

		Utils.delay .01, => _.assign @,
			isOpen: options.isOpen
			_closedHeight: @height

		@_setContent()

	_setContent: =>
		@titleLayer.text = @title
		@titleLayer.x = 16
		@titleLayer.y = Align.center()

		@subtitleLayer.text = @subtitle
		@subtitleLayer.visible = @subtitle?
		@subtitleLayer.x = 16

		@iconLayer.icon = @icon
		@iconLayer.visible = @icon?

		if @subtitle?
			@titleLayer.y = Align.center(-8)

		if @icon?
			@titleLayer.x = @iconLayer.maxX + 16
			@subtitleLayer.x = @iconLayer.maxX + 16

	_toggle: =>

		if @isOpen
			@toggleButton.direction = 'up'
			@animate
				height: _.maxBy(@children, 'maxY').maxY + 16

		else
			@toggleButton.direction = 'down'
			@animate
				height: @_closedHeight

	@define "title",
		get: -> return @_title
		set: (string) ->
			if typeof string isnt "string"
				throw "Accordian.title must be a string - like 'Hello world!'"
			
			@_title = string

			return if @__constructor
			@_setContent()

	@define "subtitle",
		get: -> return @_subtitle
		set: (string) ->
			if typeof string isnt "string"
				throw "Accordian.title must be a string - like 'Hello world!'"
			
			@_subtitle = string

			return if @__constructor
			@_setContent()

	@define "icon",
		get: -> return @_icon
		set: (string) ->
			if typeof string isnt "string"
				throw "Accordian.title must be a string - like 'Hello world!'"
			
			@_icon = string

			return if @__constructor
			@_setContent()

	@define "isOpen",
		get: -> return @_isOpen
		set: (bool) ->
			return if @__constructor
			if typeof bool isnt "boolean"
				throw "Accordian.isOpen must be a boolean - true or false."
			
			@_isOpen = bool

			@emit "change:isOpen", bool, @