require 'framework'

# Setup
{ theme } = require 'components/Theme' # not usually needed

Canvas.backgroundColor = bg3
Framer.Extras.Hints.disable()

# dumb thing that blocks events in the upper left-hand corner
dumbthing = document.getElementById("FramerContextRoot-TouchEmulator")?.childNodes[0]
dumbthing?.style.width = "0px"

brightGreen = "#7ed321"

# Switch Header

class SwitchHeader extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: 'Header'
			y: app.header?.height
			height: 64
			backgroundColor: 'rgba(255,255,255,.8)'
			backgroundBlur: 10
			shadowSpread: 1
			shadowColor: 'rgba(0,0,0,.16)'
			clip: true
			animationOptions:
				time: .25
		
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

		Utils.define @, 'showing', true, @showHeader

	showHeader: (bool) =>
		if bool
			@animate
				y: app.header?.height ? 0
			return		
		
		@animate
			y: (app.header?.height ? 0) - @height

	setPosition: (event) =>
		return if not HIDE_HEADER
		

		if @showing is true and event.offset.x > 10
			@showing = false
		
# 		if @showing is false and event.offset.x < -10
# 			@showing = true
			
	setPositions: (scrollY) ->
		startY = homeView.content.children[0].height - 64
		
# 		if FIXED_HEADER and HIDE_HEADER
# 			@y = Utils.modulate(
# 				scrollY,
# 				[startY, startY + 64],
# 				[app.header.height, 0],
# 				true
# 				)
		
		return if scrollY > startY+64 and
		@logoMark.midY is  @height/2 - @height or HIDE_HEADER
		
		@logoMark.midY = Utils.modulate(
			scrollY, 
			[startY, startY+64], 
			[@height/2, @height/2 - @height], 
			true
			)
		@signUp.midY = Utils.modulate(
			scrollY, 
			[startY, startY+64], 
			[@height/2 + @height, @height/2], 
			true
			)
		@logoMark.opacity = Utils.modulate(
			scrollY, 
			[startY, startY+64], 
			[1, 0], 
			true
			)
		@signUp.opacity = Utils.modulate(
			scrollY, 
			[startY, startY+64], 
			[0, 1], 
			true
			)

# Section Card

class SectionCard extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			width: Screen.width - 60
			height: (Screen.width - 60) * 1.414
			borderRadius: 4
			backgroundColor: white
			shadowY: 1
			shadowBlur: 4
			shadowColor: 'rgba(0,0,0,.16)'
			clip: true
			
			section: 'Learn'
			title: 'Your money, sorted.'
			body: "Finances can be confusing. Here you can find clear information, so you can take control and feel good about your money."
		
		super options
		
		@imageLayer = new Layer
			parent: @
			height: @height * .45
			width: @width
			image: Utils.randomImage()
		
		@sectionLabel = new Label
			parent: @
			x: 30
			y: @imageLayer.maxY + 15
			width: @width - 60
			textTransform: 'uppercase'
			color: grey70
			letterSpacing: 1.5
			fontWeight: 300
			text: options.section
		
		@titleLayer = new Body1 
			parent: @
			y: @sectionLabel.maxY + 10
			x: 30
			width: @width - 60
			text: options.title
		
		@bodyLayer = new Body2
			parent: @
			y: @titleLayer.maxY + 15
			x: 30
			width: @width - 60
			text: options.body
			lineHeight: 1.6

# Donut

class Donut extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: 'Donut'
			min: 0
			max: 700
			score: 420
			height: 240
			width: 240
			color: green
			backgroundColor: 'rgba(255,255,255,.1)'
			borderRadius: 999
			borderWidth: 1
			borderColor: 'rgba(255,255,255,.2)'
			backgroundBlur: 30
		
		super options
		
		@color = grey
		
		# title 
		
		@titleLayer = new Body2
			parent: @
			text: 'Your credit score is'
			color: white
			x: Align.center
			y: @height * .24
		
		# number 
		
		@numberLayer = new H2
			parent: @
			x: Align.center()
			y: @height * .36
			text: "{score}"
			width: @width
			textAlign: 'center'
			fontWeight: 200
		
# 		Utils.pinOrigin @numberLayer, @
		
		# out of...
		
		@outOfLayer = new Body2
			parent: @
			text: 'out of 700'
			color: white
			x: Align.center
			y: @height * .58
		
		# meaning
		
		@outOfLayer = new Body2
			parent: @
			text: 'out of 700'
			color: white
			x: Align.center
			y: @height * .72
			text: 'On good ground'
			color: options.color
		
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
				r: (@width/2) - 8
				transform: "rotate(-90 #{@width/2} #{@width/2})"
		
		@on "change:color", => 
			@svgCircle.stroke = @color
			@numberLayer.color = @color
		
		@color = options.color
		
		
	_setValue: (value) ->
		return if not @score
		
		_.clamp(value, @min, @max)
		
		@numberLayer.template = value.toFixed(0)
		
		r = (@width/2) - 8
		c = Math.PI*(r*2)
		
		range = @max - @min
		pct = ((range-value)/range)*c;
		
		Utils.setAttributes @svgCircleElement,
			'stroke-dasharray': "#{Math.PI*(r*2)} #{Math.PI*(r*2)}" 
			'stroke-dashoffset': "#{pct}"


# ----------------
# App

app = new App
	chrome: if Utils.isSafari() then null else 'safari'

# ----------------
# Components

pages = {}
animations = {}
cardsPage = undefined
footerPage = undefined

FIXED_HEADER = true
HIDE_HEADER = true
MODULATE_ANIMATIONS = true


# Content Page

class ContentPage extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			height: homeView.height
			width: homeView.width 
			backgroundColor: white
# 			hueRotate: 45 * _.random(100)
		
		super options
		
		if pages[@name]?
			throw 'Each page should have its own name.'
		
		pages[@name] = @

# Content Animation

class ContentAnimation extends Layer
	constructor: (options = {}) ->
		
		@handler = homeView
		
		_.defaults options,
			name: 'Content Animation'
			height: homeView.height * .618
			width: homeView.width
			clip: true
			modulate: false
		
		super options
		
		_.assign @,
			modulate: options.modulate
		
		if animations[@name]?
			throw 'Each page should have its own name.'
		
		animations[@name] = @
		
		Utils.define @, "animState", 'default'
		
		@handler.content.on "change:y", =>
			@setFactor(@handler.scrollY)
	
	# private
	
	_showPlaying: =>
		try @load()
	
	_showReversing: =>
		try @reverse()
		
	# public
	
	setFactor: (scrollY) ->
		return if @modulate

		if @animState is "default"
			if @y + 128 > scrollY >= @y - 128 
				@animState = 'playing'
				Utils.delay 2, =>
					@animState = "played"
				try @load()
			return
			
		if @animState is "played"
			if @y - 128  > scrollY < @y + 128
				@animState = 'playing'
				Utils.delay 2, =>
					@animState = "default"
				try @reverse()
			return

# Page Header

pageHeader = undefined

Utils.bind app.header, ->
	@title = 'www.clearscore.com'


# ----------------
# App

# Home View

homeView = new View
	title: 'Framework'
	padding: null

Utils.bind homeView, ->
	
	if FIXED_HEADER
		@pageHeader = new SwitchHeader
			parent: @
			width: @width
			y: app.header?.height
			
		@content.onSwipeDownEnd (event) =>
			return if Math.abs(event.offset.y) < 32
			@pageHeader.showing = true
			
		@content.onSwipeUpEnd (event) =>
			return if @scrollY < 64 or Math.abs(event.offset.y) < 32
			@pageHeader.showing = false
			
		@content.on "change:y", =>
			@pageHeader.setPositions(@scrollY)
			
			if MODULATE_ANIMATIONS
				
				for name, anim of animations
					continue if not anim.modulateFactor?
					
					factor = Utils.modulate(
						@scrollY,
						[anim.y - 300, anim.y]
						[0, 1],
						true
					)
					
					anim.modulateFactor(factor)
	
Utils.bind homeView.content, ->
	
	if not FIXED_HEADER
		@pageHeader = new SwitchHeader
			parent: @
			width: @width
			y: 0
	
	@backgroundColor = null
		
	content = new ContentPage
		parent: @
		name: 'Landing'
			
	for pageName in [
			'Intro',
			'Learning',
			'Offers', 
			'Report',
			'Security', 
		]
		
		animation = new ContentAnimation
			parent: @
			name: pageName + 'Anim'
	
		content = new ContentPage
			parent: @
			name: pageName
		
	cardsPage = new ContentPage
		name: 'Cards'
		parent: @
		
	footerPage = new ContentPage
		name: 'Footer'
		parent: @
		
	# support
	
	# footer
		
	# events 
	
	
homeView.updateContent()


# Landing Page

Utils.bind pages.Landing, ->
	mainCopy = new H3
		parent: @
		x: Align.center()
		y: 30
		width: @width - 64
		text: 'Your credit score and report. For free, forever.'
		fontWeight: 300
		
	mainCTA = new Button
		parent: @
		x: Align.center()
		y: mainCopy.maxY + 24
		width: @width - 64
		borderRadius: 999
		height: 40
		text: 'See your score'
		
	secondaryCTA = new Button
		parent: @
		x: Align.center()
		y: mainCTA.maxY + 12
		width: @width - 64
		borderRadius: 999
		height: 40
# 		dark: true
		secondary: true
		text: 'Find out more'
		select: -> 
			
			homeView.pageHeader?.showing = false
			
			if not MODULATE_ANIMATIONS then animations.IntroAnim.load()
			
			homeView.scrollToPoint(
				x: 0, y: animations.IntroAnim.y,
				true,
				curve: Spring(
					tension: 269.69
					friction: 35.61
					velocity: 0.00
					tolerance: 0.01
					)
				)
		
	mainCTA.borderRadius = 999
	secondaryCTA.borderRadius = 999


# Intro Page

Utils.bind pages.Intro, ->
	
	mainCopy = new H3
		parent: @
		x: Align.center()
		y: 40
		width: @width - 64
		fontSize: 28
		text: 'We make finance simple'
		fontWeight: 300
		
	leadCopy = new Body1
		parent: @
		x: 30
		y: mainCopy.maxY + 30
		width: @width - 60
		text: 'Your credit score is a overall rating of your financial history. The better your credit score, the more likely you are to get the best deals and interest rates. Get your free credit score every month and check it as often as you like!'
		
	mainCTA = new Button
		parent: @
		x: Align.center()
		y: leadCopy.maxY + 30
		width: @width - 64
		borderRadius: 999
		text: 'See your score'
		
	secondaryCTA = new Button
		parent: @
		x: Align.center()
		y: mainCTA.maxY + 15
		width: @width - 64
		borderRadius: 999
		secondary: true
		text: 'Watch Video'
	
	@height = secondaryCTA.maxY + 40

# Intro Animation

Utils.bind animations.IntroAnim, ->
	@modulate = true
	
	@imageLayer = new Layer
		parent: @
		size: @size
		image: 'images/background.jpg'
	
	@donut = new Donut
		parent: @
		point: Align.center()
		color: brightGreen
		score: 294
		scale: .6
		
	@deviceMask = new Layer
		parent: @
		height: @width * 919/725
		width: @width
		image: 'images/device_mask_fill.png'
	
	@modulateFactor = (factor) =>
		@imageLayer.scale = Utils.modulate(factor, [0, 1], [1, 1.1], true)
		@donut.score = Utils.modulate(factor, [0, 1], [412, 512], true)
		@donut.scale = Utils.modulate(factor, [0, 1], [0.6, 1], true)
		@deviceMask.scale = Utils.modulate(factor, [0, 1], [1, 2.3], true)
	
	
	@load = =>
	
		@imageLayer.animate
			scale: 1.1
	
		@donut.animate
			score: 512
			scale: 1
			
		@deviceMask.animate
			scale: 2.3
			
	@reverse = =>
	
		@imageLayer.animate
			scale: 1
				
		@donut.animate
			score: 412
			scale: .6
			options:
				curve: Spring(
					tension: 196.37
					friction: 45.56
					velocity: 0.00
					tolerance: 0.01
				)
			
		@deviceMask.animate
			scale: 1


# Learning Page

Utils.bind pages.Learning, ->
	
	mainCopy = new H3
		parent: @
		x: Align.center()
		y: 40
		width: @width - 64
		fontSize: 28
		text: 'Building your score'
		fontWeight: 300
		
	leadCopy = new Body1
		parent: @
		x: 30
		y: mainCopy.maxY + 30
		width: @width - 60
		text: 'If your new to credit you may have a low or no score. This can prevent you from being accepted for financial services. We’ll show you how to build your score to help you meet your financial goals.'
		
	mainCTA = new Button
		parent: @
		x: Align.center()
		y: leadCopy.maxY + 30
		width: @width - 64
		borderRadius: 999
		text: 'See your score'
		
	@height = mainCTA.maxY + 72
		
# 	secondaryCTA = new Button
# 		parent: @
# 		x: Align.center()
# 		y: mainCTA.maxY + 15
# 		width: @width - 64
# 		borderRadius: 999
# 		secondary: true
# 		text: 'Watch Video'
# 	
# 	@height = secondaryCTA.maxY + 40

# Learning Animation

Utils.bind animations.LearningAnim, ->
	
	@backgroundColor = '#e7eff5'
	
	@device = new Layer
		parent: @
		y: 30
		height: @height - 40
		width: (@height - 40) * 211/423
		x: Align.center()
		image: 'images/learn.png'
	
	whiteBar = new Layer
		parent: @
		width: @width
		height: 64
		backgroundColor: white
		y: Align.bottom()
		
	whiteBar.sendToBack()
		
	@load = =>


# Offers Page

Utils.bind pages.Offers, ->
	
	mainCopy = new H3
		parent: @
		x: Align.center()
		y: 40
		width: @width - 64
		fontSize: 28
		text: 'Get the best offers'
		fontWeight: 300
		
	leadCopy = new Body1
		parent: @
		x: 30
		y: mainCopy.maxY + 30
		width: @width - 60
		text: 'Having a good credit score means your more likely to get better deals and interest rates on mortgages, loans, credit cards and car insurance. We’ll show you the best deals for you and how likely you’ll be accepted.'
		
	mainCTA = new Button
		parent: @
		x: Align.center()
		y: leadCopy.maxY + 30
		width: @width - 64
		borderRadius: 999
		text: 'See your score'
		
	@height = mainCTA.maxY + 72
		
		
# 	secondaryCTA = new Button
# 		parent: @
# 		x: Align.center()
# 		y: mainCTA.maxY + 15
# 		width: @width - 64
# 		borderRadius: 999
# 		secondary: true
# 		text: 'Find out more'
# 	
# 	@height = secondaryCTA.maxY + 40

# Offers Animation

Utils.bind animations.OffersAnim, ->
	
	@backgroundColor = '#e7eff5'
	
	@device = new Layer
		parent: @
		y: 30
		height: @height - 40
		width: (@height - 40) * 211/423
		x: Align.center()
		image: 'images/offers.png'
	
	whiteBar = new Layer
		parent: @
		width: @width
		height: 64
		backgroundColor: white
		y: Align.bottom()
		
	whiteBar.sendToBack()
		
	@load = =>


# Report Page

Utils.bind pages.Report, ->
	
	mainCopy = new H3
		parent: @
		x: Align.center()
		y: 40
		width: @width - 64
		fontSize: 28
		text: 'Your full credit report. Every month.'
		fontWeight: 300
		
	leadCopy = new Body1
		parent: @
		x: 30
		y: mainCopy.maxY + 30
		width: @width - 60
		text: 'Keep track of your financial history with our free monthly credit reports. Credit reports are a great way to see any outstanding issues in your credit and keep track of spending.'
		
	mainCTA = new Button
		parent: @
		x: Align.center()
		y: leadCopy.maxY + 30
		width: @width - 64
		borderRadius: 999
		text: 'See your score'
		
	@height = mainCTA.maxY + 72
		
		
# 	secondaryCTA = new Button
# 		parent: @
# 		x: Align.center()
# 		y: mainCTA.maxY + 15
# 		width: @width - 64
# 		borderRadius: 999
# 		secondary: true
# 		text: 'Find out more'
# 	
# 	@height = secondaryCTA.maxY + 40

# Report Animation

Utils.bind animations.ReportAnim, ->
	
	@backgroundColor = '#e7eff5'
	
	@device = new Layer
		parent: @
		y: 30
		height: @height - 40
		width: (@height - 40) * 211/423
		x: Align.center()
		image: 'images/report.png'
	
	whiteBar = new Layer
		parent: @
		width: @width
		height: 64
		backgroundColor: white
		y: Align.bottom()
		
	whiteBar.sendToBack()
		
	@load = =>



# Security Page

Utils.bind pages.Security, ->
	
	mainCopy = new H3
		parent: @
		x: Align.center()
		y: 40
		width: @width - 64
		fontSize: 28
		text: 'You’re in safe hands'
		fontWeight: 300
		
	leadCopy = new Body1
		parent: @
		x: 30
		y: mainCopy.maxY + 30
		width: @width - 60
		text: 'Your financial data is important. We use the latest in 256-bit encryption to ensure your information stays secure. We will never sell your data, we won’t send nuisance emails and checking your score is risk free.'
		
	mainCTA = new Button
		parent: @
		x: Align.center()
		y: leadCopy.maxY + 30
		width: @width - 64
		borderRadius: 999
		text: 'See your score'
		
	@height = mainCTA.maxY + 72
		
		
# 	secondaryCTA = new Button
# 		parent: @
# 		x: Align.center()
# 		y: mainCTA.maxY + 15
# 		width: @width - 64
# 		borderRadius: 999
# 		secondary: true
# 		text: 'Find out more'
# 	
# 	@height = secondaryCTA.maxY + 40

# Security Animation

Utils.bind animations.SecurityAnim, ->
	
	@modulate = true
	
	@imageLayer = new Layer
		parent: @
		size: 999
		point: Align.center()
		scale: 2
		gradient:
			start: '#284986'
			end: '#31437a'
			
	icon = new Icon
		parent: @imageLayer
		icon: 'lock'
		color: white
		size: 72
	
	Utils.pinOrigin icon, @imageLayer
			
	@deviceMask = new Layer
		parent: @
		height: @width * 919/725 - 64
		width: @width
		image: 'images/device_mask_fill.png'
		scale: 2.3
	
	@modulateFactor = (factor) =>
		@imageLayer.scale = Utils.modulate(factor, [0, 1], [1, .6], true)
		@deviceMask.scale = Utils.modulate(factor, [0, 1], [2.3, 1], true)
		
	@load = =>
	
		@imageLayer.animate
			scale: .6
	
		@deviceMask.animate
			scale: 1
			
	@reverse = =>
	
		@imageLayer.animate
			scale: 1
	
		@deviceMask.animate
			scale: 2.3


# Cards Page

Utils.build cardsPage, ->
	mainCopy = new H3
		parent: @
		x: Align.center()
		y: 40
		width: @width - 64
		fontSize: 28
		text: 'We make ClearScore'
		fontWeight: 300
		
	leadCopy = new Body1
		parent: @
		x: 30
		y: mainCopy.maxY + 30
		width: @width - 60
		text: 'See how ClearScore can help you meet your financial goals, Whether that’s fixing an issue on your CreditScore or saving money on financial services.'


	# Cards
	
	@sectionScroll = new ScrollComponent
		parent: @
		y: leadCopy.maxY + 30
		width: @width
		height: (@width - 60) * 1.414
		clip: false
		scrollVertical: false
# 		propagateEvents: false
	
	@sectionScroll.content.clip = false
	
	learnCard = new SectionCard
		parent: @sectionScroll.content
		x: 15
		
	
	aboutCard = new SectionCard
		parent: @sectionScroll.content
		section: 'About'
		title: 'Our vision'
		body: "ClearScore's vision is to help everyone, no matter what their circumstances, achieve greater financial wellbeing. We've started this journey by giving everybody access to their credit score and report for free, forever."
		x: learnCard.maxX + 15
		
	
	careersCard = new SectionCard
		parent: @sectionScroll.content
		section: 'Careers'
		title: 'At ClearScore, free credit scores are just the beginning'
		body: "We're looking for high potential, talented people to help us scale ClearScore and fulfil the incredible opportunity we have on our hands."
		x: aboutCard.maxX + 15 
# 		
# 	@sectionScroll.content.draggable.onDrag (event) =>
# 		if Math.abs(event.offset.x) > 20
# 			homeView.scrollVertical = false
# 		else
# 			homeView.scrollVertical = true

# Footer

Utils.bind footerPage, ->
	
	@backgroundColor = "#f5f3f3"
		
	@icon = new Icon
		icon: 'star'
		parent: @
		y: 96
		x: Align.center()
		color: grey
		size: 48
		
	
	@mainCopy = new H3
		parent: @
		x: Align.center
		y: 224
		fontSize: 32
		fontWeight: 300
		color: yellow80
		textAlign: 'center'
		text: 'Talk to us \n\nSupport'
		
	@icons = _.map ['facebook', 'twitter', 'google', 'linkedin'], (iconName) =>
		new Icon
			parent: @
			icon: iconName
			color: grey80
			y: @mainCopy.maxY + 100
	
	Utils.distribute @icons, 'midX', 100, @width - 100
	
	addressInfo = new Micro
		parent: @
		y: @mainCopy.maxY + 160
		x: 30
		width: @width - 60
		color: black
		textAlign: 'center'
		text: "47 Durham Street, London, SE11 5JA, UK
\nRegistered in England (Company number 09221862), 
\nAuthorised and Regulated by the \nFinancial Conduct Authority. (FRN: 654446)\n© Clear Score Technology Ltd. All Rights Reserved."
	
	

# Set Positions

for pageName, page of pages
	anim = animations[pageName + 'Anim']
	
	header = homeView.pageHeader ? homeView.content.pageHeader
	header?.bringToFront()
	
	_.assign page,
		y: (last?.maxY ? header.height)
		height: _.maxBy(page.children, 'maxY')?.maxY + 32
		
	
	if anim?
		anim.y = (last?.maxY ? 0)
		page.y = anim.maxY
		
	last = page
	
	
homeView.updateContent()

app.showNext homeView

# Utils.delay 5, ->
# 	homeView.scrollToPoint
# 		x: 0, y: 99999
# 		true,
# 		time: 30
# 		curve: 'linear'

# homeView.scrollToLayer footerPage

# Canvas.backgroundColor = '#000'
	