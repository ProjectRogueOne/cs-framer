{ theme } = require 'components/Theme'

class exports.Puller extends Layer
	constructor: (options = {}) ->

		# ---------------
		# Options

		@app = options.app

		_.defaults options,
			name: 'Puller'
			x: 0
			y: 0
			width: Screen.width
			backgroundColor: main
			animationOptions:
				time: .2

			text: "Puller content"
			cta: null
			ctaSelect: => null
			link: null
			linkSelect: => null

		@customTheme = undefined
		@customOptions = {}

		super options

		# ---------------
		# Layers

		@textLayer = new Body
			parent: @
			x: 15
			y: 15
			width: @width - 30
			color: white
			text: options.text
		
		@shape = new Layer
			parent: @
			name: '.'
			size: 15
			x: 15
			y: Align.bottom(7)
			backgroundColor: @backgroundColor
			rotation: 45

		if options.cta?
			@cta = new Button
				parent: @
				x: 15
				y: @textLayer.maxY + 22
				dark: true
				text: options.cta
				select: options.ctaSelect

			if options.link?

				@link = new Body
					parent: @
					x: @cta.maxX + 15
					y: @cta.y + 9
					text: options.link
					textDecoration: 'underline'
					color: white

				@link.onTap -> options.linkSelect

		# ---------------
		# Events

		Utils.linkProperties @, @shape, 'backgroundColor'

		@on "change:size", @_setSize
		@on "change:children", @_setSize

		# ---------------
		# Definitions
		
		@_setSize()

	# ---------------
	# Private Methods

	_setContent: (text) =>
		@textLayer.text = text
		@_setSize()

	_setSize: =>
		_.assign @,
			width: @parent?.width ? Screen.width
			x: 0
			y: 0

		if @width > 1280
			@shape.x = 50
			@textLayer.x = 50
			@cta?.x = @textLayer.x
			@cta?.y = @textLayer.maxY + 25
			@link?.x = @cta?.maxX + 25
			@height = _.maxBy(_.without(@children, @shape), 'maxY')?.maxY + 25

		else if @width > 940
			@shape.x = 25
			@textLayer.x = 25
			@cta?.x = @textLayer.x
			@cta?.y = @textLayer.maxY + 15
			@link?.x = @cta?.maxX + 15
			@height = _.maxBy(_.without(@children, @shape), 'maxY')?.maxY + 15

		else if @width > 768
			@shape.x = 15
			@textLayer.x = 15
			@cta?.x = @textLayer.x
			@cta?.y = @textLayer.maxY + 15
			@link?.x = @cta?.maxX + 15
			@height = _.maxBy(_.without(@children, @shape), 'maxY')?.maxY + 15

		else  
			@shape.x = 15
			@textLayer.x = 10
			@cta?.x = @textLayer.x
			@cta?.y = @textLayer.maxY + 15
			@link?.x = @cta?.maxX + 15
			@height = _.maxBy(_.without(@children, @shape), 'maxY')?.maxY + 15


		@textLayer.width = @width - (@textLayer.x * 2)
		@shape.y = Align.bottom(7)


	# ---------------
	# Public Methods


	# ---------------
	# Special Definitions