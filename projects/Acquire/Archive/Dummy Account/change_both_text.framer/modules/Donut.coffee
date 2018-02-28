# Donut
# Authors: Steve Ruiz
# Last Edited: 4 Oct 17

{ Colors } = require 'Colors'
{ Text } = require 'Text'

class exports.Donut extends PageComponent
	constructor: (options = {}) ->
		@__constructor = true
		@showLayers = options.showLayers ? true

		{ app } = require 'App'
		
		@_color
		@_stroke
		@_strokeWidth

		@_min
		options.min ?= 0

		@_max
		options.max ?= 700

		@_value
		options.value

		@_indicators = []
		options.pages ?= []

		if options.type is "dashboard"
			options.size = "large"

		# set size
		
		sizes =
			icon:	{ width: 40,  height: 40,  fontSize: 24, padding: 3 }
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

		# set default properties

		super _.defaults options,
			color: 'black'
			width: size.width
			height: size.height
			strokeWidth: 2
			borderWidth: 1
			borderColor: 'rgba(0,0,0,.12)'
			stroke: 'secondary'
			fill: 'white'
			scrollVertical: false
			propagateEvents: true
			animationOptions:
				time: 1

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

		@numberLayer.templateFormatter = (value) ->
			return value.toFixed()

		# set HTML canvas for arc

		@canvasLayer = new Layer
			name: if @showLayers then "Canvas"
			parent: @
			size: @size
			backgroundColor: null

		@canvas = document.createElement("canvas")
		@canvas.setAttribute('width', @width + 'px')
		@canvas.setAttribute('height', @height + 'px')

		@canvasLayer._element.appendChild(@canvas)
		
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

		# set numberLayer's color when color changes
		@on "change:color", (string, color) =>
			@numberLayer.color = color

		# assign properties that required layers

		_.assign @,
			padding: size.padding
			value: options.value
			color: options.color

		switch options.type
			when "dashboard" then @_makeDashboardPages()


	showAmount: ->
		value = @value

		@value = 0
		@animate
			value: value

	setArc: ->
		return if @__constructor

		# clear canvas
		width = @width * @context.scale
		height = @height * @context.scale

		radius = ((width - (@padding * @context.scale) * 2) - (@strokeWidth * @context.scale)) / 2
		startAngle = -0.5
		endAngle = Utils.modulate(@value, [@min, @max], [-0.5, 1.5], true)
		
		ctx = @canvas.getContext('2d')

		ctx.clearRect(0, 0, width, height)

		# make path
		ctx.beginPath()

		ctx.arc(
			(width / 2),
			(width / 2),
			radius, 
			startAngle * Math.PI, 
			endAngle * Math.PI
			)

		# style stroke
		ctx.strokeStyle = @stroke
		ctx.lineWidth = @strokeWidth * @context.scale
		ctx.stroke()



	_makeDashboardPages: ->

		# - page 0

		firstPage = @newPage()

		@numberLayer.parent = firstPage
		@numberLayer.y -= 16

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


	newPage: (page) ->
		if not page?
			rand = _.random(9)

			page = new Layer
				name: if @showLayers then "Page #{@content.children.length}" else '.'
				size: @size
				backgroundColor: @backgroundColor

		@addPage(page, 'right')

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


	@define "color",
		get: -> return @_color
		set: (string) ->
			return if @__constructor

			color = Colors.validate(string)

			@_color = color ? Colors.black

			@emit "change:color", string, color

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

	@define "value",
		get: -> return @_value
		set: (value) ->
			return if @__constructor
			@_value = value

			@setArc()

			@numberLayer.visible = value?
			if value? then @numberLayer.template = value

			@emit "change:value", value, @