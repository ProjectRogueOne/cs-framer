require 'framework'

SHOW_ALL = true
SHOW_LAYER_TREE = false

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
# App

app = new App
	chrome: null

# Header

scale = 1
EMAIL_SUBMIT = true
DIRECTION = "horizontal"
DIRECTION = "vertical"

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
	scrollVertical: false


app.showNext homeView


# Shapes

shapes = _.range(12).map (i) ->
	
	shape = new Layer
		name: "Shape #{i}"
		parent: homeView
		x: 0
		y: Align.center()
		height: Screen.height * 2
		width: Screen.width / 2
		backgroundColor: null
	
# 	_.assign shape,
# 		startImg: Utils.randomImage()
# 		endImg: Utils.randomImage()
# 		startColor: blue
# 		endColor: green
		
	shape.imageLayer = new Layer
		name: 'image mask'
		size: shape.size
		clip: true
		backgroundColor: null #@startColor
		opacity: 0
		
	shape.imgLayerBackground = new Layer
		name: 'image'
		parent: shape.imageLayer
		height: shape.height * 1.25
		width: shape.width * 1.25
# 		image: ''
		backgroundColor: null
		y: Align.center(-200)
		x: Align.center()
		blur: 80
		opacity: 0
	
	h = Screen.height * .618
	w = h * 676/1354
	
	shape.device = new Layer
		name: "Device #{i}"
		parent: shape
		height: h
		width: w-32
		y: Screen.width / 8
		x: Align.center()
		backgroundColor: grey
		borderRadius: 48
		shadowX: 12
		shadowY: 24
		shadowBlur: 40
		shadowColor: "rgba(0,0,0,.41)"
		
	shape.imgLayer = new Layer
		name: "Device #{i}"
		parent: shape.device
		size: shape.device
		borderRadius: 48
		image: ''
		
	shape.deviceScreen = new Layer
		name: "Device #{i}"
		parent: shape.device
		height: h
		width: w
		x: -20
		backgroundColor: null
		image: 'images/iPhoneX.png'
	
	shape.setFactor = (factor) ->
		
		
		@y = Utils.modulate(
			factor,
			[0, 3],
			[-@height, Screen.height]
		)
		
# 		@imageLayer.backgroundColor = Color.mix(
# 			@startColor,
# 			@endColor,
# 			Utils.modulate(factor, [0, 3], [0, 1], true)
# 		)
		
# 		@imageLayerImage.x = Utils.modulate(
# 			factor
# 			[1, 2]
# 			[-@imageLayer.width * .9, -@imageLayer.width * .5]
# 			true
# 		)
# 		
# 		@device.midX = Utils.modulate(
# 			factor
# 			[1, 2]
# 			[@width - 48, 24]
# 			true
# 		)
# 		
# 		@endImgLayer.opacity = Utils.modulate(
# 			factor
# 			[1, 2]
# 			[1, 0]
# 			true
# 		)

# 		@imgLayerBackground.opacity = 1 - Math.abs(factor - 2)
# 		@device.shadowX = Utils.modulate(
# 			factor
# 			[1, 2]
# 			[-24, 24]
# 			true
# 		)
# 		
	Utils.define shape, "factor", 0, shape.setFactor
	
	_.assign shape,
		factor: 0

# Pager

pages = []

pager = new PageComponent
	parent: homeView.content
	size: homeView.size
	scrollHorizontal: false
	scrollVertical: true

updatePagesX = ->
	pages.forEach (page) ->
		factor = Utils.modulate(
			pager.scrollX - page.x
			[page.width * 2, -page.width * 2]
			[-2, 2]
			true
			)
		
		page.emit "change:factor", factor, page
		
updatePagesY = ->
	pages.forEach (page) ->
		factor = Utils.modulate(
			pager.scrollY - page.y
			[page.height * 2, -page.height * 2]
			[-2, 2]
			true
			)
		
		page.emit "change:factor", factor, page
		
# set page factors
pager.content.on "change:y", updatePagesY
pager.content.on "change:x", updatePagesX


showPage = (page) ->
	diff = Math.abs(_.indexOf(pages, pager.currentPage) - _.indexOf(pages, page))
	return if diff is 0
	
	if Math.abs(diff) is 1
		pager.snapToPage(page, true, {time: .7})
		return
		
	homeView.animate
		opacity: 0
		options:
			time: .15
	
	Utils.delay .17, =>
		pager.snapToPage(page, true, {time: 0})
		for shape, i in shapes
			shape.setFactor(0)
		Utils.delay .25, =>
			page.shape?.setFactor(2)
			homeView.animate
				opacity: 1
				options:
					time: .25

pager.on "change:currentPage", ->
	for otherButton in navigation.buttons
		otherButton.circle?.brightness = 100
	button = navigation.buttons[_.indexOf(pages, pager.currentPage) - 1]
	button?.circle?.brightness = 90

# Page

class Page extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			size: homeView.size
			backgroundColor: null
			
			shape: shapes[0]
			description: "The monthly report"
			header: "Your full credit report. Every month."
			body: "Keep track of your financial history with our free monthly credit reports. Credit reports are a great way to see any outstanding issues in your credit and keep track of spending."
			cta: "See your report"
			photo: "images/Screens/Dashboard.png"
			
		super options
		
		options.shape.imgLayerBackground.image = options.photo
		options.shape.imgLayer.image = options.photo
		
		@backgroundMask = new Layer
			parent: pager
			width: Screen.width / 2
			height: Screen.height
			clip: true
			opacity: 0
		
		@background = new Layer
			parent: @backgroundMask
			width: Screen.width * 1.2
			height: Screen.height * 1.2
			x: Screen.width * -.25
			y: 0
			image: options.photo
			blur: 40
		
		@background.sendToBack()
		
	
		container = new Layer
			parent: @
			backgroundColor: null
		
		_.assign @,
			shape: options.shape
			description: options.description
		
		container = new Layer
			parent: @
			backgroundColor: null
		
		copy = new H1
			parent: container
			width: 353
			text: options.header
			
		copy = new Body
			parent: container
			y: copy.maxY + 16
			width: 353
			text: options.body
		
		@primaryCTA = new Button
			parent: container
			y: copy.maxY + 24
			width: 200
			text: options.cta
		
		Utils.bind container, ->
			_.assign @,
				width: _.maxBy(@.children, 'maxX').maxX
				height: _.maxBy(@.children, 'maxY').maxY
				
			_.assign @,
				midX: Screen.width * .75
				y: Align.center()
				
		@on "change:factor", (factor) ->
		
			factor = Utils.modulate(
				factor,
				[-2, 2]
				[0, 4]
				true
				)
			@backgroundMask.opacity = 1 - Math.abs(factor - 2)
	
			_.assign @shape,
				factor: factor

# Page 0

pages[0] = new Layer
	size: homeView.size
	backgroundColor: null

Utils.bind pages[0], ->
	
	_.assign @,
		shape: shapes[0]
		description: "Home"
	
	shapes[0].imgLayerBackground.image = 'images/Screens/Dashboard.png'
	shapes[0].imgLayer.image = 'images/Screens/Dashboard.png'
	
	@backgroundMask = new Layer
		parent: pager
		width: Screen.width / 2
		height: Screen.height
		clip: true
	
	@background = new Layer
		parent: @backgroundMask
		width: (Screen.width / 2) * 1.5
		height: (Screen.height / 2) * 1.5
		image: "images/Screens/Dashboard.png"
		blur: 40
	
	@background.sendToBack()
	
	container = new Layer
		parent: @
		backgroundColor: null
	
	copy = new H1
		parent: container
		width: 360
		lineHeight: 1.23
		text: "Your credit score and report. For free, forever."
	
	if EMAIL_SUBMIT
		@emailSubmit = new TextInput
			parent: container
			y: copy.maxY + 64
			width: 240
			placeholder: "Enter your email"
			
		@warnText = new Micro
			parent: container
			y: @emailSubmit.maxY + 4
			color: black
			text: "Please enter a valid email address"
			color: black30
			visible: false
		
		@primaryCTA = new Button
			parent: container
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
			parent: container
			x: copy.x
			y: copy.maxY + 64
			width: 200
			text: "Get Started"
		
		@secondaryCTA = new Button
			parent: container
			x: @primaryCTA.maxX + 16
			y: copy.maxY + 64
			width: 200
			text: "Find out more"
			secondary: true
			select: => 
				showPage pages[1]
	
	
	_.assign container, 
		width: _.maxBy(container.children, 'maxX').maxX
		height: _.maxBy(container.children, 'maxY').maxY
		midX: Screen.width * .75
		y: Align.center()
	
	
	
	@on "change:factor", (factor) =>
# 		return if pager.currentPage isnt @
		
		if -2 < factor < 2
			factor = Utils.modulate(
				factor,
				[-2, 2]
				[0, 4]
				true
				)
	
			@backgroundMask.opacity = 1 - Math.abs(factor - 2)
	
			_.assign @shape,
				visible: true
				factor: factor

# Page 1

pages[1] = new Page
	size: homeView.size
	backgroundColor: null
	shape: shapes[1]
	description: "About credit scores"
	header: "We make finance simple"
	body: "Your credit score is a overall rating of your financial history. The better your credit score, the more likely you are to get the best deals and interest rates. Get your free credit score every month and check it as often as you like!"
	cta: "Get Started"
	photo: "images/Screens/Dashboard2.png"

# Page 2

pages[2] = new Page
	size: homeView.size
	backgroundColor: null
	shape: shapes[2]
	description: "Build your score"
	header: "Building your score"
	body: "If your new to credit you may have a low or no score. This can prevent you from being accepted for financial services. We’ll show you how to build your score to help you meet your financial goals."
	cta: "Get Started"
	photo: "images/Screens/Coaching chat bot.png"

# Page 3

pages[3] = new Page
	size: homeView.size
	backgroundColor: null
	shape: shapes[3]
	description: "The best offers"
	header: "Get the best offers"
	body: "Having a good credit score means your more likely to get better deals and interest rates on mortgages, loans, credit cards and car insurance. We’ll show you the best deals for you and how likely you’ll be accepted."
	cta: "See your offers"
	photo: "images/Screens/Offers.png"

# Page 4

pages[4] = new Page
	size: homeView.size
	backgroundColor: null
	shape: shapes[4]
	description: "The monthly report"
	header: "Your full credit report. Every month."
	body: "Keep track of your financial history with our free monthly credit reports. Credit reports are a great way to see any outstanding issues in your credit and keep track of spending."
	cta: "See your report"
	photo: "images/Screens/Timeline.png"

# Page 5

pages[5] = new Page
	size: homeView.size
	backgroundColor: null
	shape: shapes[5]
	description: "Your privacy"
	header: "You’re in safe hands"
	body: "Your financial data is important. We use the latest in 256-bit encryption to ensure your information stays secure. We will never sell your data, we won’t send nuisance emails and checking your score is risk free."
	cta: "Get Started"
	photo: "images/Screens/Privacy.png"

# Page 6

pages[6] = new Layer
	size: homeView.size
	backgroundColor: '#FFF'
	
Utils.bind pages[6], ->
	
	_.assign @,
		shape: shapes[6]
		description: "About us"
	
	new Layer
		parent: @
		image: "images/we_make_clearscore.png"
		width: 1180
		height: 699
		point: Align.center()

# Page 7

pages[7] = new Layer
	size: homeView.size
	backgroundColor: "#f5f3f3"
	
Utils.bind pages[7], ->
	
	_.assign @,
		shape: shapes[7]
		description: "Talk to us"
	
	new Layer
		parent: @
		image: "images/support.png"
		width: 432
		height: 422
		point: Align.center()

# Images

# shapes[0].setImages
# 	startImg: "images/Screens/Dashboard.png"
# 	endImg: "images/Screens/Dashboard2.png"
# shapes[1].setImages
# 	startImg: "images/Screens/Coaching chat bot.png"
# 	endImg: "images/Screens/Offers.png"
# shapes[2].setImages
# 	startImg: "images/Screens/Timeline.png"
# 	endImg: "images/Screens/Privacy.png"

# Navigator

navigation = new Layer
# 	parent: homeView
	x: Align.center()
	y: Align.bottom(-56)
# 	width: 940
# 	width: 1024
	width: 1192
	height: 64
	backgroundColor: white
	borderRadius: 64
	shadowY: 6
	shadowBlur: 12
	borderWidth: 2
	borderColor: "#efefef"
	shadowColor: "rgba(0,0,0,.16)"
	clip: true
	
home = new Icon
	parent: navigation
	icon: "home"
	x: 40, y: Align.center(2)
	color: grey80
	
home.onTap -> 
	showPage pages[0]
	for sib in @siblings
		sib.circle?.brightness = 100
	
	
navigation.buttons = pages[1...6].map (page, i) ->
	button = new Layer
		parent: navigation
		height: navigation.height - 8
		y: Align.center()
		x: 28 + (_.last(navigation.children)?.maxX ? 0) + 16
# 		x: (navigation.width / pages.length) * i
		backgroundColor: white
	
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
			
		copy = new Body2
			parent: button
			x: @circle.maxX + 16
			y: Align.center()
# 			fontSize: 24
			text: page.description
			
		button.width = copy.maxX
	
		@onTap -> 
			showPage(page)
			
	
	return button
		
# Utils.distribute(
# 	navigation.buttons, 
# 	'x',
# 	96, 
# 	(navigation.width - 72) - (_.last(navigation.children).width)
# 	)

# Top Links

topLinks = new Layer
# 	parent: homeView
	y: 56
	x: Screen.width / 2 + 56
	width: 580
# 	width: (Screen.width * .28)
	height: 64
	backgroundColor: white
	borderRadius: 64
	clip: true



topLinks.buttons = [
	"Benefits"
	"Learn"
	"About us"
	"Talk to us"
	"Sign in"
	].map (link, i) ->
	button = new Layer
		parent: topLinks
		height: topLinks.height - 8
		y: Align.center()
		x: 41 + (_.last(topLinks.children)?.maxX ? 0) + 16
# 		x: (navigation.width / pages.length) * i
		backgroundColor: white
	
	Utils.bind button, ->
		button.link = new Body2Link
			parent: button
			x: 0
			y: Align.center()
# 			fontSize: 24
			text: link
			
		button.width = button.link.maxX
	
		@onTap -> null
		
	return button
	
		
# Utils.distribute(
# 	topLinks.buttons, 
# 	'x',
# 	80, 
# 	(topLinks.width - 80) - (_.last(topLinks.children).width)
# 	)

topLinks.buttons[2].link.onSelect => showPage pages[6]
topLinks.buttons[3].link.onSelect => showPage pages[7]

# Sign In

signIn = new Button
	x: Align.right(-48)
	y: 80
	secondary: true
	text: "Sign In"

# Logo

logo = new Layer
	width: 168
	height: 22
	image: "images/logo.png"
	x: 48
	y: 86
	invert: 100
	brightness: 0

for shape in shapes
	shape.bringToFront()
# 	shape.imageLayer.parent = pager
# 	shape.imageLayer.placeBehind(pager.content)

for page in pages
	pager.addPage(page, if DIRECTION is "vertical" then "bottom")
	
pager.snapToPage(pages[0])
pages[0].shape.setFactor(2)

navigation.visible = false
topLinks.visible = false