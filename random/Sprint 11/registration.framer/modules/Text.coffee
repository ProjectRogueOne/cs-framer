# Text
# Authors: Steve Ruiz
# Last Edited: 25 Sep 17

{ Colors } = require 'Colors'

checkin = (array, value) ->
	if !_.includes(array, value) 
		return array[0]
	else 
		return value


class exports.Text extends TextLayer
	constructor: (options = {}) ->

		# Action
		@_action
		options.action ?= -> null

		# Disabled
		@_disabled

		basecolor = Colors.black

		# Type
		options.type = checkin(['body', 'body1', 'button', 'caption', 'link', 'subheader'], options.type) 
		switch options.type
			when 'caption'
				options.fontSize = 12
				options.fontWeight = 400
				options.lineHeight = 1.33
				basecolor = 'light'
			when 'body'
				options.fontSize = 18
				options.fontWeight = 500
				options.lineHeight = 1.11
				basecolor = 'black'
			when 'body1'
				options.fontSize = 14
				options.fontWeight = 400
				options.lineHeight = 1.43
				basecolor = 'black'
			when 'button'
				options.fontSize = 18
				options.fontWeight = 500
				options.lineHeight = 1.11
				options.textTransform = 'uppercase'
				basecolor = 'black'
			when 'link'
				options.fontSize = 16
				options.fontWeight = 500
				options.lineHeight = 1.25
				options.textDecoration = 'underline'
				basecolor = 'tertiary'
			when 'subheader'
				options.fontSize = 16
				options.fontWeight = 400
				options.lineHeight = 1.5
				basecolor = 'black'

		# Disabled
		options.disabled ?= false

		# Color
		options.color ?= basecolor
		options.color = Colors.validate(options.color)

		super _.defaults options,
			name: _.startCase(options.type)
			fontFamily: 'Helvetica Neue'

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

	@define 'action',
		get: -> return @_action
		set: (func) ->
			if typeof func isnt 'function' then throw 'Action must be a function.'
			@_action = func

