# Field
# Authors: Steve Ruiz
# Last Edited: 27 Sep 17

Type = require 'Mobile'
{ Text } = require 'Text'
{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
{ Container } = require 'Container'

# build an interface to allow TextField styling through Field
# change textfield to have a containing layer (like this one),
# and merge the two components; essentially, this should replace
# textfield.

class exports.Field extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		# textfield

		@_value
		options.value ?= ''

		@_placeholder
		options.placeholder ?= ''

		@_disabled
		options.disabled ?= false

		@_focused
		options.focused ?= false

		@_password
		options.password ?= false

		@_pattern
		options.pattern ?= (value) -> return true

		@_matches = undefined

		# furniture
		
		@_title
		options.title ?= undefined

		@_leftIcon
		options.leftIcon ?= undefined
		
		@_rightIcon
		options.rightIcon ?= undefined
		
		@_message
		options.message ?= undefined

		# container

		@_size
		options.size ?= 'medium'

		@_fill
		options.fill ?= 'none'

		@_border
		options.border ?= 'grey'

		@_color
		options.color ?= 'black'

		# set forced properties

		_.assign options,
			backgroundColor: null

		# set default properties

		super _.defaults options,
			name: 'Field'

		# layers

		# input layer

		@inputLayer = new Container
			name: if @showLayers then 'Input' else '.'
			parent: @
			fill: 'transparent'
			size: options.size

		@size = @inputLayer.size

		# left icon

		@leftIconLayer = new Icon
			parent: @
			x: 8
			y: Align.center() 
			height: 20
			width: 20
			icon: 'star'
			visible: false

		# right icon

		@rightIconLayer = new Icon
			parent: @
			x: Align.right(-8)
			y: Align.center()
			height: 20
			width: 20
			icon: 'star'
			visible: false

		# html input

		@input = document.createElement('input')

		@inputLayer._element.appendChild(@input)

		@input.spellcheck 		= false
		@input.autocapitalize   = false
		@input.autocomplete 	= false
		
		@input.style.cssText = """
			z-index:5;
			zoom: #{@context.scale};
			font-size: 14px;
			font-family: 'Helvetica Neue';
			font-weight: 400;
			color: #{options.color};
			background-color: transparent;
			position: absolute;
			top: 10px;
			left: 10px;
			padding: 6px;
			resize: none;
			width: #{@width - 20}px;
			outline: 0px none transparent !important;
			-webkit-text-fill-color: #{options.color};
			-webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */
			-moz-box-sizing: border-box;    /* Firefox, other Gecko */
			box-sizing: border-box; 
		"""

		# title

		@titleLayer = new Text
			name: 'Title Layer'
			parent: @
			width: @width
			padding: {}
			textAlign: 'center'
			type: 'body'
			text: '{title}'
			visible: false

		# message

		@messageLayer = new Text
			name: 'Message Layer'
			parent: @
			y: @inputLayer.height + 5
			width: @width
			padding: {left: 24}
			type: 'caption'
			text: '{message}'
			visible: false

		# events

		@inputLayer.on "change:y", => 
			@messageLayer.y = @inputLayer.maxY + 5
			
		@onPan (event) => 
			event.stopPropagation()
		
		@on "keypress", (event) => 
			if event.key is "Enter" then @submit()
		
		@on "change:width", => @input.style.width = '100%'

		@input.onfocus = => @focused = true
		
		@input.onblur = => @focused = false
		
		@input.oninput = @_setValue

		@on "change:value", (value) =>
			@input.value = value

		@on "change:border", (color) =>
			@leftIconLayer.color = color
			@rightIconLayer.color = color

		@on "change:width", =>
			for layer in [@messageLayer, @inputLayer, @titleLayer]
				layerwidth = @width

		@on "change:color", (colorname, color) =>
			@input.style.color = color
			@input.style['-webkit-text-fill-color'] = color
			@messageLayer.color = colorname
			@titleLayer.color = colorname

		# set properties that required layers

		delete @__constructor

		@title = options.title
		@message = options.message

		@leftIcon = options.leftIcon
		@rightIcon = options.rightIcon

		@pattern = options.pattern
		@focused = options.focused
		@placeholder = options.placeholder
		@value = options.value
		@disabled = options.disabled
		@password = options.password

		@color = options.color
		@border = options.border
		@fill = options.fill


	_setTitle: (string) ->
		if not string?
			@titleLayer.template = ''
			@titleLayer.visible = false
			@inputLayer.y = 0
			@_setHeight()
			return

		@titleLayer.template = string
		@titleLayer.visible = true
		@inputLayer.y = @titleLayer.maxY + 8
		@_setHeight()
	
	_setMessage: (string) ->
		@messageLayer.template = string ? ''
		@messageLayer.visible = string?.length > 0

		@_setHeight()

	_setHeight: ->
		if not @_message
			@height = @inputLayer.maxY
			return

		@height = @messageLayer.maxY

	_setValue: => 
		@_value = @input.value

		if @input.value is ""
			@matches = undefined
			return

		@matches = @pattern(@value)

	submit: => 
		@emit("submit", @input.value, @)

	showFocused: => 
		return if @disabled

	showDisabled: =>
		@animateStop()
		@opacity = if @disabled is true then .5 else 1

	hasTextContent: -> 
		return @value.length > 0

	setInputPosition: ->
		leftPadding = 10
		width = @width - 20

		if @leftIcon.visible
			width -= 20
			leftPadding += 20
		if @rightIcon.visible
			width -= 20

		@input.style.left = leftPadding + 'px'
		@input.style.width = width + 'px'

	@define "color",
		get: -> return @_color
		set: (string) ->
			return if @__constructor

			color = Colors.validate(string) ? Colors.black

			@_color = color
			@emit "change:color", string, color

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
			@_setMessage(string)

	@define "border",
		get: -> return @inputLayer.border
		set: (string) ->
			return if @__constructor
		
			@inputLayer.border = string

			@emit "change:border", string, @inputLayer.border

	@define "fill",
		get: -> return @inputLayer.fill
		set: (string) ->
			return if @__constructor
		
			@inputLayer.fill = string

			@emit "change:fill", string, @inputLayer.fill


	@define "pattern",
		get: -> return @_pattern
		set: (func) ->
			return if @__constructor
			if typeof func isnt 'function'
				throw 'Pattern must be a function.'
			@_pattern = func

	@define "leftIcon",
		get: -> return @leftIconLayer
		set: (icon) ->
			return if @__constructor
			@_leftIcon = icon
			@leftIconLayer.icon = @_leftIcon
			@leftIconLayer.visible = @_leftIcon?
			@setInputPosition()

	@define "rightIcon",
		get: -> return @rightIconLayer
		set: (icon) ->
			return if @__constructor
			@_rightIcon = icon
			@rightIconLayer.icon = @_rightIcon
			@rightIconLayer.visible = @_rightIcon?
			@setInputPosition()

	@define "password",
		get: -> return @_password
		set: (bool) ->
			return if @__constructor

			@_password = bool

			@input.style['-webkit-text-security'] = if bool then 'square' else 'none'

	@define 'placeholder',
		get: -> return @_placeholder
		set: (string) ->
			return if @__constructor
			@_placeholder = string

			@input.placeholder = string 

	@define "value",
		get: -> return @_value
		set: (value) ->
			return if @__constructor
			return if @_value is value
			
			@_value = value
			@emit("change:value", value, @)
			
	@define "disabled",
		get: -> return @_disabled
		set: (bool) ->
			return if @__constructor
			return if @_disabled is bool
			if typeof bool isnt 'boolean'
				throw 'Disabled must be either true or false.'
			
			@input.blur()
			@input.disabled = bool

			@_disabled = bool
			@emit("change:disabled", @disabled, @)

			@showDisabled()
	
	@define "matches",
		get: -> return @_matches
		set: (bool) ->
			return if @__constructor
			return if bool is @matches

			@_matches = bool
			@emit("change:matches", bool, @)

	@define "focused",
		get: -> return @_focused
		set: (value) ->
			return if @__constructor
			return if @_focused is value
			if typeof value isnt 'boolean'
				throw 'Focused must be either true or false.'
			
			@_focused = value

			# blur or focus text area if set programmaically
			if value is true and 
			document.activeElement isnt @input 
				@input.focus()
			else if value is false and 
			document.activeElement is @input
				@input.blur()

			@emit("change:focused", value, @)

			@showFocused()