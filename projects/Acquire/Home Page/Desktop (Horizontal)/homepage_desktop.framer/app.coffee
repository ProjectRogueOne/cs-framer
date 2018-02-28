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

EMAIL_SUBMIT = true

# ----------------
# App

app = new App
	chrome: null

# Header

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
	scrollVertical: false


app.showNext homeView


# Shapes

shapes = _.range(5).map (i) ->
	
	
	shape = new Layer
		name: "Shape #{i}"
		parent: homeView.content
		x: Align.right()
		y: Align.center()
		height: Screen.height
		width: Screen.width / 2
	
	_.assign shape,
		img: Utils.randomImage()
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
		width: shape.width * 2
		image: shape.img
		y: Align.center()
# 		saturate: 0
# 		brightness: 220
# 		blending: Blending.multiply
		blur: 80
	
	
	scrim = new Layer
		parent: shape
		height: 201
		width: shape.width
		backgroundColor: white
		
	scrim = new Layer
		parent: shape
		y: 200
		width: shape.width
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
		image: shape.img
		shadowX: 12
		shadowY: 24
		shadowBlur: 40
		shadowColor: "rgba(0,0,0,.41)"
		
	shape.deviceScreen = new Layer
		name: "Device #{i}"
		parent: shape.device
		height: h
		width: w
		x: -20
		backgroundColor: null
		image: 'images/iPhoneX.png'
		
# 	new SVGLayer
# 		parent: shape
# 		size: Screen.size
# 		x: Align.center()
# 		svg: "<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>" + 
# # 		"<path d='M 0,#{shape.height} " +
# # 			"C #{shape.width/4},#{shape.height} " +
# # 			"#{shape.width/4},200 " + 
# # 			"#{shape.width/2},200 " +
# # 			"#{shape.width * .85},#{200} " +
# # 			"#{shape.width * .85},#{shape.height} " +
# # 			"#{shape.width},#{shape.height} " +
# 			"'/>" + 
# 			"<image href='images/iPhoneX.png' height='200' width='200'/>"
# 		strokeWidth: 10
# 		stroke: black
# 		fill: black
	half_device = shape.device.width / 2
	half_width = (Screen.width * .191) - half_device
	
	x1 = 393 + half_device - shape.width + 128
	x2 = (Screen.width - 393) - half_device
	x3 = x2 + (x2 - x1)
	x0 = x1 - (x2 - x1)
	
	shape.setFactor = (factor) ->
# 		if shape.name is "Shape 0" then print factor
		
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

# Page 0

pages[0] = new Layer
	size: homeView.size
	backgroundColor: null
	
Utils.bind pages[0], ->
	
	_.assign @,
		shape: shapes[0]
		description: "What is a credit score?"
	
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
			select: => pager.snapToPage(pages[1], true, time: 1)
		
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
		description: "What is a credit score?"
	
	copy = new H1
		parent: @
		x: 1069
		y: Screen.height * .280
		width: 353
		text: "We make finance simple"
		
	copy = new Body
		parent: @
		y: copy.maxY + 16
		x: copy.x
		width: 353
		text: "Your credit score is a overall rating of your financial history. The better your credit score, the more likely you are to get the best deals and interest rates. Get your free credit score every month and check it as often as you like!"
	
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
		description: "Building your score"
	
	copy = new H1
		parent: @
		x: 393
		y: Screen.height * .280
		width: Screen.width / 5
		text: "We make finance simple"
		
	copy = new Body
		parent: @
		y: copy.maxY + 16
		x: copy.x
		width: 353
		text: "Your credit score is a overall rating of your financial history. The better your credit score, the more likely you are to get the best deals and interest rates. Get your free credit score every month and check it as often as you like!"
	
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
		description: "Get the best offers"
	
	copy = new H1
		parent: @
		x: 1069
		y: Screen.height * .280
		width: 353
		text: "We make finance simple"
		
	copy = new Body
		parent: @
		y: copy.maxY + 16
		x: copy.x
		width: 353
		text: "Your credit score is a overall rating of your financial history. The better your credit score, the more likely you are to get the best deals and interest rates. Get your free credit score every month and check it as often as you like!"
	
	@primaryCTA = new Button
		parent: @
		x: copy.x
		y: copy.maxY + 64
		width: 200
		text: "Get Started"

# Page 4

pages[4] = new Layer
	size: homeView.size
	backgroundColor: null
	
Utils.bind pages[4], ->
	
	_.assign @,
		shape: shapes[2]
		description: "Your monthly credit report"
	
	copy = new H1
		parent: @
		x: 393
		y: Screen.height * .280
		width: Screen.width / 5
		text: "We make finance simple"
		
	copy = new Body
		parent: @
		y: copy.maxY + 16
		x: copy.x
		width: 353
		text: "Your credit score is a overall rating of your financial history. The better your credit score, the more likely you are to get the best deals and interest rates. Get your free credit score every month and check it as often as you like!"
	
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

# Page 5

pages[5] = new Layer
	size: homeView.size
	backgroundColor: null
	
Utils.bind pages[5], ->
	
	_.assign @,
		description: "Your privacy   "
	
	copy = new H1
		parent: @
		x: 1069
		y: Screen.height * .280
		width: 353
		text: "We make finance simple"
		
	copy = new Body
		parent: @
		y: copy.maxY + 16
		x: copy.x
		width: 353
		text: "Your credit score is a overall rating of your financial history. The better your credit score, the more likely you are to get the best deals and interest rates. Get your free credit score every month and check it as often as you like!"
	
	@primaryCTA = new Button
		parent: @
		x: copy.x
		y: copy.maxY + 64
		width: 200
		text: "Get Started"

	
		
# Navigator

navigation = new Layer
# 	parent: homeView
	x: Align.center()
	y: Align.bottom(-56)
	width: 1192
# 	width: 1024
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
	page = pages[0]
	
	diff = Math.abs(_.indexOf(pages, pager.currentPage) - _.indexOf(pages, page))
	return if diff is 0
	
	
	if Math.abs(diff) is 1
		pager.snapToPage(page, true, {time: .7})
		return
		
	homeView.animate
		opacity: 0
		options:
			time: .15
	
	Utils.delay .12, =>
		pager.snapToPage(page)
		Utils.delay .2, =>
			homeView.animate
				opacity: 1
				options:
					time: .3
	
	
navigation.buttons = pages[1...].map (page, i) ->
	button = new Layer
		parent: navigation
		height: navigation.height
		x: 28 + (_.last(navigation.children)?.maxX ? 0)
# 		x: (navigation.width / pages.length) * i
		backgroundColor: white
	
	Utils.bind button, ->
		circle = new Layer
			parent: @
			height: 28
			width: 28
			borderRadius: 32
			x: 16
			y: Align.center()
			borderWidth: 1
			borderColor: black
			backgroundColor: null
		
		number = new Body2
			parent: circle
			text: i + 1
			x: Align.center(1)
			y: Align.center(1)
			
		copy = new Body2
			parent: button
			x: circle.maxX + 24
			y: Align.center()
# 			fontSize: 24
			text: page.description
			
		button.width = copy.maxX
	
		@onTap -> 
			diff = Math.abs(_.indexOf(pages, pager.currentPage) - _.indexOf(pages, page))
			return if diff is 0
			
			
			if Math.abs(diff) is 1
				pager.snapToPage(page, true, {time: .7})
				return
				
			homeView.animate
				opacity: 0
				options:
					time: .15
			
			Utils.delay .12, =>
				pager.snapToPage(page)
				Utils.delay .2, =>
					homeView.animate
						opacity: 1
						options:
							time: .3
	
	return button
		
# Utils.distribute(
# 	navigation.buttons, 
# 	'x',
# 	80, 
# 	(navigation.width - 80) - (_.last(navigation.children).width)
# 	)

# Top Links

topLinks = new Layer
# 	parent: homeView
	y: 56
	width: 580
# 	width: (Screen.width * .28)
	height: 64
	backgroundColor: white
	borderRadius: 64
	shadowY: 6
	shadowBlur: 12
	borderWidth: 2
	borderColor: "#efefef"
	shadowColor: "rgba(0,0,0,.16)"
	clip: true

topLinks.midX = shapes[0].x


topLinks.buttons = [
	"Benefits"
	"Learn"
	"About us"
	"Talk to us"
	"Sign in"
	].map (link, i) ->
	button = new Layer
		parent: topLinks
		height: topLinks.height
		x: 41 + (_.last(topLinks.children)?.maxX ? 0) + 16
# 		x: (navigation.width / pages.length) * i
		backgroundColor: white
	
	Utils.bind button, ->
		copy = new Body2
			parent: button
			x: 0
			y: Align.center()
# 			fontSize: 24
			text: link
			
		button.width = copy.maxX
	
		@onTap -> null
		
	return button
	
		
# Utils.distribute(
# 	topLinks.buttons, 
# 	'x',
# 	80, 
# 	(topLinks.width - 80) - (_.last(topLinks.children).width)
# 	)

# Logo

logo = new Layer
	width: 168
	height: 22
	image: "images/logo.png"
	x: 393
	y: 86

for page in pages
	pager.addPage(page)
	
pager.snapToPage(pages[0])
pages[0].shape.visible = true
