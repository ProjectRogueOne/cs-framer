# Field
# Authors: Steve Ruiz
# Last Edited: 20 Sep 17

class exports.Field extends Layer
	constructor: (options = {}) ->

		@_warned
		@_focused

		@_value
		@_label
		@_message
		@_leftIcon
		@_rightcon

		super _.defaults options,
			name: 'Basic Text Field'

	@define "warned",
		get: -> return @_warned
		set: (bool) ->
			return if bool is @_warned
			if typeof bool isnt 'boolean' then throw 'Must be boolean value.'
			@_warned = bool
			
			@emit "change:warn", @_warned, @

	@define "focused",
		get: -> return @_focused
		set: (bool) ->
			return if bool is @_focused
			if typeof bool isnt 'boolean' then throw 'Must be boolean value.'
			@_focused = bool
			
			@emit "change:focus", @_focused, @

	@define "value",
		get: -> return @_value
		set: (value) ->
			return if value is @_value
			if typeof value isnt 'string' then throw 'Must be string value.'
			@_value = value
			
			@emit "change:value", @_value, @

	@define "label",
		get: -> return @_label
		set: (value) ->
			return if value is @_label
			if typeof value isnt 'string' then throw 'Must be string value.'
			@_label = value
			
			@emit "change:label", @_label, @

	@define "message",
		get: -> return @_message
		set: (value) ->
			return if value is @_message
			if typeof value isnt 'string' then throw 'Must be string value.'
			@_message = value
			
			@emit "change:helper", @_message, @

	@define "leftIcon",
		get: -> return @_leftIcon
		set: (value) ->
			return if value is @_leftIcon
			if typeof value isnt 'string' then throw 'Must be string value.'
			@_leftIcon = value

	@define "rightIcon",
		get: -> return @_rightIcon
		set: (value) ->
			return if value is @_rightIcon
			if typeof value isnt 'string' then throw 'Must be string value.'
			@_rightIcon = value
			
