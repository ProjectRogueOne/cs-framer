# TextField

{ colors } = require 'Colors'
{ flow } = require 'Flow'
Type = require 'Type'

class exports.TextField extends Layer
	constructor: (options = {}) ->
		
		@view = options.view
		@inputMode = options.inputMode ? 'latin'
		@placeholder = options.placeholder ? ''
		@readOnly = options.readOnly
		@maxLength = options.maxLength
		@_value = ''
		
		@_disabled
		@_focused
		@_color
		@_helperText
		@_helperTextColor
		@_labelText
		@_labelTextColor
		
		options.value ?= ''
		options.focused ?= false
		
		super _.defaults options,
			name: 'Input'
			height: 32
			backgroundColor: null
			borderWidth: 1
			borderRadius: 2
			borderColor: colors.dim
			animationOptions: { time: .15 }
		
		@_baseWidth = options.width
				
		Utils.insertCSS( """
			*:focus { outline: 0; }
			textarea { resize: none; } 
			::selection { background: #{new Color(colors.tint).alpha(.2)}; } 
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
			font-family: '#{Type.fonts.ui}';
			color: #{colors.tint};
			-webkit-text-fill-color: #{colors.bright};
			background-color: transparent;
			position: absolute;
			top: 0px;
			left: 0px;
			padding: 6px;
			resize: none;
			width: #{@width}px;
			outline: 0px none transparent !important;
			line-height: #{@lineHeight};
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

		@view.onScrollStart => @disabled = true
		@view.onScrollEnd => @disabled = false
		
		@focused = options.focused
		@value = options.value

	submit: => @emit("submit", @input.value, @)

	setScroll: (scroll) => 
		@view?.scrollVertical = scroll
		@input.readonly = scroll

	setInputAttribute: (attribute, value) ->
		@input.setAttribute(attribute, value)

	showFocused: =>
		return if @disabled
		
		if @focused
			@animate
				borderColor: colors.dim
			flow.openKeyboard(@)
			
		else
			@animate
				borderColor: colors.pale
			flow.closeKeyboard()

	showDisabled: =>
		@animateStop()
		@opacity = if @disabled is true then .5 else 1

	hasTextContent : -> @value.length > 0
	
	setValue: => @value = @input.value

	clearValue: -> 
		@input.value = ''
		@setValue()
	
	@define "value",
		get: -> return @_value
		set: (value) ->
			return if @_value is value
			
			@_value = value

			@emit("change:value", @value, @matches, @)
			
	@define "disabled",
		get: -> return @_disabled
		set: (value) ->
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