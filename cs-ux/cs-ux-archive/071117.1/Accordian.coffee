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
		options.title ?= undefined

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

		@on "change:color", @_setColors
		@on "change:isOpen", @_toggle
		@on "change:children", @_setHeight

		@toggleButton.onTap => @isOpen = !@isOpen

		# assign properties that required layers

		_.assign @,
			isOpen: options.isOpen
			_closedHeight: @height
			color: options.color ? 'grey'

		@_openHeight
		@_setContent()

	_setColors: =>
		@titleLayer.color = @color
		@subtitleLayer.color = @color
		@iconLayer.color = @color
		@toggleButton.color = @color

	_setHeight: =>
		Utils.delay 0, =>
			@_openHeight = _.maxBy(@children, 'maxY').maxY + 16

			if @isOpen then @animate { height: @_openHeight }

	_setContent: =>

		@titleLayer.text = @title ? ""
		@titleLayer.x = 16
		@titleLayer.y = Align.center()

		@subtitleLayer.text = @subtitle ? ""
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
		@animateStop()

		if @isOpen
			@toggleButton.direction = 'up'
			@animate
				height: @_openHeight

		else
			@toggleButton.direction = 'down'
			@animate
				height: @_closedHeight

	@define "title",
		get: -> return @_title
		set: (string) ->
			if typeof string isnt "string"
				string = ""

			@_title = string

			return if @__constructor
			@_setContent()

	@define "subtitle",
		get: -> return @_subtitle
		set: (string) ->
			if typeof string isnt "string"
				string = ""

			@_subtitle = string

			return if @__constructor
			@_setContent()

	@define "icon",
		get: -> return @_icon
		set: (string) ->
			if typeof string isnt "string"
				string = "empty"

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