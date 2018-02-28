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
	backgroundColor: white
# 	scrollVertical: false

Utils.bind homeView, ->
	
	header = new Layer
		parent: @
		y: app.header?.height
		height: 60
		width: @width
		image: 'images/Header.png'
		
	@contentInset =
		top: header.maxY + 16
		bottom: 100
	

Utils.bind homeView.content, ->
	
	topCopy = new H3
		parent: @
		text: "Let's stay in touch"
		y: 35
		x: 20
	
	topLead = new Body2
		parent: @
		y: topCopy.maxY + 45
		x: 20
		width: @width - 60
		text: "If you'd like to continue receiving e-mails from us, please read below and confirm your address."
# 		textAlign: 'center'
		
	bottomLead = new Body2
		parent: @
		y: topLead.maxY + 15
		x: 20
		text: "We'll send you three kinds of email:"
		
	# updates
		
	title = new H4 
		parent: @
		y: bottomLead.maxY + 30
		x: 20
		width: @width - 40
		text: "Updates and Security"
		
	label = new Body2
		parent: @
		y: title.maxY + 5
		x: 20
		width: @width - 40
		text: "When your score changes, or if there's any issue with your account's security, we'll let you know."
	
	# content
		
	title = new H4 
		parent: @
		y: label.maxY + 25
		x: 20
		width: @width - 40
		text: "News and content"
		
	label = new Body2
		parent: @
		y: title.maxY + 10
		x: 20
		width: @width - 40
		text: "We'll send you tips and advice for improving your credit score and financial well-being."
	
	# offers
		
	title = new H4 
		parent: @
		x: 20
		y: label.maxY + 25
		width: @width - 40
		text: "Personal offers"
		
	label = new Body2
		parent: @
		y: title.maxY + 10
		x: 20
		width: @width - 176
		text: "Your personalised offers are always the best we can find for you and your current credit score."
	
	@offersToggle = new Toggle
		parent: @
		x: 20
		y: title.y + 10
		options: ['No', 'Yes']
	
	@offersToggle.x = Align.right(-20)
	
	miniLabel = new Body3 
		parent: @
		x: @offersToggle.x
		y: @offersToggle.maxY + 8
		width: @offersToggle.width
		textAlign: 'center'
		fontWeight: 'bold'
		text: 'Still want your offers?'
		
	miniLabel.maxY = label.maxY
	
	
	
	# email
	
	label = new H4 
		parent: @
		y: label.maxY + 35
		text: 'Your current e-mail'
		
	sublabel = new Body2
		parent: @
		y: label.maxY + 10
		text: "Care to clearly confirm your that your e-mail is still current?"
		
	
	@emailInput = new TextInput 
		parent: @
		x: 15
		y: sublabel.maxY + 15
		width: @width - 32
		placeholder: 'clarice.scorinson@700-or-bust.com'
	
	@submitButton = new Button 
		parent: @
		x: 15
		y: @emailInput.maxY + 10
		width: @width - 32
		text: 'Send me a confirmation e-mail'
		
	nothanks = new Body3
		parent: @
		x: 15
		textAlign: 'center'
		y: @submitButton.maxY + 30
		width: @width - 60
		text: "Not interested? You can _skip this step_, but you really won't hear from us again until you change your account settings."
	
homeView.updateContent()

# Intro (1.0.0)

# Returning Intro (1.1.0)

# Basics (2.0.0)

# Offers (3.0.0)

# Verify (4.0.0)

# Re-enable (5.0.0)

app.showNext homeView
