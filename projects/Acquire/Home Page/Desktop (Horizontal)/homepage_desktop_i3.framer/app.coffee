require 'framework'
require 'cs'

SHOW_ALL = true
SHOW_LAYER_TREE = false

# Setup
{ theme } = require 'components/Theme' # not usually needed

Canvas.backgroundColor = bg3
Framer.Extras.Hints.disable()

# dumb thing that blocks events in the upper left-hand corner
dumbthing = document.getElementById("FramerContextRoot-TouchEmulator")?.childNodes[0]
dumbthing?.style.width = "0px"

EMAIL_SUBMIT = false

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

# Settings

TOP_LINKS = [
	{text: "Benefits", callback: -> homeView.showSection(pager)}
	{text: "Learn", callback: -> homeView.showSection(aboutUs)}
	{text: "About us", callback: -> homeView.showSection(aboutUs)}
	{text: "Talk to us", callback: -> homeView.showSection(talkToUs)}
	{text: "Sign in", callback: -> null}
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

# ----------------
# App

app = new App
	chrome: null

scale = 1

# header

header = new Layer
	width: Screen.width
	height: 36 * scale
	gradient:
		start: "#d6d5d7"
		end: "f7f6f7"
	shadowY: 1
	shadowColor: "#a2a1a3"

app.loadingLayer.y = header.maxY - 2

Utils.bind header, ->
	
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
		
	

# Home View

homeView = new View
	title: 'Framework'
	padding: null
# 	scrollVertical: false
	mouseWheelEnabled: true
	mouseWheelSpeedMultiplier: .126
	
homeView.content.draggable.enabled = false

Utils.bind homeView, ->
	@showSection = (layer) =>
		@scrollToPoint(
			x: 0, y: layer.y
			true
			time: .6
			)

	# Logo

	logo = new Layer
		parent: @content
		width: 168
		height: 22
		image: "images/logo.png"
		x: 393
		y: 86

app.showNext homeView

# Shapes

shapes = _.range(5).map (i) ->
	
	shape = new Layer
		name: "Shape #{i}"
		parent: homeView.content
		x: Align.right()
		height: Screen.height
		width: Screen.width / 2
	
	shape.setImages = (images = {}) ->
		_.assign @,
			startImg: images.startImg
			endImg: images.endImg
			
		@imageLayerImage.image = @startImg
		@startImgLayer.image = @startImg
		@imageLayerEndImage.image = @endImg
		@endImgLayer.image = @endImg
	
	_.assign shape,
		startImg: Utils.randomImage()
		endImg: Utils.randomImage()
		startColor: blue
		endColor: green
		
	shape.imageLayer = new Layer
		name: 'image mask'
		parent: shape
		size: shape.size
		clip: true
		backgroundColor: null #@startColor
		
	shape.imageLayerImage = new Layer
		name: 'image'
		parent: shape.imageLayer
		height: shape.height * 1.25
		width: shape.width * 1.25
		image: shape.startImg
		y: Align.center()
		blur: 80
		
	shape.imageLayerEndImage = new Layer
		name: 'image'
		parent: shape.imageLayer
		height: shape.height * 1.25
		width: shape.width * 1.25
		image: shape.endImg
		y: Align.center()
		blur: 80
	
	
	scrim = new Layer
		parent: shape
		height: 251
		width: shape.width + 2
		x: -1
		backgroundColor: white
		
	scrim = new Layer
		parent: shape
		y: 250
		width: shape.width + 2
		height: 500
		gradient:
			start: 'rgba(255,255,255,0)'
			end: 'rgba(255,255,255,1)'
	
	h = Screen.height * .618
	w = h * 676/1354
	
	shape.device = new Layer
		name: "Device #{i}"
		parent: shape
		height: h
		width: w-32
		y: Align.center()
		x: -w/2
		backgroundColor: grey
		borderRadius: 48
		image: shape.startImg
		shadowX: 12
		shadowY: 24
		shadowBlur: 40
		shadowColor: "rgba(0,0,0,.41)"
		
	shape.startImgLayer = new Layer
		name: "Device #{i}"
		parent: shape.device
		size: shape.device
		borderRadius: 48
		image: shape.startImg
		
	shape.endImgLayer = new Layer
		name: "Device #{i}"
		parent: shape.device
		size: shape.device
		borderRadius: 48
		image: shape.endImg
		
	shape.deviceScreen = new Layer
		name: "Device #{i}"
		parent: shape.device
		height: h
		width: w
		x: -20
		backgroundColor: null
		image: 'images/iPhoneX.png'
		
	half_device = shape.device.width / 2
	half_width = (Screen.width * .191) - half_device
	
	x1 = 393 + half_device - shape.width + 128
	x2 = (Screen.width - 393) - half_device
	x3 = x2 + (x2 - x1)
	x0 = x1 - (x2 - x1)
		
	shape.setFactor = (factor) ->
		shape.opacity = 1
		return if 0 > factor > 3
		
		@x = Utils.modulate(
			factor
			[0, 3]
			[x0, x3]
		)
		
		@imageLayer.backgroundColor = Color.mix(
			@startColor,
			@endColor,
			Utils.modulate(factor, [0, 3], [0, 1], true)
		)
		
		@imageLayerImage.x = Utils.modulate(
			factor
			[1, 2]
			[-@imageLayer.width * .9, -@imageLayer.width * .5]
			true
		)
		
		@device.midX = Utils.modulate(
			factor
			[1, 2]
			[@width - 48, 24]
			true
		)
		
		@endImgLayer.opacity = Utils.modulate(
			factor
			[1, 2]
			[1, 0]
			true
		)
		
		@imageLayerEndImage.opacity = Utils.modulate(
			factor
			[1, 2]
			[1, 0]
			true
		)
		
		@device.shadowX = Utils.modulate(
			factor
			[1, 2]
			[-24, 24]
			true
		)
		
	Utils.define shape, "factor", 1, shape.setFactor
	
	_.assign shape,
		factor: 2
		visible: false

# Pager

pages = []

pager = new PageComponent
	parent: homeView.content
	size: homeView.size
	scrollHorizontal: false
	scrollVertical: false

# set page factors
pager.content.on "change:x", =>
	pages.forEach (page) =>
		
		factor = Utils.modulate(
			pager.scrollX - page.x
			[page.width * 2, -page.width * 2]
			[-2, 2]
			true
			)
		
		page.emit "change:factor", factor, page
		
showPage = (page) ->
	diff = Math.abs(_.indexOf(pages, pager.currentPage) - _.indexOf(pages, page))
	return if diff is 0
	
	if Math.abs(diff) is 1
		pager.snapToPage(page, true, {time: .7})
		return
		
	pager.animate
		opacity: 0
		options:
			time: .15
			
	for shape in shapes
		shape.animate
			opacity: 0
			options:
				time: .15
	
	Utils.delay .25, =>
		pager.snapToPage(page, false)
# 		for shape, i in shapes
# 			shape.setFactor(0)
		Utils.delay .25, =>
			page.shape?.opacity = 0
			pager.animate
				opacity: 1
				options:
					time: .25
			page.shape?.animate
				opacity: 1
				options:
					time: .25

tint = new Color('#5a95a3')

pager.on "change:currentPage", (currentPage) ->
	
	if currentPage is pages[0]
		home.animate
			color: tint
			options:
				time: .15
	else
		home.animate
			color: black
			options:
				time: .15
	
	# set nonactive button props
	
	for otherButton in navigation.buttons
		otherButton.circle?.animate
			backgroundColor: tint.alpha(0)
			borderWidth: 1
			options:
				time: .15
		
		otherButton?.copy?.animate
			color: black
			options:
				time: .15
		
		otherButton?.number?.animate
			color: black
			options:
				time: .15
	
	# set current page button props
	
	button = navigation.buttons[_.indexOf(pages, currentPage) - 1]
	
	button?.circle?.animate
		backgroundColor: tint
		borderWidth: 0
		options:
			time: .15
	
	button?.copy?.animate
		color: tint
		options:
			time: .15
	
	button?.number?.animate
		color: white
		options:
			time: .15

# Page 0

pages[0] = new Layer
	size: homeView.size
	backgroundColor: null
	
Utils.bind pages[0], ->
	
	_.assign @,
		shape: shapes[0]
		description: "Home"
	
	copy = new H1
		parent: @
		x: 393
		y: Screen.height * .280
		text: "Your credit score and report. For free, forever."
		width: Screen.width / 5
	
	if EMAIL_SUBMIT
		@emailSubmit = new TextInput
			parent: @
			x: copy.x
			y: copy.maxY + 64
			width: 240
			placeholder: "Enter your email"
			
		@warnText = new Micro
			parent: @
			y: @emailSubmit.maxY + 4
			x: copy.x + 24
			color: black
			text: "Please enter a valid email address"
			color: black30
			visible: false
		
		@primaryCTA = new Button
			parent: @
			x: @emailSubmit.maxX + 16
			y: copy.maxY + 64
			text: 'Get started'
			width: 128
			
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
	
		@primaryCTA = new Button
			parent: @
			x: copy.x
			y: copy.maxY + 64
			width: 200
			text: "Get Started"
		
		@secondaryCTA = new Button
			parent: @
			x: @primaryCTA.maxX + 16
			y: copy.maxY + 64
			width: 200
			text: "Find out more"
			secondary: true
			select: => 
				showPage pages[1]
		
	@on "change:factor", (factor) =>
# 		return if pager.currentPage isnt @
		
		if -2 < factor < 2
			factor = Utils.modulate(
				factor,
				[-2, 2]
				[0, 4]
				true
				)
	
			_.assign @shape,
				visible: true
				factor: factor

# Page 1

pages[1] = new Layer
	size: homeView.size
	backgroundColor: null
	
Utils.bind pages[1], ->
	
	_.assign @,
		description: "About credit scores"
	
	copy = new H1
		parent: @
		x: 1069
		y: Screen.height * .280
		width: 353
		text: COPY.intro.title
		
	copy = new Body
		parent: @
		y: copy.maxY + 16
		x: copy.x
		width: 353
		text: COPY.intro.body
	
	@primaryCTA = new Button
		parent: @
		x: copy.x
		y: copy.maxY + 24
		width: 200
		text: "Get Started"

# Page 2

pages[2] = new Layer
	size: homeView.size
	backgroundColor: null
	
Utils.bind pages[2], ->
	
	_.assign @,
		shape: shapes[1]
		description: "Build your score"
	
	copy = new H1
		parent: @
		x: 393
		y: Screen.height * .280
		width: Screen.width / 5
		text: COPY.learn.title
		
	copy = new Body
		parent: @
		y: copy.maxY + 16
		x: copy.x
		width: 353
		text: COPY.learn.body
	
	@primaryCTA = new Button
		parent: @
		x: copy.x
		y: copy.maxY + 24
		width: 200
		text: "Get Started"
		
	@on "change:factor", (factor) =>
# 		return if pager.currentPage isnt @
		
		if -2 < factor < 2
			factor = Utils.modulate(
				factor,
				[-2, 2]
				[0, 4]
				true
				)
	
			_.assign @shape,
				visible: true
				factor: factor

# Page 3

pages[3] = new Layer
	size: homeView.size
	backgroundColor: null
	
Utils.bind pages[3], ->
	
	_.assign @,
		description: "The best offers"
	
	copy = new H1
		parent: @
		x: 1069
		y: Screen.height * .280
		width: 353
		text: COPY.offers.title
		
	copy = new Body
		parent: @
		y: copy.maxY + 16
		x: copy.x
		width: 353
		text: COPY.offers.body
	
	@primaryCTA = new Button
		parent: @
		x: copy.x
		y: copy.maxY + 64
		width: 200
		text: "See your offers"

# Page 4

pages[4] = new Layer
	size: homeView.size
	backgroundColor: null
	
Utils.bind pages[4], ->
	
	_.assign @,
		shape: shapes[2]
		description: "The monthly report"
	
	copy = new H1
		parent: @
		x: 393
		y: Screen.height * .280
		width: Screen.width / 5
		text: COPY.track.title
		
	copy = new Body
		parent: @
		y: copy.maxY + 16
		x: copy.x
		width: 353
		text: COPY.track.body
	
	@primaryCTA = new Button
		parent: @
		x: copy.x
		y: copy.maxY + 24
		width: 200
		text: "See your report"
		
	@on "change:factor", (factor) =>
# 		return if pager.currentPage isnt @
		
		if -2 < factor < 2
			factor = Utils.modulate(
				factor,
				[-2, 2]
				[0, 4]
				true
				)
	
			_.assign @shape,
				visible: true
				factor: factor

# Page 5

pages[5] = new Layer
	size: homeView.size
	backgroundColor: null
	
Utils.bind pages[5], ->
	
	_.assign @,
		description: "Your privacy"
	
	copy = new H1
		parent: @
		x: 1069
		y: Screen.height * .280
		width: 353
		text: COPY.privacy.title
		
	copy = new Body
		parent: @
		y: copy.maxY + 16
		x: copy.x
		width: 353
		text:  COPY.privacy.body
	
	@primaryCTA = new Button
		parent: @
		x: copy.x
		y: copy.maxY + 64
		width: 200
		text: "Get Started"

# About Us

aboutUs = new Layer
	parent: homeView.content
	size: homeView.size
	backgroundColor: '#FFF'
	y: Screen.height
	
Utils.bind aboutUs, ->
	
	_.assign @,
		description: "About us"
	
	new Layer
		parent: @
		image: "images/we_make_clearscore.png"
		width: 1180
		height: 699
		point: Align.center()
			

# Talk to Us

talkToUs = new Layer
	parent: homeView.content
	size: homeView.size
	backgroundColor: "#f5f3f3"
	y: Screen.height * 2
	
Utils.bind talkToUs, ->
	
	_.assign @,
		description: "Talk to us"
	
	new Layer
		parent: @
		image: "images/support.png"
		width: 432
		height: 422
		point: Align.center()
		

# Images

	shapes[0].setImages
		startImg: "images/Screens/Dashboard.png"
		endImg: "images/Screens/Dashboard2.png"
	shapes[1].setImages
		startImg: "images/Screens/Coaching chat bot.png"
		endImg: "images/Screens/Offers.png"
	shapes[2].setImages
		startImg: "images/Screens/Timeline.png"
		endImg: "images/Screens/Privacy.png"

# Navigator

navigation = new Layer
	parent: homeView.content
	y: Screen.height - 64
# 	width: 940
# 	width: 1024
	width: homeView.width
	height: 64
	backgroundColor: white
	shadowY: -2
	borderColor: "#efefef"
	shadowColor: "rgba(0,0,0,.16)"
	clip: true
	
navigation.buttonsContainer = new Layer
	parent: navigation
	height: navigation.height
	backgroundColor: null
	
home = new Icon
	parent: navigation.buttonsContainer
	icon: "home-outline"
	x: 40, y: Align.center(2)
	color: tint
	
home.onTap -> 
	showPage pages[0]
	for sib in @siblings
		sib.circle?.brightness = 100
	
	
navigation.buttons = pages[1...6].map (page, i) ->
	button = new Layer
		parent: navigation.buttonsContainer
		height: navigation.height
		x: (_.last(navigation.buttonsContainer.children)?.maxX ? 0) + 66
# 		x: (navigation.width / pages.length) * i
		backgroundColor: null
	
	Utils.bind button, ->
		@circle = new Layer
			parent: @
			height: 28
			width: 28
			borderRadius: 32
			x: 16
			y: Align.center()
			borderWidth: 1
			borderColor: black
			backgroundColor: white
		
		@number = new Body2
			parent: @circle
			text: i + 1
			x: Align.center(1)
			y: Align.center(1)
			
		@copy = new Body2
			parent: button
			x: @circle.maxX + 12
			y: Align.center()
# 			fontSize: 24
			text: page.description
			
		button.width = @copy.maxX
	
		@onTap -> showPage(page)
		
	return button

Utils.bind navigation.buttonsContainer, ->
	_.assign @,
		width: _.maxBy(@children, 'maxX').maxX + 40
		x: Align.center()
		
# Utils.distribute(
# 	navigation.buttons, 
# 	'x',
# 	96, 
# 	(navigation.width - 72) - (_.last(navigation.children).width)
# 	)

# Top Links

topLinks = new Layer
	parent: homeView.content
	y: 56
	width: 580
	height: 64
	backgroundColor: null
	clip: true

topLinks.midX = shapes[0].x


topLinks.buttons = TOP_LINKS.map (link, i) ->
	button = new Layer
		parent: topLinks
		height: topLinks.height - 8
		y: Align.center()
		x: 41 + (_.last(topLinks.children)?.maxX ? 0) + 16
# 		x: (navigation.width / pages.length) * i
		backgroundColor: null
	
	Utils.bind button, ->
		button.link = new Body2Link
			parent: button
			x: 0
			y: Align.center()
			text: link.text
			select: link.callback
			
		button.width = button.link.maxX
		
	return button
	
		
# Utils.distribute(
# 	topLinks.buttons, 
# 	'x',
# 	80, 
# 	(topLinks.width - 80) - (_.last(topLinks.children).width)
# 	)
# 
# topLinks.buttons[2].link.onSelect => showPage pages[6]
# topLinks.buttons[3].link.onSelect => showPage pages[7]




for page in pages
	pager.addPage(page)
	
pager.snapToPage(pages[0])
pages[0].shape.visible = true
