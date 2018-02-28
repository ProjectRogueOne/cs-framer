# TextField

class exports.TextField extends TextLayer
	constructor: (options = {}) ->

		@_color = options.color ? 'rgba(0,0,0,.87)'
		@_inputType = options.inputType ? 'text'
		@_inputMode = options.inputMode ? 'latin'
		@_maxLength = options.maxLength
		@_placeholder = options.placeholder ? ''
		@_readOnly = options.readOnly
		@_value = ''
		
		@tint = options.tint ? 'blue'
		@selectionColor = options.selectionColor ? new Color(@tint).desaturate(-20).alpha(.5)

		@_warn = false
		@_warnText = options.warnText ? 'Warning description.'

		@pattern = options.pattern ? (value) -> null
		@matches = false

		@_warn
		@_disabled
		@_focused
		@_color
		@_helperText
		@_helperTextColor
		@_labelText
		@_labelTextColor

		super _.defaults options,
			text: ''
			fontSize: 14
			height: 48
			width: 256
			borderWidth: 1
			borderRadius: 4
			padding: {top: 4, right: 12, bottom: 4, left: 12}
			animationOptions: { time: .15 }

		@_input = document.createElement('input')
		@_element.appendChild(@_input)
		
		@_input.spellcheck 		= false
		@_input.autocapitalize  = false
		@_input.autocomplete 	= false
		@_input.tabindex 		= "-1"
		@_input.placeholder 	= @_placeholder
		
		Utils.insertCSS( """
			*:focus { outline: 0; }
			textarea { resize: none; } 
			::selection { background: #{@selectionColor}; } 
			}""" )
			
		@setStyle()
		
		@_input.onfocus = => @focused = true;# @setScroll(false)
		@_input.onblur = => @focused = false; #@setScroll(true)
		@_input.oninput = @setValue

		@warnText = new TextLayer
			parent: @
			y: @height + 8
			fontSize: 10
			fontFamily: @fontFamily
			color: '#FF3333'
			text: '{warnText}'
			visible: @_warn

		@warnText.template = @_warnText

		@states =
			disabled:
				borderColor: '#AAA'
				color: '#CCC'

			focus_hasText:
				borderColor: '#000'
				color: '#333'

			focus_noText:
				borderColor: '#000'
				color: '#AAA'

			unfocus_hasText:
				borderColor: '#AAA'
				color: '#000'

			unfocus_noText:
				borderColor: '#AAA'
				color: '#AAA'

			warn_noText:
				borderColor: '#FF3333'
				color: '#FF7777'

			warn_hasText:
				borderColor: '#FF3333'
				color: '#FF3333'


		@on "change:color", => @_input.style['-webkit-text-fill-color'] = @color
		@showFocused()

	# setPlaceholder: => 
	# 	if @hasTextContent() or not @focused
	# 		@color = null 
	# 	else if @focused
	# 		@color = 'rgba(0,0,0,.42)'
	
	setStyle: ->
		@_input.style.cssText = """
			z-index:5;
			zoom: #{@context.scale};
			font-size: #{@fontSize}px;
			font-weight: #{@fontWeight};
			font-family: #{@fontFamily};
			color: #{@tint};
			-webkit-text-fill-color: #{@_color};
			background-color: transparent;
			position: absolute;
			top: 0px;
			left: 0px;
			resize: none;
			width: #{@width}px;
			height: 100%;
			padding: #{@padding.top}px #{@padding.right}px #{@padding.bottom}px #{@padding.left}px;
			outline: 0px none transparent !important;
			line-height: #{@lineHeight};
			-webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */
			-moz-box-sizing: border-box;    /* Firefox, other Gecko */
			box-sizing: border-box; 
		"""

	# set value of textlayer using textarea value
	setValue: => @value = @_input.value
	
	# set individual attribute of textarea
	setInputAttribute: (attribute, value) ->
		@_input.setAttribute(attribute, value)
	
	focus: => @_input.focus()

	showFocused: =>
		if @disabled 
			@animateStop()
			@animate 'disabled'
			return

		if @warn 
			@animateStop()
			if @hasTextContent() then @animate 'warn_hasText'
			else @animate 'warn_noText'
			return

		if @focused
			@animateStop()

			if @hasTextContent() then @animate 'focus_hasText'
			else @animate 'focus_noText'

		else
			@animateStop()

			if @hasTextContent() then @animate 'unfocus_hasText'
			else @animate 'unfocus_noText'			
		
	hasTextContent : -> @value.length  		> 0
	hasHelperText  : -> @helperText?.length  > 0
	hasLabelText   : -> @labelText?.length   > 0
	hasPlaceholder : -> @_placeholder?.length > 0	
		
	# value
	@define "value",
		get: -> return @_value
		set: (value) ->
			return if @_value is value
			
			@_value = value

			@matches = @pattern(value)
			@emit("change:value", @value, @matches, @)

			@showFocused()

	# disabled
	@define "disabled",
		get: -> return @_disabled
		set: (value) ->
			return if @_disabled is value
			if typeof value isnt 'boolean' then throw 'Disabled must be either true or false.'
			
			@_disabled = value

			@emit("change:disabled", value, @)
			@showFocused()

	# warn
	@define "warn",
		get: -> return @_warn
		set: (value) ->
			return if @_warn is value
			if typeof value isnt 'boolean' then throw 'Warn must be either true or false.'
			
			@_warn = value

			@emit("change:warn", value, @)
			
			@warnText.visible = @_warn
			@showFocused()

	# warn
	@define "warning",
		get: -> return @_warnText
		set: (value) ->
			return if @_warnText is value
			@_warnText = value
			@warnText.template = @_warnText

	# focused
	@define "focused",
		get: -> return @_focused
		set: (value) ->
			return if @_focused is value
			if typeof value isnt 'boolean' then throw 'Focused must be either true or false.'
			
			@_focused = value

			# blur or focus text area if set programmaically
			if value is true and document.activeElement isnt @_input 
				@_input.focus()
			else if value is false and document.activeElement is @_input
				@_input.blur()

			@emit("change:focused", value, @)
			@showFocused()
