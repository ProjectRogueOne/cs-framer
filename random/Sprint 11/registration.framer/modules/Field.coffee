# Field
# Authors: Steve Ruiz
# Last Edited: 27 Sep 17

{ TextField } = require 'TextField'
{ Text } = require 'Text'

# build an interface to allow TextField styling through Field
# change textfield to have a containing layer (like this one),
# and merge the two components; essentially, this should replace
# textfield.

class exports.Field extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		@_title
		@_message

		options.backgroundColor = null

		super options

		@input = new TextField
			parent: @

		@titleLayer = new Text
			name: 'Title Layer'
			parent: @
			width: @width
			padding: {}
			textAlign: 'center'
			type: 'body'
			text: '{title}'
			visible: false

		@messageLayer = new Text
			name: 'Message Layer'
			parent: @
			x: 24
			y: @input.maxY + 5
			type: 'caption'
			text: '{message}'
			visible: false

		delete @__constructor

		@height = @input.maxY
		@width = @input.width
		@title = options.title
		@message = options.message
		@placeholder = options.placeholder
		@color = options.color
		@border = options.border ? 'grey'
		@fill = options.fill ? 'transparent'
		@pattern = options.pattern ? -> null
		@leftIcon = options.leftIcon
		@rightIcon = options.rightIcon
		@value = options.value
		@disabled = options.disabled ? false
		@matches = options.matches
		@focus = options.focus

		@on "change:width", =>
			@titleLayer.width = @width


	_setTitle: (string) ->
		if string?
			@titleLayer.template = string
			@titleLayer.visible = true
			@input.y = @titleLayer.maxY + 8
		else
			@titleLayer.template = ''
			@titleLayer.visible = false
			@input.y = 0

		@_setHeight()
	
	_setMessage: (string) ->
		if string?
			@messageLayer.template = string
			@messageLayer.visible = true
		else
			@messageLayer.template = ''
			@messageLayer.visible = false

		@_setHeight()

	_setHeight: ->
		@messageLayer.y = @input.maxY + 5
		if @_message then @height = @messageLayer.maxY
		else @height = @input.maxY

	@define "title",
		get: -> return @_title
		set: (string) ->
			return if @__constructor
			
			@_title = string
			@_setTitle(@title)

	@define "message",
		get: -> return @_message
		set: (string) ->
			return if @__constructor
			
			@_message = string
			@_setMessage(@message)

	@define "color",
		get: -> return @input.color
		set: (value) -> 
			return if @__constructor
			@input.color = value

	@define "border",
		get: -> return @input.border
		set: (value) -> 
			return if @__constructor
			@input.border = value

	@define "fill",
		get: -> return @input.fill
		set: (value) -> 
			return if @__constructor
			@input.fill = value

	@define "placeholder",
		get: -> return @input.placeholder
		set: (value) -> 
			return if @__constructor
			@input.placeholder = value

	@define "pattern",
		get: -> return @input.pattern
		set: (value) -> 
			return if @__constructor
			@input.pattern = value

	@define "leftIcon",
		get: -> return @input.leftIcon
		set: (value) -> 
			return if @__constructor
			@input.leftIcon = value

	@define "rightIcon",
		get: -> return @input.rightIcon
		set: (value) -> 
			return if @__constructor
			@input.rightIcon = value

	@define "value",
		get: -> return @input.value
		set: (value) -> 
			return if @__constructor
			@input.value = value
			
	@define "disabled",
		get: -> return @input.disabled
		set: (value) -> 
			return if @__constructor
			@input.disabled = value
	
	@define "matches",
		get: -> return @input.matches
		set: (value) -> 
			return if @__constructor
			@input.matches = value

	@define "focused",
		get: -> return @input.focused
		set: (value) -> 
			return if @__constructor
			@input.focused = value