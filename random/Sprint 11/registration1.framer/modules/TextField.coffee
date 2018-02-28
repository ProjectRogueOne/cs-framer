# TextField
# Authors: Steve Ruiz
# Last Edited: 28 Sep 17

Type = require 'Mobile'
{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
{ Container } = require 'Container'


class exports.TextField extends Container
	constructor: (options = {}) ->
		@__constructor = true
		
		@view = options.view
		@inputMode = options.inputMode ? 'latin'
		@readOnly = options.readOnly
		@maxLength = options.maxLength
		
		@_border
		@_color
		@_leftIcon
		@_rightIcon
		@_disabled
		@_focused
		@_pattern
		@_value

		options.text = ''
		options.value ?= ''
		options.placeholder ?= ''
		options.disabled ?= false
		options.focused ?= false
		options.border ?= 'grey'
		options.color = Colors.validate(options.color) ? Colors.black
		options.pattern ?= (value) -> return true

		super _.defaults options,
			name: 'Input'
			fill: 'transparent'
		
		@_baseWidth = options.width
				
		Utils.insertCSS( """
			*:focus { outline: 0; }
			textarea { resize: none; } 
			::selection { background: #{new Color(options.color).alpha(.2)}; } 
			""" )
		
		@input = document.createElement('input')
		@_element.appendChild(@input)
		
		@input.spellcheck 		= false
		@input.autocapitalize   = false
		@input.autocomplete 	= false
		
		@setInputAttribute('inputmode', @inputMode)
		
		# if options.password then @setInputAttribute('type', 'password')
		if @maxLength? then @setInputAttribute('maxlength', @maxLength)
		if @readOnly? then @setInputAttribute('readonly', @readOnly)
		
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
		
		@onPan (event) => event.stopPropagation()
		@on "keypress", (event) => if event.key is "Enter" then @submit()
		@on "change:width", => @input.style.width = '100%'
		
		@input.onfocus = => @focused = true; @setScroll(false)
		@input.onblur = => @focused = false; @setScroll(true)
		@input.oninput = @setValue

		@view?.onScrollStart => @disabled = true
		@view?.onScrollEnd => @disabled = false

		@leftIconLayer = new Icon
			parent: @
			x: 8
			y: Align.center(-2) 
			height: 20
			width: 20
			icon: 'star'
			color: options.border
			visible: false

		@rightIconLayer = new Icon
			parent: @
			x: Align.right(-8)
			y: Align.center(-2)
			height: 20
			width: 20
			icon: 'star'
			color: options.border
			visible: false

		delete @__constructor

		@on "change:border", (color) =>
			@leftIconLayer.color = color
			@rightIconLayer.color = color

		@leftIcon = options.leftIcon
		@rightIcon = options.rightIcon
		@focused = options.focused
		@value = options.value
		@placeholder = options.placeholder
		@disabled = options.disabled
		@pattern = options.pattern
		@border = options.border
		@title = options.title

	submit: => @emit("submit", @input.value, @)

	setScroll: (scroll) => 
		@view?.scrollVertical = scroll
		@input.readonly = scroll

	setInputAttribute: (attribute, value) ->
		@input.setAttribute(attribute, value)

	showFocused: =>
		return if @disabled
		
		if @focused
			app?.openKeyboard(@)
		else
			app?.closeKeyboard()

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

			string = Colors.validate(string) ? Colors.black

			@_color = string

			@input.style.color = "#{@color}"
			@input.style['-webkit-text-fill-color'] = "#{@color}"

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
			@leftIconLayer.icon = @_leftIcon ? ''
			@leftIconLayer.visible = @_leftIcon?
			@setInputPosition()

	@define "rightIcon",
		get: -> return @_rightIcon
		set: (icon) ->
			return if @__constructor
			@_rightIcon = icon
			@rightIconLayer.icon = @_rightIcon ? ''
			@rightIconLayer.visible = @_rightIcon?
			@setInputPosition()

	@define 'placeholder',
		get: -> return @_placeholder
		set: (string) ->
			return if @__constructor
			@_placeholder = string
			@setInputAttribute('placeholder', string)

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