# TextField
# Authors: Steve Ruiz
# Last Edited: 25 Sep 17

Type = require 'Mobile'
{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
{ Button } = require 'Button'


class exports.TextField extends Button
	constructor: (options = {}) ->
		@__constructor = true
		
		@view = options.view
		@inputMode = options.inputMode ? 'latin'
		@placeholder = options.placeholder ? ''
		@readOnly = options.readOnly
		@maxLength = options.maxLength
		
		@_value
		@_leftIcon
		@_rightIcon
		@_disabled
		@_focused
		@_color
		@_helperText
		@_helperTextColor
		@_labelText
		@_labelTextColor
		

		options.text = ''
		options.value ?= ''
		options.disabled ?= false
		options.focused ?= false
		options.border ?= 'white'
		
		super _.defaults options,
			name: 'Input'
			fill: 'transparent'
		
		@_baseWidth = options.width
				
		Utils.insertCSS( """
			*:focus { outline: 0; }
			textarea { resize: none; } 
			::selection { background: #{new Color(Colors.tint).alpha(.2)}; } 
			""" )
			
		@input = document.createElement('input')
		@_element.appendChild(@input)
		
		@input.spellcheck 		= false
		@input.autocapitalize   = false
		@input.autocomplete 	= false

		@setInputAttribute('placeholder', @placeholder)
		@setInputAttribute('inputmode', @inputMode)
		
		if @maxLength? then @setInputAttribute('maxlength', @maxLength)
		if @readOnly? then @setInputAttribute('readonly', @readOnly)
		
		@input.style.cssText = """
			z-index:5;
			zoom: #{@context.scale};
			font-size: 14px;
			font-family: 'Helvetica Neue;
			font-weight: 400;
			color: #{Colors.black};
			-webkit-text-fill-color: #{Colors.black};
			background-color: transparent;
			position: absolute;
			top: 10px;
			left: 10px;
			padding: 6px;
			resize: none;
			width: #{@width - 20}px;
			outline: 0px none transparent !important;
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

		@leftIcon = options.leftIcon
		@rightIcon = options.rightIcon
		@focused = options.focused
		@value = options.value
		@disabled = options.disabled

	submit: => @emit("submit", @input.value, @)

	setScroll: (scroll) => 
		@view?.scrollVertical = scroll
		@input.readonly = scroll

	setInputAttribute: (attribute, value) ->
		@input.setAttribute(attribute, value)

	showFocused: =>
		return if @disabled
		
		if @focused
			flow?.openKeyboard(@)
			
		else
			flow?.closeKeyboard()

	showDisabled: =>
		@animateStop()
		@opacity = if @disabled is true then .5 else 1

	hasTextContent : -> @value.length > 0
	
	setValue: => @value = @input.value

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

	@define "leftIcon",
		get: -> return @_leftIcon
		set: (icon) ->
			return if @__constructor
			@_leftIcon = icon
			@leftIconLayer.icon = @leftIcon
			@leftIconLayer.visible = @leftIcon?
			@setInputPosition()

	@define "rightIcon",
		get: -> return @_rightIcon
		set: (icon) ->
			return if @__constructor
			@_rightIcon = icon
			@rightIconLayer.icon = @rightIcon
			@rightIconLayer.visible = @rightIcon?
			@setInputPosition()

	@define "value",
		get: -> return @_value
		set: (value) ->
			return if @__constructor
			return if @_value is value
			
			@_value = value

			@emit("change:value", @value, @matches, @)
			
	@define "disabled",
		get: -> return @_disabled
		set: (value) ->
			return if @__constructor
			return if @_disabled is value
			if typeof value isnt 'boolean'
				throw 'Disabled must be either true or false.'
			
			@_disabled = value
			@input.blur()
			@input.disabled = value

			@emit("change:disabled", value, @)

			@showDisabled()
		
	@define "focused",
		get: -> return @_focused
		set: (value) ->
			return if @__constructor
			return if @_focused is value
			if typeof value isnt 'boolean'
				throw 'Focused must be either true or false.'
			
			@_focused = value

			# blur or focus text area if set programmaically
			if value is true and document.activeElement isnt @input 
				@input.focus()
			else if value is false and document.activeElement is @input
				@input.blur()

			@emit("change:focused", value, @)

			@showFocused()