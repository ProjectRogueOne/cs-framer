# Button
# Authors: Steve Ruiz
# Last Edited: 21 Sep 17

{ Colors } = require 'Colors'
{ Text } = require 'Text'


class exports.Button extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		# Action
		@_action
		options.action ?= -> null

		# Disabled
		@_disabled

		# Size
		options.size ?= 'medium'
		@_size = options.size
		@_x = options.x

		switch options.size
			when "large"
				options.size = {width: 355, height: 50}
			when "small"
				options.size = {width: 200, height: 50}
			when "medium"
				options.size = {width: 250, height: 50}
			when "auto"
				options.size = {width: 250, height: 50}

		# Fill
		options.fill ?= 'primary'
		options.backgroundColor = Colors.validate(options.fill)

		# Border
		border = options.border

		if border?
			options.borderWidth = 2
			options.borderColor = Colors[border]

		# Text / Label
		@_text
		options.text ?= 'Button'


		super _.defaults options,
			name: 'Button'
			borderRadius: 4


		# Button Label

		@textLabel = new Text
			parent: @
			type: options.type ? 'button'
			color: options.color
			text: ''
			y: Align.center
			padding: {left: 32, right: 32}
			textAlign: 'center'
			animationOptions: { time: .15 }

		unless @_size is 'auto' then @textLabel.width = @width

		delete @__constructor 

		@text = options.text

		@onTap =>
			return if @disabled
			@action()


	@define "disabled",
		get: -> return @_disabled
		set: (bool) ->
			return if bool is @_disabled
			if typeof bool isnt 'boolean' then throw 'Must be boolean value.'
			@_disabled = bool
			
			@emit "change:disabled", @_disabled, @
			@opacity = if @disabled then .25 else 1

	@define 'text',
		get: -> return @_text
		set: (string) ->
			return if @__constructor
			if typeof string isnt 'string' then throw 'Text must be a string.'
			@_text = string

			@textLabel.text = string
			if @_size is 'auto'
				@width = @textLabel.width
				@x = @_x

	@define 'action',
		get: -> return @_action
		set: (func) ->
			if typeof func isnt 'function' then throw 'Action must be a function.'
			@_action = func