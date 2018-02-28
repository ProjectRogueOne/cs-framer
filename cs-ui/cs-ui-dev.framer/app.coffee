require "gotcha/gotcha"
require 'cs'

# Setup

Canvas.backgroundColor = '#000'

# ----------------
# custom stuff

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

# View 
view = new View
# super special page transition component

ptc = new PageTransitionComponent
	parent: view
	size: view.size
	scrollHorizontal: false
	brightness: 80
	yOffset: 0

containers = []

for i in _.range(3)
	container = ptc.newPage
		name: if i is 1 then 'special' else '.'
		size: view.size
		backgroundColor: null
		grid: if i is 0 then true else false
		hueRotate: i * 45
	
	ptc.on "change:currentPage", (page) =>
		page.saturate = 100
		for sib in page.siblings
			sib.saturate = 0
			
	containers.push(container)
	
cellSheet = new Layer
	size: view.size
	parent: ptc
	backgroundColor: null

cellSheet.placeBehind(ptc.content)

Utils.build cellSheet, ->
	
	# page 1
	
	title = new H1
		name: 'title'
		parent: @
		x: Align.center()
		y: Align.center(-84)
		text: 'Scroll Transition Component Test'
		
	
	# page 2
		
	circle = new Layer
		parent: @
		name: "circle"
		borderWidth: 1
		borderColor: '#00f49c'
		backgroundColor: null
		borderRadius: 99999
		width: Screen.width / 3
		height: Screen.width / 3
		x: Align.center()
		clip: true
		opacity: 0
	
	circle.midY = @midY - 160
	
	photo = new Layer
		name: 'photo'
		parent: circle
		width: Screen.height
		height: Screen.height * 4896/3264
		image: "images/mink-mingle-233730.jpg"
		y: Align.center()
		x: Align.center()
		scale: .6
		originX: .5
		originY: .5
		opacity: 1
	
	button = new Button
		parent: @
		name: 'button'
		y: 260
		height: 64
		borderRadius: 8
		x: Align.center() 
		y: 500
		opacity: 0
		
	# page 1
	page1 = ptc.content.children[0]
	page2 = ptc.content.children[1]

	# transition states
	# references are to the layer's names, so layers must be named! 
	# (e.g. myLayer should have name "myLayer")
	
	page1.transitionStates =
		title: 
			opacity: [0, 1, 1, 0]
	
	page2.transitionStates =
		button: 
			opacity: [0, 1, 1, 0]
			y: [600, 500, 500, 400]
		circle: 
			opacity: [0, 1, 1, 0]
			width: [250, 200, 200, 100]
			height: [250, 200, 200, 100]
			midX: [@midX, @midX, @midX, @midX]
			midY: [@midY - 160, @midY - 160, @midY - 160, @midY - 160]
		photo:
			scale: [1, .8, .28, .28]

ptc.snapToPage(ptc.content.children[0])
		
title = new H2
	parent: ptc
	text: 'Page Transition Component'
	x: 16
	y: 16
	width: ptc.width - 32
	color: '#000'

app.showNext(view)

