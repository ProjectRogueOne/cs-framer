# Button
# Authors: Steve Ruiz
# Last Edited: 9 Oct 17

{ Container } = require 'Container'
{ Colors } = require 'Colors'
{ Text } = require 'Text'
{ Icon } = require 'Icon'

class exports.Button extends Container
	constructor: (options = {}) ->
		@__constructor = true

		# Action
		@_action
		options.action ?= -> null

		# Disabled
		@_disabled

		# Text / Label
		@_text
		options.text ?= 'Button'

		# toggle
		@_toggle
		options.toggle ?= false

		# toggle lock
		@_toggleLock
		options.toggleLock ?= false

		# ison
		@_isOn
		options.isOn ?= false

		# disabled
		@_disabled
		options.disabled ?= false

		# icon
		@_icon
		options.icon

		# group
		@_group
		options.group ?= []

		super _.defaults options,
			name: 'Button'
			borderWidth: 2
			borderRadius: 4
			animationOptions: { time: .15 }

		# Button Label

		@textLayer = new Text
			name: '.'
			parent: @
			type: options.type ? 'button'
			color: options.color
			text: ''
			y: Align.center(1)
			textTransform: options.textTransform
			padding: options.padding ? {left: 32, right: 32}
			textAlign: 'center'
			animationOptions: { time: .15 }

		# Icon

		@iconLayer = new Icon 
			name: '.'
			parent: @
			point: Align.center

		unless @_size is 'auto' then @textLayer.width = @width

			# events

		@on "change:width", ->
			@iconLayer.point = Align.center

		@on "change:color", (colorName, color) ->
			@textLayer.color = colorName
			@iconLayer.color = colorName

		@on "change:isOn", @updateSiblings

		@on "change:icon", (icon) ->
			@textLayer.visible = not icon?
			@iconLayer.visible = icon?
			@iconLayer.icon = icon ? "empty"

		@onTapStart => 
			return if @disabled
			@showPressed(true)
		
		@onTapEnd => 
			return if @disabled
			return if @toggleLock and @isOn

			if @toggle then @isOn = !@isOn
			
			if @action then @action()

			@showPressed(false)

		@onPan (event) =>
			if Math.abs(event.offset.x) > 30 or
			Math.abs(event.offset.y) > 30
				@showPressed(false)

		delete @__constructor 

		@text = options.text
		@icon = options.icon
		@isOn = options.isOn
		@color = options.color
	

	updateSiblings: =>
		if @isOn then sib.isOn = false for sib in _.without(@group, @)
		@group.selected = @

	showPressed: (isPressed) ->
		@animateStop()
		if isPressed
			@animate {brightness: 80}
		else 
			if @isOn then @animate {brightness: 85}
			else @animate {brightness: 100}

	@define "icon",
		get: -> return @_icon
		set: (string) ->
			return if @__constructor

			@_icon = string

			@emit "change:icon", string, @

	@define "isOn",
		get: -> return @_isOn
		set: (bool) ->
			return if @__constructor
			return if not @toggle

			@_isOn = bool
			@emit("change:isOn", bool, @)
			@showPressed(false)

	@define "disabled",
		get: -> return @_disabled
		set: (bool) ->
			return if bool is @_disabled
			if typeof bool isnt 'boolean'
				throw 'Disabled must be boolean (true or false).'
			@_disabled = bool
			
			@emit "change:disabled", @_disabled, @
			@opacity = if @disabled then .45 else 1

	@define 'text',
		get: -> return @_text
		set: (string) ->
			return if @__constructor
			if typeof string isnt 'string' 
				throw 'Text must be a string, like "Click Here!".'
			@_text = string

			if @_size is 'auto'
				@width = 999
				@textLayer.text = string
				@width = @textLayer.width
				@x = @_x
			else
				@textLayer.text = string

	@define "color",
		get: -> return @textLayer.color
		set: (colorName) ->
			return if @__constructor

			@textLayer.color = colorName
			@iconLayer.color = colorName

			@emit "change:color", colorName

	@define "toggle",
		get: -> return @_toggle
		set: (bool) ->
			@_toggle = bool

	@define "toggleLock",
		get: -> return @_toggleLock
		set: (bool) ->
			@_toggleLock = bool

	@define "group",
		get: -> return @_group
		set: (array) ->
			@_group = array

			if not _.includes(array, @) then array.push(@)

	@define 'action',
		get: -> return @_action
		set: (func) ->
			if typeof func isnt 'function' then throw 'Action must be a function.'
			@_action = func