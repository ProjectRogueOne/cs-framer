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

# Row Link

class RowLink extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			text: 'Hello world'
			width: Screen.width - 32
			x: 16
			link: null
			backgroundColor: null
		
		super options
		
		_.assign @,
			link: options.link
			
		# layers
		
		@linkLayer = new H4Link
			parent: @
			x: 12
			text: options.text
			color: if @link then yellow80
		
		@height = @linkLayer.height
			
		if @link?
			
			@linkLayer.onSelect (event) =>
				app.showNext(@link)
		


# Components

# InfoIcon

class InfoIcon extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: 'Info Icon'
			size: 48
			borderRadius: 24
			backgroundColor: null
			color: grey
			
			text: 'More information about this input.'
			

		super options
		
		# Layers
		
		@iconLayer = new Icon
			parent: @
			icon: 'information-outline'
			x: Align.right(-12)
			y: 16
			color: @color
		
		@tooltipLayer = new Tooltip 
			parent: @
			y: 0
			x: Align.right(-72)
			direction: 'below'
			text: options.text
		
		
		# Definitions
		
		Utils.define @, "tooltip", false, @_showTooltip
		
		# Events
		
		@onMouseOver => @tooltip = true
		@onMouseOut => @tooltip = false
		
		@onTouchStart => @tooltip = false
		
	_showTooltip: (bool) =>
		if bool
			# showing tooltip 
			@bringToFront()
			@tooltipLayer.bringToFront()
			_.assign @tooltipLayer, 
				visible: true
				parent: null
				x: Align.right(-8)
				y: @screenFrame.y + @height + 4
				
			@tooltipLayer.diamond.x = Align.right(-16)
			return
		
		# hiding tooltip
		_.assign @tooltipLayer, 
			visible: false
			parent: @

# Info Container

class InfoContainer extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			x: 16
			width: Screen.width - 32
			height: 56
			clip: true
			color: grey
			backgroundColor: null
			animationOptions:
				time: .2
			
			text: 'We use this to find your best offers. Learn more.'
		
		super options
		
		_.assign @,
			minHeight: @height
			maxHeight: undefined
		
		@iconLayer = new Icon
			parent: @
			icon: 'information-outline'
			x: Align.right()
			y: 16
			color: @color
		
		@textLayer = new Body2
			parent: @
			y: 42
			width: @width
			textAlign: 'left'
			text: options.text
			opacity: 0
			animationOptions:
				time: .2
			
		@maxHeight = @textLayer.maxY + 16
		
		# definitions
		
		Utils.define @, 'opened', false, @_showOpened
		
		# Events
		
		@iconLayer.onTap => @opened = !@opened
		
	_showOpened: (bool) =>
		if bool
			# show opened 
			@animate
				height: @maxHeight 
			@textLayer.animate
				opacity: 1
			return 
	
		@animate 
			height: @minHeight
		@textLayer.animate
			opacity: 0

# Info Modal

class InfoModal extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			color: grey80
			size: 64
			backgroundColor: 'rgba(0,0,0,0)'
			options: [
				{
					title: 'Who do you bank with?'
					body: 'We use this information to connect you with personalised offers. [Learn more].'
				}, 
				{
					title: "What's that supposed to mean?"
					body: "Better friends, better deals. They say that you are the sum of the last ten people you've had lunch with. We need to know your social network in order to assure our partners that you run with a good crowd. [Learn more]."
				},
				{
					title: 'What are your fears?'
					body: "We use your fears to better match our coaching to your personality. Don't like spiders? We'll leave that part out. [Learn more]."
				},
			
			]
			animationOptions:
				time: .5
		
		super options
		
		@modalWindow = new Layer
			backgroundColor: white
			opacity: 1
			x: 12
			width: Screen.width - 24			
			height: Screen.height - (app.header?.height + app.footer?.height) - 96
			borderRadius: 4
			originX: 1
			originY: 1
			clip: true
			shadowY: 2
			shadowBlur: 6
			shadowColor: 'rgba(0,0,0,.24)'
			visible: false
			animationOptions:
				time: .35
				
		Utils.bind @modalWindow, ->
			
			title = new H4
				parent: @
				x: Align.center()
				y: 16
				color: blue
				text: 'Questions about our Questions?'
				
# 			@close = new Icon
# 				icon: 'close'
# 				parent: @
# 				x: Align.right(-16)
# 				y: 15
# 				color: grey
			
# 			info = new Icon
# 				icon: 'information-variant'
# 				parent: @
# 				x: 16
# 				y: 10
# 				size: 28
# 				color: black
			
			@scrollComponent = new ScrollComponent
				parent: @
				y: 56
				width: @width
				height: @height - 56
				scrollHorizontal: false
				contentInset:
					bottom: 40
				
			for option, i in options.options
				title = new H5
					parent: @scrollComponent.content
					x: 16
					y: (last?.maxY ? -12) + 24
					width: @width - 32
					text: option.title
					
				body = new Body 
					parent: @scrollComponent.content
					y: title.maxY + 4
					x: 16
					width: @width - 32
					text: option.body
				
				div = new Layer
					parent: @scrollComponent.content
					x: 16
					y: body.maxY + 24
					width: @width - 32
					height: 1
					backgroundColor: grey40
				
				body._elementHTML.innerHTML = _.replace(body._elementHTML.innerHTML, "[", "<u>")
				body._elementHTML.innerHTML = _.replace(body._elementHTML.innerHTML, "]", "</u>")
				
				last = div
			
			if div.maxY < @scrollComponent.height - 16
				@scrollComponent.scrollVertical = false
				@scrollComponent.height = div.maxY + 32
				@height = @scrollComponent.height + 56
			
			@maxY = (app.footer?.y ? Screen.height) - 72 
			
			footerScrim = new Layer
				parent: @
				width: @width
				y: Align.bottom(-32)
				height: 32
				gradient:
					start: 'rgba(255,255,255,1)'
					end: 'rgba(255,255,255,0)'
				
			footer = new Layer
				parent: @
				width: @width
				y: Align.bottom
				height: 32
				backgroundColor: white
			
			div.destroy()
			
		# icon
		
		@infoIcon = new Layer
			parent: @
			x: Align.right(-8)
			y: Align.bottom(-16)
			color: @color
			size: 40
			backgroundColor: white
			borderRadius: 20
			borderWidth: 1
			borderColor: grey30
			shadowY: 2
			shadowBlur: 3
			shadowColor: 'rgba(0,0,0,.16)'
			animationOptions:
				time: .15
				
		@infoIconIcon = new Icon
			parent: @infoIcon
			point: Align.center(1)
			color: @color
			size: 24
			icon: 'information-variant'
			
			
		
		@startProps = @props
		
		# definitions
		
		Utils.define @, 'opened', false, @_showOpened
		
		# events 
		
# 		@modalWindow.close.onTap => @opened = false
		
		@onTap => @opened = !@opened
	
	_showOpened: (bool) =>
		if bool 
			# show opened 
			@props =
				height: Screen.height - 114
				width: Screen.width
				x: 0
				y: app.header?.maxY
			
			@infoIcon.props =
				x: Align.right(-8)
				y: Align.bottom(-24)
				
			@infoIcon.animate
				borderColor: grey70
				shadowColor: 'rgba(0,0,0,.2)'
			
			@infoIconIcon.icon = 'close'
			
			@animate
				backgroundColor: 'rgba(0,0,0,.3)'
			
			y = @modalWindow.y
			
			@modalWindow.props =
				opacity: 0
				visible: true
				scale: .6
				y: y + 48
			
			@modalWindow.animate
				opacity: 1
				visible: true
				scale: 1
				y: y
		
			return 
		
		# show closed
		@infoIcon.animate
			borderColor: grey40
			shadowColor: 'rgba(0,0,0,.16)'
				
		@infoIconIcon.icon = 'information-variant'
			
		@animate
			backgroundColor: 'rgba(0,0,0,0)'
			options:
				time: .2
		
		@once Events.AnimationEnd, =>
			@props = 
				height: @startProps.height 
				width: @startProps.width 
				x: @startProps.x
				y: @startProps.y
				backgroundColor: 'rgba(0,0,0,0)'
				
			@infoIcon.props =
				parent: @
				x: Align.right(-8)
				y: Align.bottom(-18)
		
		@modalWindow.once Events.AnimationEnd, =>
			@modalWindow.visible = false
			
		@modalWindow.animate
			opacity: 0
			scale: .6
			options:
				time: .2


# ----------------
# App

app = new App
	chrome: 'safari'
	title: 'www.clearscore.com'

# Home View

homeView = new View
	title: 'Registration'
	backgroundColor: '#f1f1f1'
# 	scrollVertical: false

Utils.bind homeView.content, ->
	
	banksArray = [
		'Lloyds Bank',
		'Barclays',
		'HSBC',
		"Joey the Shark",
		"Wild Jen's Ca$h n' Løans",
		"Bitcoin",
		]
	
	# header and puller 
	
	header = new Layer
		parent: @
		height: 70
		image: 'images/2-header-m.png'
	
	header.props = 
		x: 0, y: 0
		width: @width
		
	puller = new Layer
		parent: @
		height: 91
		height: 100
		image: 'images/puller.png'
	
	puller.props = 
		x: 0, y: header.maxY
		width: @width
	
	# static copy
	
	title = new TextLayer 
		name: 'Title'
		parent: @
		fontSize: 18
		color: black
		y: puller.maxY + 35
		text: 'Who do you bank with?'
	
	infoContainer = new Body2
		parent: @
		x: 16
		y: title.maxY + 4
# 		color: black30
		text: 'We use this to find your best offers. Learn more.'
		
	input = new Select 
		parent: @
		y: infoContainer.maxY + 10
		width: @width - 32
		placeholder: 'Please select your bank.'
		options: banksArray
			
	Utils.pin input, infoContainer, 'bottom'
	
	# info icon
	
	title = new TextLayer 
		name: 'Title'
		parent: @
		fontSize: 18
		color: black
		y: input.maxY + 35
		text: 'Who do you bank with?'
		
	input = new Select 
		parent: @
		y: title.maxY + 20
		width: @width - 32
		placeholder: 'Please select your bank.'
		options: banksArray
	
	infoIcon = new InfoIcon
		parent: @
		x: Align.right(-4)
		y: title.y - 16
		text: 'We use this to find your best offers.'
	
	
	# info container
	
	title = new TextLayer 
		name: 'Title'
		parent: @
		fontSize: 18
		color: black
		y: input.maxY + 35
		text: 'Who do you bank with?'
	
	infoContainer = new InfoContainer
		parent: @
		x: 16
		y: title.y - 16
		
	input = new Select 
		parent: @
		y: title.maxY + 20
		width: @width - 32
		placeholder: 'Please select your bank.'
		options: banksArray
			
	Utils.pin input, infoContainer, 'bottom'
	
homeView.updateContent()

# Intro View

introView = new View
	title: 'Registration'
	backgroundColor: '#f1f1f1'
# 	scrollVertical: false

inputTrigger = undefined

Utils.bind introView.content, ->
	
	# question 
	
	header = new Layer
		parent: @
		height: 70
		image: 'images/2-header-m.png'
	
	header.props = 
		x: 0, y: 0
		width: @width
		
	puller = new Layer
		parent: @
		height: 91
		height: 100
		image: 'images/puller.png'
	
	puller.props = 
		x: 0, y: header.maxY
		width: @width
	
	# question
	
	title = new TextLayer 
		name: 'Title'
		parent: @
		fontSize: 18
		color: black
		y: puller.maxY + 35
		text: 'Do you have any scars or tattoos?'
		
	inputTrigger = new TextInput 
		parent: @
		y: title.maxY + 20
		width: @width - 32
		placeholder: 'Please describe your identifiable marks.'
	
	inputTrigger.on "change:value", (value) =>
		button.disabled = value.length < 10
	
	button = new Button
		parent: @
		x: 16
		y: inputTrigger.maxY + 45
		borderRadius: 4
# 		color: white
# 		backgroundColor: "#0492bd"
		text: 'Continue'
		width: @width - 32
		disabled: true
	
	button.onSelect -> app.showNext(modalView)
	
introView.updateContent()
	
		
# info modal 
infoModal1 = new InfoModal
	parent: introView
	x: Align.right()
	y: Align.bottom(-48)
	options: [
		{
			title: 'Do you have any scars or tattoos?'
			body: "Fin-tech can be a dangerous place. It's important that we have a way to identify you should things go very, very wrong. [Learn more]."
		}
	]

Utils.delay 2, =>
	tooltip = new Tooltip
		parent: introView
		direction: 'left'
		text: 'Questions about our questions?'
		x: Align.right(-80)
		y: infoModal1.y + 4
		originX: 1
		scale: .8
		opacity: 0
	
	tooltip.animate
		scale: 1
		opacity: 1
		
	infoModal1.onTap =>
		tooltip?.animate
			scale: .6
			opacity: 0
			
		Utils.delay 1, =>
			toolTip?.destroy()

# Modal View

modalView = new View
	title: 'Registration'
	backgroundColor: '#f1f1f1'
# 	scrollVertical: false

Utils.bind modalView.content, ->
	
	banksArray = [
		'Lloyds Bank',
		'Barclays',
		'HSBC',
		"Joey the Shark",
		"Wild Jen's Ca$h n' Løans",
		"Bitcoin",
		]
	
	# question 
	
	header = new Layer
		parent: @
		height: 70
		image: 'images/2-header-m.png'
	
	header.props = 
		x: 0, y: 0
		width: @width
		
	puller = new Layer
		parent: @
		height: 91
		height: 100
		image: 'images/puller.png'
	
	puller.props = 
		x: 0, y: header.maxY
		width: @width
	
	# question
	
	title = new TextLayer 
		name: 'Title'
		parent: @
		fontSize: 18
		color: black
		y: puller.maxY + 35
		text: 'Who do you bank with?'
		
	select = new Select 
		parent: @
		y: title.maxY + 20
		width: @width - 32
		options: banksArray
	
	# question
	
	title = new TextLayer 
		name: 'Title'
		parent: @
		fontSize: 18
		color: black
		y: select.maxY + 35
		text: "What's that supposed to mean?"
		
	select = new Select 
		parent: @
		y: title.maxY + 20
		width: @width - 32
		options: [
			'Nothing, nevermind'
			'You heard me'
			'I think you know'
			'Sorry, um, oops.'
			]
	
	
	# question
	
	title = new TextLayer 
		name: 'Title'
		parent: @
		fontSize: 18
		color: black
		y: select.maxY + 35
		text: 'What are your fears?'
		
	input = new Select 
		parent: @
		y: title.maxY + 20
		width: @width - 32
		placeholder: 'Please select your bank.'
		options: [
			'Spiders'
			'Snakes'
			'Heights'
			'Identity theft'
			'Bitcoin'
			]
		
# info modal 
infoModal = new InfoModal
	parent: modalView
	x: Align.right()
	y: Align.bottom(-48)
	
modalView.updateContent()

app.showNext homeView
app.showNext modalView
app.showNext introView
