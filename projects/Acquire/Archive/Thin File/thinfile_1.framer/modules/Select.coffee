# Button
# Authors: Steve Ruiz
# Last Edited: 1 Nov 17

{ Container } = require 'Container'
{ Accordian } = require 'Accordian'
{ Colors } = require 'Colors'
{ Text } = require 'Text'
{ Icon } = require 'Icon'

class exports.Select extends Container
	constructor: (options = {}) ->
		@__constructor = true

		_.defaults options,
			name: 'Select'
			text: 'Choose your...'
			fill: 'none'
			border: 'dark'
			disabled: false
			animationOptions: { time: .15 }
			options: ['red', 'green', 'blue']
			action: (value) -> null

		super options

		@toggleIcon = new Icon
			parent: @
			x: Align.right(-16)
			y: (@height - 24) / 2
			color: 'grey'
			type: 'accordian'
			direction: 'down'

		@textLayer = new Text
			name: '.'
			parent: @
			type: options.type ? 'body1'
			color: options.color
			text: ''
			y: Align.center(1)
			textTransform: options.textTransform
			padding: options.padding ? {left: 32, right: 32}
			textAlign: 'center'
			animationOptions: { time: .15 }

		@select = document.createElement('select')
		@select.onchange = @setSelection
		@_element.appendChild(@select)

		_.assign @select.style,
			opacity: '0'

		@textLayer.sendToBack()

		unless @_size is 'auto' then @textLayer.width = @width

		# events

		@on "change:width", @update

		@on "change:color", (colorName, color) ->
			@textLayer.color = colorName
			@toggleIcon.color = colorName


		@onTapStart => 
			return if @disabled
			@showPressed(true)
		
		@onTapEnd => 
			return if @disabled
			return if @opacity is 0

			@showPressed(false)

		@onPan (event) =>
			if Math.abs(event.offset.x) > 30 or
			Math.abs(event.offset.y) > 30
				@showPressed(false)

		delete @__constructor 

		_.assign @,
			text: options.options[0] ? options.text
			disabled: options.disabled
			options: options.options
			action: options.action
			selection: options.options[0]

		@update()


	takeAction: =>

	update: =>
		@textLayer.width = @width
		@toggleIcon.maxX = @width - 16
		_.assign @select.style,
			width: @width   * Framer.Device.context.scale + 'px'
			height: @height * Framer.Device.context.scale + 'px'

	setOptions: =>
		for option in @options
			o = document.createElement('option')
			o.label = option
			o.textContent = option
			o.style.width = '0px;'
			@select.appendChild(o)

	setSelection: =>
		@selection = @options[@select.selectedIndex]
		@text = @selection

		@action()

	showPressed: (isPressed) ->
		@animateStop()
		if isPressed
			@animate {brightness: 80}
		else 
			if @isOn then @animate {brightness: 85}
			else @animate {brightness: 100}


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
				return
			
			@textLayer.text = string

	@define "color",
		get: -> return @textLayer.color
		set: (colorName) ->
			return if @__constructor

			@textLayer.color = colorName

			@emit "change:color", colorName

	@define "options",
		get: -> return @_options
		set: (array) ->
			return if @__constructor

			@_options = array

			@setOptions()