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
					shadowColor: 'rgba(0,0,0,.16)'
				disabled:
					color: white
					borderColor: null
					backgroundColor: alto
					shadowColor: 'rgba(0,0,0,0)'
				hovered:
					color: white
					borderColor: null
					backgroundColor: glacier
					shadowColor: 'rgba(0,0,0,.16)'


		# light secondary
		if !options.dark and options.secondary
			@palette =
				default:
					color: bondi
					borderColor: bondi
					backgroundColor: null
					shadowColor: 'rgba(0,0,0,0)'
				disabled:
					color: alto
					borderColor: alto
					backgroundColor: null
					shadowColor: 'rgba(0,0,0,0)'
				hovered:
					color: glacier
					borderColor: glacier
					backgroundColor: null
					shadowColor: 'rgba(0,0,0,0)'

				# dark primary
		if options.dark and !options.secondary
			@palette =
				default:
					color: midnightBlue
					borderColor: null
					backgroundColor: white
					shadowColor: 'rgba(0,0,0,.16)'
				disabled:
					color: white
					borderColor: null
					backgroundColor: alto
					shadowColor: 'rgba(0,0,0,0)'
				hovered:
					color: glacier
					borderColor: null
					backgroundColor: white
					shadowColor: 'rgba(0,0,0,.16)'

				# dark secondary
		if options.dark and options.secondary
			@palette =
				default:
					color: white
					borderColor: white
					backgroundColor: null
					shadowColor: 'rgba(0,0,0,0)'
				disabled:
					color: osloGrey
					borderColor: osloGrey
					backgroundColor: null
					shadowColor: 'rgba(0,0,0,0)'
				hovered:
					color: bondi
					borderColor: white
					backgroundColor: null
					shadowColor: 'rgba(0,0,0,0)'

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
		Utils.define @, 'secondary', options.secondary

		# Events

		@on "mouseenter", => @hovered = true
		@on "mouseleave", => @hovered = false

		@onTouchStart => @_showTouching(true)
		@onTouchEnd => @_showTouching(false)

		@onTap @_showTapped
		@onPan @_panOffTouch

		for child in @children
			if !options.showNames
				child.name = '.'

	# private

	_setStateStyle: (state) =>
		@textLayer.color = @palette[state].color
		
		_.assign @,
			borderColor: @palette[state].borderColor
			backgroundColor: @palette[state].backgroundColor
			shadowColor: @palette[state].shadowColor

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
			return

		# show not disabled
		@_setStateStyle('default')
		@ignoreEvents = false

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
			@_isTouching = true

			@py = @y + 2
			@dy = @y

			if !@secondary
				@animate
					# brightness: 90
					shadowY: 0
					y: @py
			return
		
		# show not touching
		@_isTouching = false

		if !@secondary
			@animate
				# brightness: 100
				shadowY: 2
				y: @dy

		unless silent then @_doSelect()

	# public

	onSelect: (callback) => @select = callback
