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

		@_leftIcon
		@_rightIcon
		@_title
		@_message
		@_readonly
		@_maxlength

		@_size
		options.size ?= 'medium'

		@_value
		options.value ?= ''

		@_disabled
		options.disabled ?= false

		@_placeholder
		options.placeholder ?= ''

		@_focused
		options.focused ?= false

		@_color
		options.color ?= 'black'

		@_border
		options.border ?= 'grey'

		@_fill
		options.fill ?= 'transparent'

		@_pattern
		options.pattern ?= (value) -> return true

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
			y: Align.center(-2) 
			height: 20
			width: 20
			icon: 'star'
			visible: false

		# right icon

		@rightIconLayer = new Icon
			parent: @
			x: Align.right(-8)
			y: Align.center(-2)
			height: 20
			width: 20
			icon: 'star'
			visible: false

		# html input
				
		Utils.insertCSS( """
			*:focus { outline: 0; }
			textarea { resize: none; } 
			::selection { background: #{new Color(options.color).alpha(.2)}; } 
			""" )

		@input = document.createElement('input')

		@inputLayer._element.appendChild(@input)

		@input.spellcheck 		= false
		@input.autocapitalize   = false
		@input.autocomplete 	= false

		# @input.inputmode = 'latin'
		# @input.maxlength = '999'
		# @input.readonly = 'false'

		@input.style.cssText = """
			z-index:5;
			zoom: #{@context.scale};
			font-size: 14px;
			font-family: 'Helvetica Neue';
			font-weight: 400;
			color: #{options.color};
			-webkit-text-fill-color: #{options.color};
			background-color: transparent;
			position: absolute;
			top: 10px;
			left: 10px;
			padding: 6px;
			resize: none;
			width: #{@width - 20}px;
			outline: 0px none transparent !important;
			-webkit-text-security: #{if options.password then 'square' else 'none'};
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
			y: @input.maxY + 5
			width: @width
			padding: {left: 24}
			type: 'caption'
			text: '{message}'
			visible: false

		# events

		@onPan (event) => event.stopPropagation()
		@on "keypress", (event) => if event.key is "Enter" then @submit()
		@on "change:width", => @input.style.width = '100%'

		@input.onfocus = => @focused = true
		@input.onblur = => @focused = false
		@input.oninput = @setValue

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

		@color = options.color
		@border = options.border
		@fill = options.fill


	_setTitle: (string) ->
		if string?
			@titleLayer.template = string
			@titleLayer.visible = true
			@inputLayer.y = @titleLayer.maxY + 8
		else
			@titleLayer.template = ''
			@titleLayer.visible = false
			@inputLayer.y = 0

		@_setHeight()
	
	_setMessage: (string) ->
		@messageLayer.template = string ? ''
		@messageLayer.visible = string?.length > 0

		@_setHeight()

	_setHeight: ->
		@messageLayer.y = @inputLayer.maxY + 5
		if @_message then @height = @messageLayer.maxY
		else @height = @inputLayer.maxY

	submit: => @emit("submit", @input.value, @)

	showFocused: => return if @disabled

	showDisabled: =>
		@animateStop()
		@opacity = if @disabled is true then .5 else 1

	hasTextContent: -> return @value.length > 0

	setValue: => 
		@value = @input.value ? ''
		@matches = @pattern(@value)

	clearValue: -> 
		@input.value = ''
		@setValue()

	setInputPosition: ->
		if @leftIcon? and not @rightIcon?
			@input.style.left = '30px'
			@input.style.width = "#{@width - 40}px"
		else if @rightIcon? and not @leftIcon?
			@input.style.left = '10px'
			@input.style.width = "#{@width - 40}px"
		else if @rightIcon? and @leftIcon?
			@input.style.left = '30px'
			@input.style.width = "#{@width - 60}px"
		else
			@input.style.left = '10px'
			@input.style.width = "#{@width - 20}px"

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
		get: -> return @_leftIcon
		set: (icon) ->
			return if @__constructor
			@_leftIcon = icon
			@leftIconLayer.icon = @_leftIcon
			@leftIconLayer.visible = @_leftIcon?
			@setInputPosition()

	@define "rightIcon",
		get: -> return @_rightIcon
		set: (icon) ->
			return if @__constructor
			@_rightIcon = icon
			@rightIconLayer.icon = @_rightIcon
			@rightIconLayer.visible = @_rightIcon?
			@setInputPosition()

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
			@emit("change:value", @value, @)
			
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
			@emit("change:matches", @matches, @hasTextContent(), @)

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