require 'cs-ux'
require 'gotcha'

{ theme } = require 'components/Theme' # not usually needed

# Setup

Canvas.backgroundColor = grey80
Framer.Extras.Hints.disable()

# -----------------
# Data

# User

user =
	name: 'Clarice Scorinson'
	age: 28
	sex: Utils.randomChoice(['female', 'male', 'nonbinary'])
	birthday: new Date()

# -----------------
# Implementation

app = new App
	title: 'www.clearscore.com'
	safari: true

pages = []

# Switch Header

class SwitchHeader extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: 'Header'
			y: app.header.height
			height: 64
			backgroundColor: white
			clip: true
		
		super options
		
		# Header
	
		@burger = new Icon 
			name: 'icon'
			icon: 'menu'
			parent: @
			x: 32
			y: Align.center()
			color: black
			
		@logoMark = new Layer 
			name: 'logomark'
			parent: @
			x: Align.center()
			y: Align.center()
			height: 15
			width: 116
			color: black
			image: 'images/clearscore_logomark.png'
		
		@signIn = new Label
			name: 'sign in'
			parent: @
			x: Align.right(-32)
			y: Align.center()
			text: 'Log in'
		
		for child in @children
			Utils.pinOriginY child, @
			
# 		@clearScoreLogo = new Icon
# 			parent: @
# 			x: Align.center(-52)
# 			y: Align.center(3)
# 			icon: 'clearscore-logo'
			
		@signUp = new Label
			parent: @
			x: Align.right(-48 + -@signIn.width + -16)
			y: @height / 2 + 64
			text: 'Sign Up'
			
# 		@signUp = new Button
# 			parent: @
# 			x: Align.center()
# 			y: @height / 2 + 64
# 			borderRadius: 999
# 			width: 180
# 			text: 'Get Started'
			
	setPositions: (scrollY) ->
		startY = homeView.pager.content.children[0].height - 64
		@logoMark.midY = Utils.modulate(scrollY, [startY, startY+64], [@height/2, @height/2 - @height], true)
		@signUp.midY = Utils.modulate(scrollY, [startY, startY+64], [@height/2 + @height, @height/2], true)
		@logoMark.opacity = Utils.modulate(scrollY, [startY, startY+64], [1, 0], true)
		@signUp.opacity = Utils.modulate(scrollY, [startY, startY+64], [0, 1], true)

# Home View

homeView = new View
background = undefined

Utils.bind homeView, ->
	
	@header = new SwitchHeader
		parent: @
		width: @width
	
	# Pager
	
	background = new Layer
		parent: @
		name: 'background image'
		height: @height - @header.maxY - (app.footer?.height ? 0)
		width: (@height - @header.maxY - (app.footer?.height ? 0)) * 2000/1302
		x: Align.center()
		y: @height / 2
		image: 'images/background.jpg'
		originY: 0
		scale: 1.1
		animationOptions:
			time: .5
		
	background.states.full =
		y: 110
	
	@pager = new PageComponent
		name: 'Transition Component'
		parent: @
		y: @header.maxY
		width: @width
		height: @height - @header.maxY - (app.footer?.height ? 0)
		scrollHorizontal: false
		originY: 0
# 		backgroundColor: 'red'
	
	@header.bringToFront()
	
	@pager.content.on "change:y", =>
		@header.setPositions(@pager.scrollY)
	
	@pager.on "change:currentPage", (next, prev) =>
		
		try next.load()
		
# 		if @pager.currentPage is landingPage
# 			@header.animate
# 				height: 80
# 			return
# 			
# 		@header.animate
# 			height: 64

# make pages
	
landingPage = new Layer
	parent: homeView.pager.content
	width: Screen.width
	height: homeView.pager.height / 2
	backgroundColor: white

for i in _.range(6)
	pages[i] = new Layer
		name: 'Page ' + i
		parent: homeView.pager.content
		y: last ? landingPage.maxY
		height: homeView.pager.height + 30
		width: homeView.pager.width 
		backgroundColor: blue
		hueRotate: 180 * i
	
	last = pages[i].maxY

# Donut

class Donut extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: 'Donut'
			min: 0
			max: 700
			score: 420
			color: secondary
			backgroundColor: null
		
		super options
		
		@color = grey
		
		# number 
		
		@numberLayer = new H2
			parent: @
			point: Align.center()
			text: "{score}"
			width: @width
			textAlign: 'center'
			fontWeight: 200
		
		Utils.pinOrigin @numberLayer, @
		
		# svg circle
		
		@svgCircle = new SVGLayer
			name: 'Circle'
			parent: @
			size: @size
			svg: "<svg><circle id='svg_circle' stroke-linecap='round' " +
				" transform='rotate(-90 #{@width/2} #{@width/2})' " +
				" cx='#{@width/2}' cy='#{@width/2}' " + 
				" r='#{(@width/2) - 3}'/></g>"
			fill: 'rgba(0,0,0,0)'
			strokeWidth: 3
			stroke: black
		
		@svgCircleElement = document.getElementById('svg_circle')
		
		# definitions
		
		Utils.defineValid @, "min", options.min, _.isNumber, 'Donut.min must be a number.', @_setValue
		Utils.defineValid @, "max", options.max, _.isNumber, 'Donut.max must be a number.', @_setValue
		Utils.defineValid @, "score", options.score, _.isNumber, 'Donut.value must be a number.', @_setValue
		
		# Events
		
		@on "change:size", =>
			@svgCircle.size = @size
			
			_.assign @numberLayer,
				width: @width
			
			Utils.setAttributes @svgCircleElement,
				cx: @width/2
				cy: @width/2
				r: (@width/2) - 3
				transform: "rotate(-90 #{@width/2} #{@width/2})"
		
		@on "change:color", => 
			@svgCircle.stroke = @color
			@numberLayer.color = @color
		
		@color = options.color
		
		
	_setValue: (value) ->
		return if not @score
		
		_.clamp(value, @min, @max)
		
		@numberLayer.template = value.toFixed(0)
		
		r = (@width/2) - 3
		c = Math.PI*(r*2)
		
		range = @max - @min
		pct = ((range-value)/range)*c;
		
		Utils.setAttributes @svgCircleElement,
			'stroke-dasharray': "#{Math.PI*(r*2)} #{Math.PI*(r*2)}" 
			'stroke-dashoffset': "#{pct}"

# Landing Page


Utils.bind landingPage, ->
	
	@load = ->
		pages[0].deviceMask.animate "default"
# 		pages[0].background.animate 'default'
		background.animate 'default'
		pages[0].donut.animate 'default'
		
		pages[0].donut.animate { score: 321 }
		
	
	mainCopy = new H3
		parent: @
		x: Align.center()
		y: 20
		width: @width - 64
		text: 'Your credit score and report. For free, forever.'
		fontWeight: 300
		
	mainCTA = new Button
		parent: @
		x: Align.center()
		y: mainCopy.maxY + 24
		width: @width - 64
		borderRadius: 999
		text: 'See your score'
		
	secondaryCTA = new Button
		parent: @
		x: Align.center()
		y: mainCTA.maxY + 12
		width: @width - 64
		borderRadius: 999
		secondary: true
		text: 'See your score'
		
	@height = secondaryCTA.maxY + 32


# Page 0

Utils.bind pages[0], ->
	_.assign @,
		clip: true
		backgroundColor: null
		load: ->
			@deviceMask.animate 'full'
			background.animate 'full'
			@donut.animate 'full'
	
	@unload = ->
		null
	
	
	@deviceMask = new Layer
		parent: @
		name: 'device mask'
		height: @height
		width: @height * 725/919
		image: 'images/device_mask_fill.png'
		
	@donut = new Donut
		parent: @
		x: Align.center()
		y: Align.center(-20)
		size: @width * .4
		originY: .35
		score: 321
		
	Utils.pinOrigin @donut, @
	
	# states
	
	@donut.states.full =
		size: @width * .6
		x: @width * .2
		score: 512
		
	@deviceMask.states.full = 
		x: (@width - (@deviceMask.width * 2.1)) / 2 - 32
		y: (@height - (@deviceMask.height * 2.1)) / 2
		width: @deviceMask.width * 2.3
		height: @deviceMask.height * 2.3
	
# 368 (center of device)
# 311 (center)
# 57 px offset


# Page 1

Utils.bind pages[1], -> 
	@backgroundColor = bg1
	
	@load = -> null
	
	@header = new H3
		parent: @
		x: Align.center()
		y: 32
		width: @width - 64
		text: 'We make finance simple.'
		fontWeight: 300
		fontSize: 24
	
	mainCopy = new H4
		parent: @
		x: Align.center()
		y: @header.maxY + 32
		width: @width - 64
		fontWeight: 300
		text: 'Your credit score is a overall rating of your financial history. The better your credit score, the more likely you are to get the best deals and interest rates. Get your free credit score every month and check it as often as you like!'
		
	mainCTA = new Button
		parent: @
		x: Align.center()
		y: mainCopy.maxY + 24
		width: @width - 64
		borderRadius: 999
		
	@height = mainCTA.maxY + 32
		


# Page 2

Utils.bind pages[2], -> 
	@backgroundColor = null


# Page 3

Utils.bind pages[3], -> 
	@backgroundColor = bg1
	
	@load = -> null
	
	@header = new H3
		parent: @
		x: Align.center()
		y: 32
		width: @width - 64
		text: 'We make finance simple.'
		fontWeight: 300
		fontSize: 24
	
	mainCopy = new H4
		parent: @
		x: Align.center()
		y: @header.maxY + 32
		width: @width - 64
		fontWeight: 300
		text: 'Your credit score is a overall rating of your financial history. The better your credit score, the more likely you are to get the best deals and interest rates. Get your free credit score every month and check it as often as you like!'
		
	mainCTA = new Button
		parent: @
		x: Align.center()
		y: mainCopy.maxY + 24
		width: @width - 64
		borderRadius: 999
		
	@height = mainCTA.maxY + 32
		


# Page 4

Utils.bind pages[4], -> 
	null



landingPage.bringToFront()

app.showNext homeView
# homeView.pager.snapToPage(pages[1], false)
