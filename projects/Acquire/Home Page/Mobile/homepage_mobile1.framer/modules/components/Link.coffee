{ theme } = require "components/Theme"
MODEL = 'link'

class exports.Link extends TextLayer
	constructor: (options = {}) ->

		@app = options.app

		# ---------------
		# Options

		_.defaults options,
			padding: {top:12, bottom: 12}
			disabled: false
			icon: undefined
			select: => null
			animationOptions:
				time: .15
				colorModel: 'husl'

		@customTheme = if options.color then @_getCustomTheme(options.color) else undefined
		
		@customOptions =
			color: options.color

		super options


		# ---------------
		# Layers

		@_setTheme('default')


		# ---------------
		# Definitions

		@__instancing = true

		Utils.defineValid @, 'theme', 'default', _.isString, "Link.theme must be a string.", (value) => @_setTheme(value)
		Utils.defineValid @, 'disabled', options.disabled, _.isBoolean, "Link.disabled must be a boolean (true or false).", @_showDisabled
		Utils.defineValid @, 'hovered', false, _.isBoolean, "Link.hovered must be a boolean (true or false).", @_showHovered
		Utils.defineValid @, 'select', options.select, _.isFunction, "Link.select must be a function."

		delete @__instancing


		# ---------------
		# Events
		
		@onMouseOver => @hovered = true
		@onMouseOut => @hovered = false

		@onTouchStart (event) => @_showTouching(true, null, event)
		@onTouchEnd (event) => @_showTouching(false, null, event)

		@onTap @_showTapped
		@onPan @_panOffTouch

		for child in @children
			if !options.showNames
				child.name = '.'

	# ---------------
	# Private Methods

	_getCustomTheme: (color) ->
		color = new Color(color)
		customTheme =
			default:
				color: color
			disabled:
				color: color.alpha(.15)
			touched:
				color: color.lighten(30)
			hovered:
				color: color.lighten(20)
		
		return customTheme

	_setTheme: (value) =>
		@animateStop()
		props = @customTheme?[value] ? _.defaults _.clone(@customOptions), theme[MODEL][value]
		if @__instancing then @props = props else @animate props

	_showHovered: (bool) =>
		return if @disabled

		if bool
			# show hovered
			@theme = 'hovered'
			return

		# show not hovered
		@theme = 'default'

	_showDisabled: (bool) =>
		if bool
			# show disabled
			@theme = 'disabled'
			@ignoreEvents = true
			return

		# show not disabled
		@theme = 'default'
		@ignoreEvents = false

	_doSelect: (event) =>
		return if @disabled

		try @select(event, @)
		@emit "select", @

	_panOffTouch: (event) => 
		return if @_isTouching is false
		return if @disabled
		return if @theme is "default"

		if Math.abs(event.offset.x) > @width/2 or
		Math.abs(event.offset.y) > @height/2
			@theme = "default"

	_showTapped: =>
		return if @disabled
		return if @_isTouching is true

		@theme = "touched"
		Utils.delay .1, => @theme = "default"


	_showTouching: (isTouching, silent = false, event) =>
		return if @disabled
		@animateStop()
		
		if isTouching
			# show touching
			@_isTouching = true
			@theme = "touched"
			return
		
		# show not touching
		@_isTouching = false
		@theme = "default"

		unless silent then @_doSelect(event)

	# ---------------
	# Public Methods
	
	onSelect: (callback) => @select = callback