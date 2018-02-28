# Button

class exports.Button extends Layer
	constructor: (options = {}) ->
		@app = options.app
		
		_.defaults options,
			width: 0
			height: 50
			borderRadius: 4
			borderWidth: 1
			shadowY: 2
			shadowBlur: 6
			animationOptions:
				time: .125
			shadowColor: 'rgba(0,0,0,.16)'
			text: 'Get Started'
			dark: false
			secondary: false
			disabled: false
			icon: undefined
			select: => null
		

		# light primary
		if !options.dark and !options.secondary
			@palette =
				default:
					color: white
					borderColor: null
					backgroundColor: bondi
				disabled:
					color: white
					borderColor: null
					backgroundColor: alto
				hovered:
					color: white
					borderColor: null
					backgroundColor: glacier


		# light secondary
		if !options.dark and options.secondary
			@palette =
				default:
					color: bondi
					borderColor: bondi
					backgroundColor: white
				disabled:
					color: alto
					borderColor: alto
					backgroundColor: white
				hovered:
					color: glacier
					borderColor: glacier
					backgroundColor: white

				# dark primary
		if options.dark and !options.secondary
			@palette =
				default:
					color: midnightBlue
					borderColor: null
					backgroundColor: white
				disabled:
					color: white
					borderColor: null
					backgroundColor: alto
				hovered:
					color: glacier
					borderColor: null
					backgroundColor: white

				# dark secondary
		if options.dark and options.secondary
			@palette =
				default:
					color: white
					borderColor: white
					backgroundColor: midnightBlue
				disabled:
					color: osloGrey
					borderColor: osloGrey
					backgroundColor: midnightBlue
				hovered:
					color: bondi
					borderColor: white
					backgroundColor: midnightBlue

		parent = options.parent
		delete options.parent

		super options
			
		@textLayer = new Body
			textAlign: 'center'
			color: @palette.color
			text: options.text

		# Show icon?

		if options.icon?
			
			@iconLayer = new Icon
				parent: @
				width: 24
				height: 24
				color: @palette.color
				icon: options.icon
				
			@textLayer.x = @iconLayer.maxX + 8
			
			if width
				@width = width
				contentWidth = @iconLayer.width + 8 + @textLayer.width
				@iconLayer.x = (width - contentWidth / 2)
				@textLayer.x = @iconLayer.maxX + 8
			else
				Utils.contain(@, {top: 16, bottom: 11, left: 20, right: 28})

		else

			unless options.width
				@width = @textLayer.width + 40

			_.assign @textLayer,
				parent: @
				x: Align.center()
				y: Align.center(3)

			@on "change:width", =>
				_.assign @textLayer,
					x: Align.center()
					y: Align.center(3)

		
		# Fix position

		_.assign @,
			x: options.x
			y: options.y

		_.assign @,
			parent: parent
			x: options.x
			y: options.y

		@_setStateStyle('default')
		
		# Definitions

		Utils.define @, 'hovered', false, @_showHovered
		Utils.define @, 'disabled', options.disabled, @_showDisabled
		Utils.define @, 'select', options.select

		# Events

		@on "mouseenter", => @hovered = true
		@on "mouseleave", => @hovered = false

		@onTouchStart => @_showTouching(true)
		@onTouchEnd => @_showTouching(false)

		@onTap @_showTapped
		@onPan @_panOffTouch

	# private

	_setStateStyle: (state) =>
		@textLayer.color = @palette[state].color
		
		_.assign @,
			borderColor: @palette[state].borderColor
			backgroundColor: @palette[state].backgroundColor

	_showHovered: (bool) =>
		return if @disabled

		if bool
			# show hovered
			@_setStateStyle('hovered')
			return

		# show not hovered
		@_setStateStyle('default')

	_showDisabled: (bool) =>
		if bool
			# show disabled
			@_setStateStyle('disabled')
			@ignoreEvents = true
			@shadowColor = 'rgba(0,0,0,0)'
			return

		# show not disabled
		@_setStateStyle('default')
		@ignoreEvents = false
		@shadowColor = 'rgba(0,0,0,.16)'

	_doSelect: =>
		return if @disabled

		@select()

	_panOffTouch: (event) => 
		return if @_isTouching is false

		if Math.abs(event.offset.x) > @width/2 or
		Math.abs(event.offset.y) > @height/2
			@_showTouching(false, true)

	_showTapped: =>
		return if @_isTouching is true

		@_showTouching(true)
		Utils.delay .15, => @_showTouching(false)


	_showTouching: (isTouching, silent = false) =>
		return if @disabled
		@animateStop()
		
		if isTouching
			# show touching
			@py = @y + 2
			@dy = @y

			@_isTouching = true
			@animate
				brightness: 90
				shadowY: 0
				y: @py
			return
		
		# show not touching
		@_isTouching = false
		@animate
			brightness: 100
			shadowY: 2
			y: @dy

		unless silent then @_doSelect()

	# public

	onSelect: (callback) => @select = callback
