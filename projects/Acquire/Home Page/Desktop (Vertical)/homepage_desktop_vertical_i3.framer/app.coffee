require 'framework'
require 'cs'

# Setup
{ theme } = require 'components/Theme' # not usually needed

Canvas.backgroundColor = bg3
Framer.Extras.Hints.disable()

# dumb thing that blocks events in the upper left-hand corner
dumbthing = document.getElementById("FramerContextRoot-TouchEmulator")?.childNodes[0]
dumbthing?.style.width = "0px"


# device
# Framer.Device.customize
# 	deviceImageWidth: 1920
# 	deviceImageHeight: 1080
# # 	deviceImageCompression: true
# 	screenWidth: 1920
# 	screenHeight: 1080
# 	devicePixelRatio: 1
# 	deviceType: "fullscreen"

Canvas.backgroundColor = "#000"

# ----------------
# Components

pages = []

# Page

class Page extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: "Page " + pages.length
			size: homeView.size
			parent: homeView.content
			backgroundColor: null
			description: "The monthly report"
			header: "Your full credit report. Every month."
			body: "Keep track of your financial history with our free monthly credit reports. Credit reports are a great way to see any outstanding issues in your credit and keep track of spending."
			cta: "See your report"
			background: "images/Background/Desktop.png"
			device: "images/Screens/Dashboard.png"
			fill: "#eef5f5"
			headerImg: "images/coaching-header.png"
			footer: "images/coaching-footer.png"
						
		super options
		
		pages.push(@)
		
		# BackgroundLayer
		
		_.assign @,
			description: options.description
		
		@backgroundMask = new Layer
			name: "Background Mask"
			parent: @
			width: Screen.width / 2
			height: Screen.height
			opacity: 1
			image: options.background
			backgroundColor: options.fill
			clip: true
		
		
		
		# Device
		
		h = Screen.height * .618
		w = h * 676/1354
		
		
		vw = 300
		
		@device = new Layer
			name: "Device #{@name}"
			parent: @backgroundMask
			height: h
			width: w-32
			point: Align.center()
			backgroundColor: grey
			borderRadius: 48
			shadowX: 12
			shadowY: 24
			shadowBlur: 40
			shadowColor: "rgba(0,0,0,.41)"
			
		@deviceImage = new Layer
			name: "Device Image"
			parent: @device
			size: @device.size
			borderRadius: 48
			image: options.device
			clip: true
			
		@deviceVideo = new VideoLayer
			name: "Device Video"
			parent: @deviceImage
			width: vw 
			height: vw * 1830/750
			video: options.video
			backgroundColor: null
			
		@deviceChromeHeader = new Layer
			name: "Device Layer"
			parent: @deviceImage
			y: 16
			width: vw 
			height: vw * 200/750
			image: options.headerImg
			
		@deviceChromeFooter = new Layer
			name: "Device Layer"
			parent: @deviceImage
			y: Align.bottom
			width: vw 
			height: vw * 166/750
			image: options.footer
			
		@deviceScreen = new Layer
			name: "Device Screen"
			parent: @device
			height: h
			width: w
			x: -20
			backgroundColor: null
			image: 'images/iPhoneX.png'
			
# 		@blocker = new SVGLayer
# 			parent: @
# 			name: "Blocker"
# 			x: Align.right()
# 			width: 1092
# 			height: Screen.height
# 			svg: "<svg><path d='M 43.5,-0.5 L 132.5,92.5 132.5,180.5 43.5,246.5 132.5,317.5 43.5,420.5 132.5,500.5 43.5,597.5 132.5,724.5 43.5,806.5 132.5,877.5 43.5,960.5 132.5,1032.5 43.5,1081.5 1090.5,1081.5 1090.5,-0.5 43.5,-0.5 Z M 43.5,-0.5'/>"
# 			fill: white
		
		# Content
		
		@container = new Layer
			name: "Content Container"
			parent: @
			backgroundColor: null
		
		Utils.bind @container, ->
			copy = new H1
				name: "Title"
				parent: @
				width: 353
				text: options.header
				
			copy = new Body
				name: "Body"
				parent: @
				y: copy.maxY + 16
				width: 353
				text: options.body
			
			@primaryCTA = new Button
				name: "CTA"
				parent: @
				y: copy.maxY + 24
				width: 200
				text: options.cta
				
			_.assign @,
				width: _.maxBy(@.children, 'maxX').maxX
				height: _.maxBy(@.children, 'maxY').maxY
				
			_.assign @,
				midX: Screen.width * .75
				y: Align.center()
		
		@nav = new Layer
			name: "Nav"
			parent: @
			width: 200
			height: 128
			backgroundColor: null
					
		Utils.bind @nav, ->
			@copy = new H4
				name: "Next page title"
				parent: @
				color: tumbleWeed
				text: NAV_LINKS[1]
				height: 64
				fontSize: 18
				width: 200
				textAlign: "center"
				x: Align.center()
				
			@chevron = new Icon
				name: "Chevron"
				parent: @
				color: tumbleWeed
				icon: "chevron-down"
				height: 32
				width: 32
				y: @copy.maxY
				x: Align.center()
				
			_.assign @,
				midX: Screen.width * .75
				y: Align.bottom()
				opacity: 0
				visible: false
		
		
		homeView.content.on "change:y", =>
			factor = Utils.modulate(
				Math.abs(@y - homeView.scrollY)
				[350, 500]
				[1, 0]
				)
			
			@deviceVideo.y = Utils.modulate(
				@y - homeView.scrollY,
				[200, -200]
				[0, -64]
				)
			
			@nav.opacity = factor
			
			if factor > .25
				@deviceVideo.player.play()
			
		@nav.on "change:opacity", (opacity) -> @visible = opacity isnt 0
		
			


# ----------------
# App

app = new App
	chrome: null

# Header

scale = 1
RUNWAY = Screen.height * 2
EMAIL_SUBMIT = false
MOUSE_SPEED_MULTIPLIER = .125

NAV_LINKS = [
	{text: "What we provide", page: -> pages[0]}
	{text: "About us", page: -> pages[5]}
	{text: "Talk to us", page: -> pages[6]}
]


SELECT_NAV_LINKS = [
	{text: "Credit score explained", page: -> pages[0]}
	{text: "Get the best offers", page: -> pages[3]}
	{text: "Your privacy", page: -> pages[5]}
]

COPY =
	intro:
		title: "We make finance simple"
		body: "ClearScore makes your finances clear, calm and easy to understand. You can check your credit score and report, keep an eye on your accounts and balances, and find the best credit products for you. All in one place, all for free."  
	learn:
		title: "Improve your score"
		body: "Find out what’s affecting your credit score and how to improve it. Learn how to repair a damaged credit report, save on your car insurance, buy a house and more."
	track:
		title: "Track your finances"
		body: "Monitor your credit score, debt levels and accounts. Get alerted whenever there’s been an important change to your report, reducing the risk of identity fraud."
	offers:
		title: "Get the best offers" 
		body: "Find the best credit offers in the market for your financial situation. Check your eligibility before you apply, without harming your credit score." 
	privacy:
		title: "You’re in safe hands"
		body: "We use the latest 256-bit encryption to protect your data, and we never sell your details to anyone. No bank account or credit card details are needed to sign up." 
	team:
		title: "We make ClearScore"
		body: "We were founded in 2015, are and have over 5 million users." 


# Home View

homeView = new View
	title: 'Framework'
	padding: null
# 	scrollVertical: false
	mouseWheelEnabled: true
	mouseWheelSpeedMultiplier: MOUSE_SPEED_MULTIPLIER
	padding: null
	contentInset: {bottom: 0}

homeView.content.draggable.enabled = false

	
Utils.bind homeView, ->
	
	@_initial = true
	
	@content.on "change:y", (y) =>
# 		@_lastY ?= 0
		
		if @scrollY <= 0
			header.opened = false
			return
		
# 		if @scrollY < RUNWAY - (Screen.height * 1.4) 
# 			header.opened = false
# 			return
			
		header.opened = true
		
		if @scrollY >= pages[6].y - 400
			header.selected = header.navButtons[0]
		else if @scrollY >= pages[5].y - 400
			header.selected = header.navButtons[1]
		else
			header.selected = header.navButtons[2]
# 		
# 		if @_lastY < y
# 			header.opened = true
# 		else if @_lastY > y
# 			header.opened = false
				
# 		@_lastY = y



# Transition Page

# Landing / We make finance simple

new Page
	size: homeView.size
	backgroundColor: null
	clip: true

Utils.bind pages[0], ->
	@container.destroy()
	
	@stopMe = false
		
	homeView.content.on "change:y", =>
		scrollY = homeView.scrollY
		return if scrollY > RUNWAY + 200
		
		if @stopMe is true
			if homeView.scrollY >= RUNWAY - @height
				homeView.content.animateStop()
				
				Utils.delay 1, =>
					@stopMe = false
					
				homeView.scrollY = RUNWAY - @height
		
		
		if scrollY < RUNWAY - @height
			@y = scrollY
			factor = Utils.modulate(homeView.scrollY, [0, (RUNWAY - @height)], [0, 1], true)
			@setFactor(factor)
			@container.ignoreEvents = false
			@container2.ignoreEvents = true
			return
		if RUNWAY - @height <= homeView.scrollY <= RUNWAY
			@container2.ignoreEvents = true
			@container.ignoreEvents = true
			@y = RUNWAY - @height
			stopMe = true
			return
		
		@container2.ignoreEvents = false
			
	
	# Background / Device
	
	@backgroundMask.image = "images/Backgrounds/Landing.png"
	
	@hands = new Layer
		parent: @backgroundMask
		width: 633.6
		height: 819.84
		parent: @
		image: "images/Devices/hands.png"
		x: @device.x - 84
		y: Align.bottom()
		originX: .42
		
	@device.destroy()
	
	@deviceScreenMask = new Layer
		parent: @backgroundMask
		y: 282
		x: 331
		width: 338
		height: 719
		clip: true
		
	@deviceScreenImage = new Layer
		parent: @deviceScreenMask
		width: 1920
		height: 2160
		point: Align.center()
		scale: .35
		image: "images/Backgrounds/Desktop.png"
		originY: .5
		
	@donut = new Donut
		parent: @backgroundMask
		x: Align.center 20
		y: Align.center 100
		originY: .75
		value: 304
	
	@clipper = new Layer
		parent: @
		width: Screen.width / 2
		height: Screen.height
		x: Align.right()
		backgroundColor: "#FFF"
	
# 	@blocker = new SVGLayer
# 		parent: @
# 		name: "Blocker"
# 		x: Align.right()
# 		width: 1092
# 		height: Screen.height
# 		svg: "<svg><path d='M 43.5,-0.5 L 132.5,92.5 132.5,180.5 43.5,246.5 132.5,317.5 43.5,420.5 132.5,500.5 43.5,597.5 132.5,724.5 43.5,806.5 132.5,877.5 43.5,960.5 132.5,1032.5 43.5,1081.5 1090.5,1081.5 1090.5,-0.5 43.5,-0.5 Z M 43.5,-0.5'/>"
# 		fill: white
	
	# Content
		
	@container = new Layer
		name: "Content Container"
		parent: homeView.content
		backgroundColor: null
	
	Utils.bind @container, ->
		copy = new H1
			name: "Title"
			parent: @
			width: 400
			text: "Your credit score and report. For free, forever."
		_.assign @,
			width: _.maxBy(@.children, 'maxX').maxX
			height: _.maxBy(@.children, 'maxY').maxY
			
		_.assign @,
			midX: Screen.width * .75
			y: Align.center()
			
		if EMAIL_SUBMIT
			@emailSubmit = new TextInput
				parent: @
				y: copy.maxY + 24
				width: 212
				placeholder: "Enter your email"
				
			@warnText = new Micro
				parent: @
				y: @emailSubmit.maxY + 4
				x: 24
				color: black
				text: "Please enter a valid email address"
				color: black30
				visible: false
			
			@primaryCTA = new Button
				parent: @
				x: @emailSubmit.maxX + 16
				y: @emailSubmit.y
				text: 'Get started'
				width: 143
				
			@emailSubmit.on "change:value", => @warnText.visible = false
			
			isValidEmail = (email) ->
				re = ///^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$///
				return email.toLowerCase().match(re)
			
			@primaryCTA.onSelect =>
				if not isValidEmail(@emailSubmit.value)
					@warnText.visible = true
				else
					@warnText.visible = false
					homeView.animate
						opacity: 0
						
					Utils.delay 3, => 
						@emailSubmit.value = ""
						homeView.animate
							opacity: 1
		
		else
		
			# No Email Submit
		
			@primaryCTA = new Button
				parent: @
				x: copy.x
				y: copy.maxY + 24
				width: 170
				text: "Get Started"
			
			@secondaryCTA = new Button
				parent: @
				x: @primaryCTA.maxX + 16
				y: copy.maxY + 24
				width: 170
				text: "Find out more"
				secondary: true
				select: => 
					homeView.scrollToPoint(
						x: 0, y: RUNWAY - Screen.height
						true
						time: 1.25, curve: "easeIn"
						)
		
	
		# Links
		
		linkIntro = new H4 
			parent: @
			text: "We're here to help..."
			y: _.last(@children).maxY + 58
		
		last = null
		SELECT_NAV_LINKS.forEach (link, i) =>
			linkLayer = new Body2Link
				parent: @
				y: last?.maxY ? (linkIntro.maxY + 15)
				text: link.text
				color: tumbleWeed
				select: =>
					@stopMe = false 
					if i is 0
						homeView.scrollToPoint(
							x: 0, y: RUNWAY - Screen.height
							true
							time: 1.25, curve: "easeIn"
							)
						return
					
					showPage(link.page())
					
			last = linkLayer
		
	_.assign @container, 
		width: _.maxBy(@container.children, 'maxX').maxX
		height: _.maxBy(@container.children, 'maxY').maxY
		midX: Screen.width * .75
		y: Align.center()
	
	# Content 2
	
	options =
		description: "About credit scores"
		header: COPY.intro.title
		body: COPY.intro.body
		cta: "Get Started"
		photo: "images/Screens/Dashboard2.png"
		background: "images/Backgrounds/Desktop.png"
		
	@container2 = new Layer
		name: "Content Container"
		parent: homeView.content
		backgroundColor: null
		opacity: 0
	
	Utils.bind @container2, ->
		copy = new H1
			name: "Title"
			parent: @
			width: 353
			text: options.header
			
		copy = new Body
			name: "Body"
			parent: @
			y: copy.maxY + 16
			width: 353
			text: options.body
		
		@primaryCTA = new Button
			name: "CTA"
			parent: @
			y: copy.maxY + 24
			width: 200
			text: options.cta
	
	_.assign @container2, 
		width: _.maxBy(@container2.children, 'maxX').maxX
		height: _.maxBy(@container2.children, 'maxY').maxY
		midX: Screen.width * .75
		y: Align.center(Screen.height)
	
	# navigation
	
	
	@nav = new Layer
		parent: @
		width: 200
		height: 128
		backgroundColor: null
		opacity: 0
				
	Utils.bind @nav, ->
		copy = new H4
			parent: @
			color: tumbleWeed
			text: "Improve your score"
			height: 64
			fontSize: 18
			width: 200
			textAlign: "center"
			x: Align.center()
			
		@chevron = new Icon
			parent: @
			color: tumbleWeed
			icon: "chevron-down"
			height: 32
			width: 32
			y: copy.maxY
			x: Align.center()
			
		_.assign @,
			midX: Screen.width * .75
			y: Align.bottom()
	
		@onTap -> 
			pages[0].stopMe = false
			homeView.scrollToPoint(
				x: 0, y: RUNWAY
				true
				time: .45
				)
	
	# functions
	
	starts =
		deviceScreenFrame: @deviceScreenMask.frame
		deviceScreenFrameMidX: @deviceScreenMask.midX
		deviceScreenFrameMidY: @deviceScreenMask.midY
		donutSize: @donut.height
		donutValue: @donut.value
		
	turnPoint = .92
		
	@setFactor = (factor) =>
		@deviceScreenImage.scale = Utils.modulate(
			factor, [0, turnPoint], 
			[.35, .8], 
			true)
		
		@deviceScreenMask.width = Utils.modulate(
			factor, [0, turnPoint], 
			[starts.deviceScreenFrame.width, 
			Screen.width * .55]
			, true)
			
		@deviceScreenMask.height = Utils.modulate(
			factor, [0, turnPoint], 
			[starts.deviceScreenFrame.height, 
			Screen.height * (starts.deviceScreenFrame.height/starts.deviceScreenFrame.width)]
			, true)
			
		@hands.scale = Utils.modulate(
			factor, [0, turnPoint], 
			[1, 3], 
			true)
		
		@donut.scale = Utils.modulate(
			factor, [0, turnPoint], 
			[1, 2],
			true)
		
		@donut.value = Utils.modulate(
			factor, [0, turnPoint], 
			[starts.donutValue, 512],
			true)
				
		@container.opacity = Utils.modulate(
			factor, [.35, .45], 
			[1, 0],
			true)
			
		@container2.opacity = Utils.modulate(
			factor, 
			[.45, .6], 
			[0, 1],
			true)
			
		@nav.opacity = Utils.modulate(
			factor, 
			[.55, .65], 
			[0, 1],
			true)
	
			
		@deviceScreenImage.point = Align.center()
		@deviceScreenMask.midX = starts.deviceScreenFrameMidX
		@deviceScreenMask.midY = starts.deviceScreenFrameMidY

	
	@container.on "change:opacity", -> @visible = @opacity isnt 0
	@container2.on "change:opacity", -> @visible = @opacity isnt 0
	@nav.on "change:opacity", -> @visible = @opacity isnt 0

# fixed nav buttons

# Utils.bind homeView, ->
# 	@navButtons = NAV_LINKS.map (link, i) =>
# 		linkButton = new Body2Link
# 			parent: @content
# 			y: 52
# 			x: Align.right()
# 			color: black
# 			opacity: 1
# 			text: link.text
# 			select: => 
# 				@selected = linkButton
# 				showPage(link.page())
# 		
# 		linkButton.underline = new Layer
# 			parent: @content
# 			y: linkButton.maxY
# 			backgroundColor: '#000'
# 			height: 2
# 			width: linkButton.width
# 			visible: false
# 			
# 		Utils.linkProperties(linkButton, linkButton.underline, 'x')
# 		
# 		return linkButton
# 		
# 	@_setSelected = (button) ->
# 		return if not button
# 
# # 		button.underline.visible = true
# # 		for sib in _.without(@navButtons, button)
# # 			sib.underline.visible = false
# 	
# 	Utils.define @, "selected", null, @_setSelected
# 	
# 	@navButtons[0].underline.visible = true
	
# 	signIn = new Button
# 		parent: @content
# 		x: Align.right(-44)
# 		y: 52
# 		text: "Sign In"
# 		secondary: true
		
# 	for layer in _.reverse(@navButtons)
# 		layer.maxX = (last ? (signIn.x - 44))
# 		last = layer.x - 24

# Regular Pages

# About credit scores
# pages[1] = new Page
# 	description: "About credit scores"
# 	header: "We make finance simple"
# 	body: "Your credit score is a overall rating of your financial history. The better your credit score, the more likely you are to get the best deals and interest rates. Get your free credit score every month and check it as often as you like!"
# 	cta: "Get Started"
# 	photo: "images/Screens/Dashboard2.png"
# 	background: "images/Backgrounds/Desktop.png"

# Build your score

new Page
	description: "Build your score"
	header: COPY.learn.title
	body: COPY.learn.body
	cta: "Get Started"
	device: "images/Screens/Coaching chat bot.png"
# 	background: "images/Screens/Offers.png"
	fill: "#dfe6ee"
	video: "images/Videos/Coaching_1.mp4"

# The best offers

new Page
	description: "The best offers"
	header: COPY.offers.title
	body: COPY.offers.body
	cta: "See your offers"
	device: "images/Screens/Offers.png"
# 	background: "images/Screens/Offers.png"
	fill: "#dfe6ee"

# Monthly report

new Page
	description: "The monthly report"
	header: COPY.track.title
	body: COPY.track.body
	cta: "See your report"
	device: "images/Screens/Timeline.png"
# 	background: "images/Screens/Offers.png"
	fill: "#e1eeed"

# Your privacy

new Page
	description: "Your privacy"
	header: COPY.privacy.title
	body: COPY.privacy.body
	cta: "Get Started"
	device: "images/Screens/Privacy.png"
	background: "images/backgrounds/Privacy.png"
	fill: "#e1eeed"

# About us

aboutUs = new Page
	size: homeView.size
	backgroundColor: '#FFF'
	
Utils.bind aboutUs, ->
	for layer in @children
		layer.destroy()
	
	_.assign @,
		description: "About us"
	
	new Layer
		parent: @
		image: "images/we_make_clearscore.png"
		width: 1188
		height: 693
		point: Align.center()

# Talk to us

talkToUs = new Page
	size: homeView.size
	backgroundColor: "#f5f3f3"
	
Utils.bind talkToUs, ->
	for layer in @children
		layer.destroy()
	
	_.assign @,
		description: "Talk to us"
	
	new Layer
		parent: @
		image: "images/support.png"
		width: 432
		height: 422
		point: Align.center()

# headers

# safari header

safariHeader = new Layer
	width: Screen.width
	height: 36 * scale
	gradient:
		start: "#d6d5d7"
		end: "f7f6f7"
	shadowY: 1
	shadowColor: "#a2a1a3"

app.loadingLayer.y = safariHeader.maxY - 2

Utils.bind safariHeader, ->
	
	# uiIcons
	
	for color, i in ['#ff5f58', '#ffbd2d', '#28cc42']
		button = new Layer
			parent: @
			x: 16 + ((20 * scale) * i)
			y: Align.center
			size: 24
			borderRadius: 12
			backgroundColor: color
			borderColor: new Color(color).darken(10)
			borderWidth: 1
			scale: .5 * scale
			
	# back button
	
	@backButton = new Layer
		parent: @
		x: button.maxX + (8 * scale)
		y: Align.center
		height: 44
		width: 50
		borderRadius: 4
		borderWidth: 1
		borderColor: "#cecdcf"
		shadowY: 1
		shadowColor: "#a5a4a6"
		gradient:
			start: "#f1f1f1"
			end: "#fdfdfd"
		scale: .5 * scale
	
	@backButtonIcon = new Icon
		parent: @backButton
		x: Align.center
		y: Align.center(4)
		icon: "ios-back"
		color: "#808080"
		
	@backButton.onTap => app.showPrevious()
	
	@forwardButton = new Layer
		parent: @
		x: button.maxX + (32 * scale)
		y: Align.center
		height: 44
		width: 50
		borderRadius: 4
		borderWidth: 1
		borderColor: "#cecdcf"
		shadowY: 1
		shadowColor: "#a5a4a6"
		gradient:
			start: "#f1f1f1"
			end: "#fdfdfd"
		scale: .5 * scale
			
	@forwardButtonIcon = new Icon
		parent: @forwardButton
		x: Align.center
		y: Align.center(-2)
		icon: "ios-back"
		rotation: 180
		color: "#808080"
	
	# address field
	@addressField = new Layer
		parent: @
		height: 48
		width: @width * .618
		point: Align.center()
		gradient:
			start: "#f1f1f1"
			end: "#fefefe"
		borderRadius: 4
		borderColor: "#cac9cb"
		shadowY: 1
		shadowColor: "#a5a4a6"
		scale: .5 * scale
		
	@textLayer = new TextLayer
		parent: @addressField
		point: Align.center()
		text: "clearscore.com"
		fontSize: 24
		color: '#333'
	
	#icons
	@readerIcon = new Icon
		parent: @addressField
		x: 8
		y: Align.center()
		height: 26
		width: 26
		icon: "format-align-left"
		color: '#7c7c7d'
	
	@lockIcon = new Icon
		parent: @addressField
		x: @textLayer.x - 32
		y: Align.center()
		height: 22
		width: 22
		icon: "lock"
		color: '#7c7c7d'
		
	@refreshIcon = new Icon
		parent: @addressField
		x: Align.right(-8)
		y: Align.center()
		height: 26
		width: 26
		icon: "refresh"
		color: '#7c7c7d'

# Header Menu

header = new Layer
	width: Screen.width
	y: safariHeader.maxY
	height: 80
	backgroundColor: 'rgba(255, 255, 255, 0)'
	shadowY: 0
	opacity: 1
	
Utils.bind header, ->
	
	logo = new Layer
		parent: @
		width: 168
		height: 22
		image: "images/logo.png"
		x: 48
		y: 28
		invert: 100
		brightness: 0
		blending: Blending.difference
		
	logo.onTap -> homeView.scrollY = 0
	
	@navButtons = NAV_LINKS.map (link, i) =>
		linkButton = new Body2Link
			parent: @
			y: 18
			x: Align.right()
			color: black
			opacity: 1
			text: link.text
			select: =>
				pages[0].stopMe = false
				@selected = linkButton
				showPage(link.page())
		
		linkButton.underline = new Layer
			parent: @
			y: linkButton.maxY
			backgroundColor: '#000'
			height: 2
			width: linkButton.width
			visible: false
			
		Utils.linkProperties(linkButton, linkButton.underline, 'x')
		
		return linkButton
		
	@_setSelected = (button) ->
		return if not button

		button.underline.visible = true
		for sib in _.without(@navButtons, button)
			sib.underline.visible = false
	
	Utils.define @, "selected", null, @_setSelected
	
	signIn = new Button
		parent: @
		x: Align.right(-44)
		y: 18
		text: "Sign In"
		secondary: true
		
	for layer in _.reverse(@navButtons)
		layer.maxX = (last ? (signIn.x - 44))
		last = layer.x - 24

	@_setOpened = (bool) ->
# 		
		if bool 
			@animate
				backgroundColor: 'rgba(255, 255, 255, 1)'
				shadowY: 1
# 				y: safariHeader.maxY
				options:
					time: .25
			return
		
		@animate
			backgroundColor: 'rgba(255, 255, 255, 0)'
			shadowY: 0
# 			y: -64
			options:
				time: .25
		
	Utils.define @, "opened", false, @_setOpened
	
	@selected = @navButtons[2]

# 
# homeView.onScroll (event) ->
# 	return if homeView.scrollY < RUNWAY - (Screen.height * 1.4)


# Logo

# logo = new Layer
# # 	parent: homeView.content
# 	width: 168
# 	height: 22
# 	image: "images/logo.png"
# 	x: 48
# 	y: 28 + safariHeader.maxY
# # 	invert: 100
# 	brightness: 0
# # 	blending: Blending.difference
# 	
# logo.onTap -> homeView.scrollY = 0

# Show a page
	
showPage = (page) ->
	currentPage = _.minBy(pages, (p) -> return homeView.scrollY - p.y)
		
# 	for p in pages
# 		p.animate
# 			opacity: 0
# 			options:
# 				time: .25
	
	# TODO: show smooth up too
	
	Utils.delay .25, =>
# 		homeView.scrollY = page.y - 100
		homeView.scrollToPoint(
			x: 0, y: page.y
			true
			time: 1
			)
	
# 		for page in pages
# 			page.animate
# 				opacity: 1
# 				options:
# 					time: .25


last = undefined

pages[1...].forEach (page, i) ->
	next = pages[i + 2]
	
	if next?
		page.nav.copy.text = next.description
		
		page.nav.onTap -> 
			pages[0].stopMe = false
			homeView.scrollToPoint(
				x: 0, y: next.y
				true
				time: .45
				)
# 				
	page.y = (last?.maxY ? RUNWAY)
	last = page
	homeView.updateContent()


app.showNext homeView
safariHeader.bringToFront()