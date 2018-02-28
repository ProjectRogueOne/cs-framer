# Donut
# Authors: Steve Ruiz
# Last Edited: 1 Nov 17

{ Colors } = require 'Colors'
{ Text } = require 'Text'

class exports.Donut extends PageComponent
	constructor: (options = {}) ->
		@__constructor = true
		@showLayers = options.showLayers ? true

		{ app } = require 'App'
		
		@_color
		@_stroke
		@_strokeWidth2
		@_fill
		@_min
		@_max
		@_value
		@_showCircle
		@_showNumber

		@_pages = []
		@_indicators = []

		# set default properties

		_.defaults options,
			name: 'Donut'
			x: Align.center()
			type: undefined
			color: 'black'
			stroke: 'secondary'
			strokeWidth: 2
			fill: 'white'
			showCircle: true
			showNumber: true
			pages: []
			min: 0
			max: 700
			value: 0
			animationOptions:
				time: 1

		if options.type is "dashboard"
			options.size = "large"
			options.value ?= 420

		# set size using type
		
		sizes =
			icon:	{ width: 40,  height: 40,  fontSize: 20, padding: 3 }
			small:	{ width: 120, height: 120, fontSize: 36, padding: 5 }
			medium: { width: 250, height: 250, fontSize: 64, padding: 6 }
			large:	{ width: 335, height: 335, fontSize: 96, padding: 8 }

		size = sizes[options.size] ? sizes['medium']

		delete options.size

		# set forced properties

		_.assign options,
			backgroundColor: null
			borderRadius: 999
			clip: true
			borderWidth: 1
			borderColor: 'rgba(0,0,0,.12)'
			scrollVertical: false
			propagateEvents: true
			width: size.width
			height: size.height

		super options

		# layers

		@content.backgroundColor = @backgroundColor
		@content.animationOptions = { curve: "spring(300, 35, 0)" }

		# number layer

		@numberLayer = new TextLayer
			name: if @showLayers then 'Number' else '.'
			parent: @
			y: @width / 2 - (size.fontSize / 2)
			fontFamily: 'Helvetica Neue'
			fontSize: size.fontSize
			lineHeight: 1
			text: '{value}'
			width: @width
			textAlign: 'center'
			visible: false

		@numberLayer.templateFormatter = (value) ->
			return value.toFixed()

		# svg parent layer

		@circleLayer = new Layer
			parent: @
			size: @size
			backgroundColor: null

		svgNS = "http://www.w3.org/2000/svg"
		
		# svg

		@svg = document.createElementNS(svgNS, 'svg')

		width = @width * Framer.Device.context.scale
		height = @height * Framer.Device.context.scale

		@setAttributes @svg,
			height: height
			width: width
			viewBox: "0 0 #{@height} #{@width}"

		@circleLayer._element.appendChild(@svg)

		# circle

		@circle = document.createElementNS(svgNS, 'circle')

		@svg.appendChild(@circle)

		@circleLayer.bringToFront()
		
		delete @__constructor


		# events

		# set current indicator when page changes
		@on "change:currentPage", @_setIndicators

		# remake indicators when pages are added or removed
		@content.on "change:children", @_makeIndicators

		# freeze app from scrolling when panned
		@onPan (event) ->
			return if @content.children.length <= 0

			if Math.abs(@content.draggable.offset) > 64 or
			Math.abs(event.velocity.x) > 1
				app?.current.scrollVertical = false

		# restart app's scrolling when touch ends
		@onTouchEnd ->
			app?.current.scrollVertical = true

		# set number's color when color changes
		@on "change:color", (string, color) =>
			@numberLayer.color = color


		# assign properties that required layers

		_.assign @,
			padding: size.padding
			value: options.value
			color: options.color
			showNumber: options.showNumber

		switch options.type
			when "dashboard" then @_makeDashboardPages()

	setAttributes: (element, attributes = {}) ->
		for key, value of attributes
			element.setAttribute(key, value)

	resetType: ->
		layer.destroy() for layer in @content.children
		@_makeIndicators()
		@numberLayer.visible = @showNumber

	setType: ->
		@resetType()

		switch @type
			when "dashboard" then @_makeDashboardPages()

		@setArc()

	showAmount: ->
		value = @value

		@value = 0
		@animate
			value: value

	setArc: ->
		return if @__constructor

		radius = @width / 2
		circumference = (2 * Math.PI) * (radius - @padding)

		@setAttributes @circle,
			cx: radius
			cy: radius
			r: radius - @padding
			fill: "none"
			stroke: if @_showCircle then @stroke else "none"
			'stroke-linecap': 'round'
			'stroke-width': @strokeWidth
			'stroke-dasharray': circumference
			'stroke-dashoffset': circumference * (1 - (@value / @max))
			transform: "rotate(-90, #{radius}, #{radius})"

	_makeDashboardPages: ->

		# - page 0

		firstPage = @newPage()

		@numberLayer.parent = firstPage
		@numberLayer.y -= 16
		@numberLayer.visible = true

		@titleLayer = new Text
			name: if @showLayers then 'Title' else '.'
			parent: firstPage
			y: @numberLayer.y / 1.618
			type: 'body'
			text: 'Your credit score is'
			width: @width
			color: 'black'
			textAlign: 'center'

		# caption

		@captionLayer = new Text
			name: if @showLayers then 'Caption' else '.'
			parent: firstPage
			y: @numberLayer.maxY + 8
			type: 'body'
			text: 'out of {value}'
			width: @width
			color: 'black'
			textAlign: 'center'

		@captionLayer.template = @max

		@on "change:max", (value) =>
			@captionLayer.template = value

		# link

		@linkLayer = new Text
			name: if @showLayers then 'Link' else '.'
			parent: firstPage
			y: 242
			x: Align.center
			type: 'body'
			text: 'Build your score'
			width: @width * .8
			color: 'tertiary'
			textAlign: 'center'

		# - page 1

		offersPage = @newPage()

		@cardShape = new Layer
			parent: offersPage
			backgroundColor: null
			y: @height * .12
			rotation: -20
			x: Align.center
			width: 100
			height: 105
			html: """
				<svg width="119px" height="105px" viewBox="0 0 119 105" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
					<path d="M3.93740784,0.0254407558 L96.8987173,12.5520113 C99.0732876,12.8450354 100.836125,14.8474577 100.836125,17.0200456 L100.836125,72.9554717 C100.836125,75.1300748 99.075272,77.1302145 96.8987173,77.423506 L3.93740784,89.9500765 C1.76283754,90.2431007 0,87.9641416 0,84.866297 L0,5.10922028 C0,2.00850223 1.76085322,-0.267850776 3.93740784,0.0254407558 Z" fill="#{Colors.grey}" ></path>
				</svg>
				"""

		@captionLayer = new Text
			name: if @showLayers then 'Caption' else '.'
			parent: offersPage
			y: @cardShape.maxY + 32
			x: Align.center
			type: 'body'
			text: 'Build your score with these great offers'
			width: @width * .8
			color: 'black'
			textAlign: 'center'

		@linkLayer = new Text
			name: if @showLayers then 'Link' else '.'
			parent: offersPage
			y: 242
			x: Align.center
			type: 'body'
			text: 'See offers'
			width: @width * .6
			color: 'tertiary'
			textAlign: 'center'

		# - page 2

		todoPage = @newPage()

		@cardShape = new Layer
			parent: todoPage
			backgroundColor: Colors.grey
			y: @height * .12
			rotation: -20
			x: Align.center
			width: 100
			height: 100
			borderRadius: 50

		@captionLayer = new Text
			name: if @showLayers then 'Caption' else '.'
			parent: todoPage
			y: @cardShape.maxY + 32
			x: Align.center
			type: 'body'
			text: 'See the next to-do item on your list'
			width: @width * .6
			color: 'black'
			textAlign: 'center'

		@todoLinkLayer = new Text
			name: if @showLayers then 'Link' else '.'
			parent: todoPage
			y: 242
			x: Align.center
			type: 'body'
			text: 'Explore your to-do'
			width: @width * .8
			color: 'tertiary'
			textAlign: 'center'

		@_baseValue = @value

		@on "change:currentPage", ->
			if @currentPage is firstPage
				@animate
					value: @_baseValue
			else
				@animate
					value: @max

		@on "change:type", @setType


	newPage: (page) ->
		if not page?
			page = new Layer
				name: if @showLayers then "Page #{@content.children.length}" else '.'
				size: @size
				backgroundColor: @backgroundColor

		@addPage(page, 'right')
		@pages.push(page)

		return page



	_makeIndicators: =>
		layer.destroy() for layer in @_indicators

		@_indicators = []

		for page, i in @content.children

			indicator = new Layer
				name: if @showLayers then "Indicator #{i}" else '.'
				parent: @
				backgroundColor: '#000'
				y: Align.bottom(-24)
				width: 8, 
				height: 8, 
				borderRadius: 9
				animationOptions:
					time: .25

			indicator.page = page

			do (indicator, page) =>
				indicator.onTap =>
					@snapToPage(page)

			@_indicators.push(indicator)

		Utils.distribute.horizontal(@, @_indicators)
		@_setIndicators()


	_setIndicators: =>
		for indicator in @_indicators
			if indicator.page is @currentPage
				indicator.animate
					opacity: 1
					scale: 1.382
			else
				indicator.animate
					opacity: .618
					scale: 1

	@define "type",
		get: -> return @_type
		set: (string) ->
			return if @__constructor

			@_type = string

			@emit "change:type", string, @

	@define "color",
		get: -> return @_color
		set: (string) ->
			return if @__constructor

			color = Colors.validate(string)

			@_color = color ? Colors.black

			@emit "change:color", string, color, @

	@define "fill",
		get: -> return @_fill
		set: (string) ->

			@_fill = Colors.validate(string) ? Colors.primary
			@backgroundColor = @_fill

	@define "strokeWidth",
		get: -> return @_strokeWidth
		set: (value) ->
			@_strokeWidth = value

			@setArc()

	@define "stroke",
		get: -> return @_stroke
		set: (value) ->

			color = Colors.validate(value) ? Colors.tertiary
			@_stroke = color

			@setArc()

	@define "min",
		get: -> return @_min
		set: (value) ->
			@_min = value

			@setArc()
			@showAmount()

			@emit "change:min", value, @

	@define "max",
		get: -> return @_max
		set: (value) ->
			@_max = value

			@setArc()
			@showAmount()

			@emit "change:max", value, @

	@define "showNumber",
		get: -> return @_showNumber
		set: (bool) ->
			return if @__constructor
			@_showNumber = bool

			@numberLayer.visible = bool

	@define "pages",
		get: -> return @_pages

	@define "showCircle",
		get: -> return @_showCircle
		set: (bool) ->
			@_showCircle = bool

	@define "value",
		get: -> return @_value
		set: (value) ->
			return if @__constructor
			
			value = _.clamp(value, @min, @max)
			
			@_value = value

			@setArc()

			if value? then @numberLayer.template = value ? 0

			@emit "change:value", value, @