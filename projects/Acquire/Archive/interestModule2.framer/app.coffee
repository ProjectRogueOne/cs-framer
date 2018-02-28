# Template for iOS Prototypes
require 'cs'

# # Setup
# 
# require 'moreutils'
# { Icon } = require 'Icon'
# 
# Framer.Extras.Hints.disable()
# Framer.Extras.Preloader.disable()
# Screen.backgroundColor = '#eee'

# ----------------
# custom stuff

# Menu Item

class MenuItem extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			icon: 'creditCards'
			text: 'Credit cards'
			showLabel: true
			active: false
			height: 40
			backgroundColor: null
			animationOptions:
				time: .8
				curve: 'spring-rk4'
				curveOptions:
					tension: 430
					friction: 25
					velocity: 15
		
		@startY = options.y
		
		super options
		
		# layers

		@iconLayer = new Layer
			name: options.icon + ' icon'
			parent: @
			size: 40
			borderRadius: 20
		
		@textLayer = new Body
			parent: @
			name: options.text + ' text'
			x: @iconLayer.maxX + 12
			y: Align.center(3)
			text: options.text
		
		@width = @textLayer.maxX
		
		# definitions 
		
		Utils.define @, 'showLabel', options.showLabel, @_updateLabel
		Utils.define @, 'icon', options.icon
		Utils.define @, 'active', options.active, @_showActive
		
		# events
		
		@onTap => @active = !@active
	
	_updateLabel: (bool) =>
		if bool 
			# show layer
			@textLayer.animate
				opacity: 1
				options:
					time: .25
			return
		
		# hide layer 
		@textLayer.animate
			opacity: 0
			options:
				time: .25
	
	_showActive: (bool) =>
		if bool
			# show active
			@iconLayer.image = "images/#{@icon}_active.svg"
			return
		
		# show inactive
		@iconLayer.image = "images/#{@icon}.svg"
		return

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

				

# Home View
homeView = new View
	padding: {left: 0, top: 0, right: 0, bottom: 0}
	title: 'Home'

Utils.build homeView.content, ->
	
	@title = new H2
		parent: @
		y: 56
		x: Align.center()
		fontSize: 24
		textAlign: 'center'
		text: 'What are you \n interested in?'
		
	@lead = new H2
		parent: @
		y: @title.maxY + 16
		x: Align.center
		fontWeight: 300
		width: @width - 48
		text: "Tell us where you’d like to save and we can show you the best offers."
		textAlign: 'center'
		
	items =
		creditCards: 
			text: 'Credit Cards'
			title: "How to save money\n on credit cards"
			body: "You can easily save money on your Credit Cards by transfering your short term debt or by signing up for a low APR card. For more information on how you can save money, including the best offers, sign up below."
		loans:  
			text: 'Loans'
			title: "How to save money\n on loans"
			body: "You can easily save money on your Credit Cards by transfering your short term debt or by signing up for a low APR card. For more information on how you can save money, including the best offers, sign up below."
		carInsurance:  
			text: 'Car Finance'
			title: "How to save money\n on car insurance"
			body: "You can easily save money on your Credit Cards by transfering your short term debt or by signing up for a low APR card. For more information on how you can save money, including the best offers, sign up below."
		mortgages:  
			text: 'Mortgages'
			title: "How to save money\n on mortgages"
			body: "You can easily save money on your Credit Cards by transfering your short term debt or by signing up for a low APR card. For more information on how you can save money, including the best offers, sign up below."
		energy:  
			text: 'Energy'
			title: "How to save money\n on energy"
			body: "You can easily save money on your Credit Cards by transfering your short term debt or by signing up for a low APR card. For more information on how you can save money, including the best offers, sign up below."
	
	last = undefined
	opened = false
	
	items = _.map _.shuffle(_.entries(items)), (item) =>
		menuItem = new MenuItem
			parent: @
			y: (last?.maxY ? @lead.maxY + 24) + 24
			x: Align.center
			icon: item[0]
			text: item[1].text
				
		menuItem.titleLayer = new H2
			parent: @
			y: 160
			x: 24
			fontSize: 24
			width: @width - 48
			textAlign: 'center'
			text: item[1].title
			opacity: 0
			
		menuItem.leadLayer = new H2
			parent: @
			y: menuItem.titleLayer.maxY + 16
			x: Align.center
			fontWeight: 300
			width: @width - 48
			text: item[1].body
			textAlign: 'center'
			opacity: 0
			
		menuItem.cta = new Button
			parent: @
			y: menuItem.leadLayer.maxY + 32
			x: Align.center()
			text: 'Get started'
			opacity: 0
			height: 60
		
		menuItem.onTap ->
			for i in _.without(items, @)
				i.active = false
				for layer in [i.titleLayer, i.leadLayer, i.cta]
					layer.animate
						opacity: 0
						options:
							time: .25
						
			@active = true
			for layer, i in [@titleLayer, @leadLayer, @cta]
				layer.animate
					opacity: 1
					options:
						time: .45
						delay: .35 + (i * .05)
			
			if !opened
				openMenuItems()
		
		last = menuItem
		return menuItem
	
	maxWidth = _.maxBy(items, 'width').width
	Utils.align items, 'width', maxWidth
	Utils.align items, 'midX', @midX
	
	for item in items
		item.startX = item.x
		
	openMenuItems = =>
		fullWidth = _.sumBy(items, 'width')
		
		Utils.align items, 'showLabel', false
		Utils.align items, 'midY', @title.y, true
		Utils.distribute items, 'x', 32, @width - maxWidth/2, true
		
		for layer in [@title, @lead]
			layer.animate
				opacity: 0
				options:
					time: .5
					
	closeMenuItems = =>
		for item in items
			item.showLabel = true
			item.animate
				y: item.startY
				x: item.startX
			
			for layer in [item.titleLayer, item.leadLayer, item.cta]
				layer.animate
					opacity: 0
					options:
						time: .25
			
		for layer in [@title, @lead]
			layer.animate
				opacity: 1
				options:
					time: .5
					delay: .35
	
	@onDoubleTap closeMenuItems
	
		
	# get max width of all items and use that to center

app.showNext(homeView)
