# Text
# Authors: Steve Ruiz
# Last Edited: 6 Oct 17

{ Colors } = require 'Colors'

checkin = (array, value) ->
	if !_.includes(array, value) 
		return array[0]
	else 
		return value


class exports.Text extends TextLayer
	constructor: (options = {}) ->
		@__constructor = true
		@showLayers = options.showLayers ? false

		# Action
		@_action
		options.action ?= -> null

		# Disabled
		@_disabled
		options.disabled ?= false

		# Type
		@types =
			body1:
				fontSize: 14
				fontWeight: 400
				lineHeight: 1.43
				color: 'black'
			heading:
				fontSize: 36
				fontWeight: 500
				lineHeight: 1.5
				color: 'black'
			subheader:
				fontSize: 16
				fontWeight: 400
				lineHeight: 1.5
				color: 'black'
			caption:		
				fontSize: 12
				fontWeight: 400
				lineHeight: 1.33
				color: 'light'
			body:
				fontSize: 18
				fontWeight: 500
				lineHeight: 1.11
				color: 'black'
			button:
				fontSize: 18
				fontWeight: 500
				lineHeight: 1.11
				textTransform: 'uppercase'
				color: 'black'
			link:
				fontSize: 16
				fontWeight: 500
				lineHeight: 1.25
				textDecoration: 'underline'
				color: 'tertiary'
			donut:
				fontSize: 56
				fontWeight: 500
				lineHeight: 1.5
				color: 'black'

		@_type
		options.type = checkin(_.keys(@types), options.type)

		# base color

		# Color
		@_color

		@_basecolor = options.color

		_.assign(options, @types[options.type])

		if @_basecolor? then options.color = @_basecolor

		# set default options

		super _.defaults options,
			name: _.startCase(options.type)
			fontFamily: 'Helvetica Neue'

		# events

		@onTap =>
			return if @disabled
			@action()

		delete @__constructor

		# set properties

		@color = options.color

	setType: ->
		_.assign(@, @types[@_type])

	@define "color",
		get: -> return @_color
		set: (string) ->
			return if @__constructor

			color = Colors.validate(string)

			@_color = color ? Colors.black

			@style.color = color

			@emit "change:color", string, color, @

	@define "disabled",
		get: -> return @_disabled
		set: (bool) ->
			return if bool is @_disabled
			if typeof bool isnt 'boolean' then throw 'Must be boolean value.'
			@_disabled = bool
			
			@emit "change:disabled", @_disabled, @
			@opacity = if @disabled then .45 else 1

	@define 'action',
		get: -> return @_action
		set: (func) ->
			if typeof func isnt 'function' then throw 'Action must be a function.'
			@_action = func

