require "gotcha/gotcha"
require 'cs'

# Template for iOS / Safari Prototypes


# Setup

Canvas.backgroundColor = '#000'

# ----------------
# custom stuff

# Slide Carousel
slideCarousel = (parent) ->
	return (
	
		fullLayer = => 
			l = new Layer
				width: Screen.width
				height: Screen.width * .812
				borderRadius: 32
				image: Utils.randomImage()
				
			l._element.style['box-shadow'] = 'inset 0 0 8px 8px #080808'
			
			return l
		
		darkContainer = new Layer 
			parent: parent.content 
			backgroundColor: '#080808'
		
		darkContainer.props =
			width: parent.width
			x: 0
			y: 48
			height: (Screen.width * .812) + 32
		
		carousel = new Carousel
			parent: parent.content
			y: 64
			x: Align.center()
			width: parent.width - 32
			pages: [fullLayer(), fullLayer(), fullLayer(), fullLayer(), fullLayer()]
			scaleScale: 0
			padding: 16
			
		carousel.displayPage = (
			page, 
			carousel, 
			index, 
			difference,
			distance, 
			angle, 
			opacity,
			scale,
			animate = true,
			hidden = false) ->
				
			props = 
				opacity: opacity
				midX: carousel.width / 2 + (difference * (page.width + carousel.padding))
				originY: carousel.originY
				options: carousel.animationOptions
	
			if animate
				do (page, props) ->
					carousel.animate
						scale: .7
						options: 
							time: .35
							
					carousel.once Events.AnimationEnd, -> 
						page.animate props
						page.once Events.AnimationEnd, -> 
							carousel.animate
								scale: 1
								options: 
									time: .5
									
							page.visible = true
				
				if hidden
					page.visible = false
				
				return
	
			page.props = props
			if page is carousel.currentPage then @emit "rotateEnd", carousel.currentPage
		)


# ----------------
# data

# User

user =
	name: 'Charlie Rogers'
	age: 28
	sex: Utils.randomChoice(['female', 'male', 'nonbinary'])
	date: new Date


# ----------------
# implementation

app = new App
# 	safari: false
	
SHOW_ALL = true

# Home View
homeView = new View
	padding: {top: 40}
	title: 'Home'

Utils.build homeView, ->
	return if !SHOW_ALL
		
	ColorsComponentsButton = new Button 
		parent: @content
		x: Align.center()
		text: 'Colors'
		select: -> app.showNext(colorsView)
	
	TextComponentsButton = new Button 
		parent: @content
		x: Align.center()
		text: 'Text Components'
		select: -> app.showNext(textView)
		
	ButtonComponentsButton = new Button 
		parent: @content
		x: Align.center()
		text: 'Button'
		select: -> app.showNext(buttonView)
		
	CardComponentsButton = new Button 
		parent: @content
		x: Align.center()
		text: 'Card'
		select: -> app.showNext(cardView)
	
	for layer, i in @content.children
		_.assign layer, 
			width: 200
			x: Align.center()
			y: (last?.maxY ? 16) + 16
			
		last = layer

# Colors View

colorsView = new View
	title: 'Colors'
	
Utils.build colorsView, ->
	return if !SHOW_ALL
	
	# added to window anyway... but we'll bring it in here
	{ Colors } = require 'cs-components/Colors'
	
	colors = _.entries(Colors).map (color) =>
		chip = new Layer
			name: color[0]
			parent: @content
			x: 16
			width: (@width - 48) / 2
			height: 64
			backgroundColor: color[1]
			borderWidth: 1
			borderColor: new Color(color[1]).darken(10)
			
		new Body3
			parent: chip
			text: color[0]
			x: 8
			y: Align.bottom(-4)
			color: color[1]
			invert: 100
		
		new Body3
			parent: chip
			text: color[1]
			x: Align.right(-8)
			y: Align.bottom(-4)
			color: color[1]
			invert: 100
			
		return chip
	
	Utils.grid(colors, 2, 16, 16).height

	Utils.delay 0, @updateContent

# Text View

textView = new View
	title: 'Text Components'
	
Utils.build textView, ->
	return if !SHOW_ALL
	
	#donuts
	
	DonutExample = new Donut
		parent: @content
		text: 'Donut 1'
		
	DonutExample2 = new Donut2
		parent: @content
		text: 'Donut 2'
	
	# heading 1
	
	h1Example = new H1
		parent: @content
		text: 'Header 1'
	
	h1Light = new H1
		parent: @content
		text: 'Header 1'
		fontWeight: '300'
	
	# heading 2
		
	h2Example = new H2
		parent: @content
		text: 'Header 2'
	
	h2Light = new H2
		parent: @content
		text: 'Header 2'
		fontWeight: '300'
		
	# Body
	
	BodyExample = new Body
		parent: @content
		text: 'Body1'
	
	BodyLight = new Body
		parent: @content
		text: 'Body1'
		fontWeight: '300'
		
	Body2Example = new Body2
		parent: @content
		text: 'Body2'
	
	Body2Light = new Body2
		parent: @content
		text: 'Body2'
		fontWeight: '300'
	
	Body3Example = new Body3
		parent: @content
		text: 'Body3'
	
	Body3Light = new Body3
		parent: @content
		text: 'Body3'
		fontWeight: '300'
		
	Body4Example = new Body4
		parent: @content
		text: 'Body4'
	
	Body4Light = new Body4
		parent: @content
		text: 'Body4'
		fontWeight: '300'
		
	LinkExample = new Link
		parent: @content
		text: 'Link'
		
	LinkExample.onSelect => print 'hi!'
		
	for layer, i in @content.children
		if i > 1
			offset = 16 - (i % 2 * 12)
		layer.y = (last?.maxY ? 16) + (offset ? 16)
		last = layer

# Card View

cardView = new View
	title: 'Text Components'
	
Utils.build cardView, ->
	return if !SHOW_ALL
	
	cardTypes = ['shapeup', 'savings', 'protect', 'play', 'mortgages', 'maximise', 'carfinance', 'build']
	
	offerTypes = ['carloans', 'creditcards', 'energy','insurance', 'loans', 'mortgages']
	
	flags = ['recommended', 'active', 'comingsoon']

	
	coachingCards = _.map cardTypes, (iconName, i) =>
		return new Card
			parent: @content
			icon: iconName
			x: Align.center()
			flag: _.sample(flags)
			
	offerCards = _.map offerTypes, (iconName, i) =>
		card = new Card
			parent: @content
			icon: iconName
			state: 'offers'
			x: Align.center()
			
		card.frontCTA.text = 'Find offers'
		
		return card
			
	cards = _.concat(coachingCards, offerCards)
			
	Utils.grid(cards, 1, 16)
	Utils.delay .1, => @updateContent()

# Text View

textView = new View
	title: 'Text Components'
	
Utils.build textView, ->
	return if !SHOW_ALL
	
	{ styles } = require 'cs-components/Typography'
	
	#donuts
	
	DonutExample = new Donut
		parent: @content
		text: 'Donut 1'
		
	DonutExample2 = new Donut2
		parent: @content
		text: 'Donut 2'
	
	# heading 1
	
	h1Example = new H1
		parent: @content
		text: 'Header 1'
	
	h1Light = new H1
		parent: @content
		text: 'Header 1'
		fontWeight: '300'
	
	# heading 2
		
	h2Example = new H2
		parent: @content
		text: 'Header 2'
	
	h2Light = new H2
		parent: @content
		text: 'Header 2'
		fontWeight: '300'
		
	# Body
	
	BodyExample = new Body
		parent: @content
		text: 'Body1'
	
	BodyLight = new Body
		parent: @content
		text: 'Body1'
		fontWeight: '300'
		
	Body2Example = new Body2
		parent: @content
		text: 'Body2'
	
	Body2Light = new Body2
		parent: @content
		text: 'Body2'
		fontWeight: '300'
	
	Body3Example = new Body3
		parent: @content
		text: 'Body3'
	
	Body3Light = new Body3
		parent: @content
		text: 'Body3'
		fontWeight: '300'
		
	Body4Example = new Body4
		parent: @content
		text: 'Body4'
	
	Body4Light = new Body4
		parent: @content
		text: 'Body4'
		fontWeight: '300'
		
	LinkExample = new Link
		parent: @content
		text: 'Link'
		
	LinkExample.onSelect => print 'hi!'
		
	for layer, i in @content.children
		if i > 1
			offset = 16 - (i % 2 * 12)
		layer.y = (last?.maxY ? 16) + (offset ? 16)
		last = layer

# Button View

buttonView = new View
	padding: {top: 40}
	title: 'Text Components'

Utils.build buttonView, ->
	return if !SHOW_ALL
	
	# light buttons
	
	button = new Button 
		parent: @content
		x: Align.center()
		select: -> button1.disabled = !button1.disabled
	
	button1 = new Button 
		parent: @content
		x: Align.center()
		disabled: true
	
	# dark buttons
		
	button2 = new Button 
		parent: @content
		x: Align.center()
		dark: true
		select: -> button3.disabled = !button3.disabled
	
	button3 = new Button 
		parent: @content
		x: Align.center()
		dark: true
		disabled: true
		
	# light buttons secondary
	
	button4 = new Button 
		parent: @content
		x: Align.center()
		secondary: true
		select: -> button5.disabled = !button5.disabled
	
	button5 = new Button 
		parent: @content
		x: Align.center()
		secondary: true
		disabled: true
	
	# dark buttons secondary
		
	button6 = new Button 
		parent: @content
		x: Align.center()
		secondary: true
		dark: true
		select: -> button7.disabled = !button7.disabled
	
	button7 = new Button 
		parent: @content
		x: Align.center()
		secondary: true
		dark: true
		disabled: true
		
	for layer, i in @content.children
		layer.y = (last?.maxY ? 16) + 16
		last = layer
		
	scrim = new Layer
		parent: @content
		y: button2.y - 8
		width: @width
		height: (button3.maxY + 8) - (button2.y - 8)
		backgroundColor: midnightBlue
		
	scrim.sendToBack()
		
	scrim = new Layer
		parent: @content
		y: button6.y - 8
		width: @width
		height: (button3.maxY + 8) - (button2.y - 8)
		backgroundColor: midnightBlue
	
	scrim.sendToBack()


app.showNext(homeView)