require "gotcha/gotcha"
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
# Scroll Scene 


	
# ScrollScene

ScrollScene = (options = {}) ->
	
	_.defaults options,
		showY: true
	
	view = new View
	
	if options.showY
		scrollYLabel = new TextLayer
			y: Align.bottom
			x: Align.right
			width: Screen.width / 4
			backgroundColor: 'rgba(0,0,0,.9)'
			fontSize: 20
			height: 48
			fontWeight: 500
			color: '#FFF'
			fontFamily: 'Menlo'
			text: 'scrollY'
			textAlign: 'right'
			padding: {right: 16, top: 12}
			
		inLayersLabel = new TextLayer
			y: Align.bottom
			x: 0
			width: Screen.width / 4 * 3
			backgroundColor: 'rgba(0,0,0,.8)'
			height: 48
			fontSize: 20
			fontWeight: 500
			color: '#FFF'
			fontFamily: 'Menlo'
			text: 'Layers in view'
			padding: {left: 16, top: 12}
	
	Utils.build view, ->
		
		@content.backgroundColor = null
		@content.draggable.overdrag = false
		
		lowestLayer = new Layer
			parent: @content
			y: Screen.height
			height: Screen.height / 2
			opacity: 0
		
		@on "change:children", (children) ->
			lowestLayer.y = _.maxBy(children.added, 'maxY').maxY + 2000
			Utils.delay 0, => 
				@content.bringToFront()
				@updateContent()
				@setFactors()
		
		@setFactors = =>
			scrollY = @scrollY
			scrollYLabel?.text = scrollY.toFixed()
			
			inLayers = ''
			
			for layer in @children
				continue if not layer.enter
				
				Utils.build layer, ->
					if scrollY < @fadeIn
						@factor = 0
					else if scrollY >= @fadeOut
						@factor = 3
					else if _.inRange(scrollY, @fadeIn, @enter)
						@factor = Utils.modulate(scrollY, [@fadeIn, @enter], [0, 1])
					else if _.inRange(scrollY, @enter, @exit)
						@factor = Utils.modulate(scrollY, [@enter, @exit], [1, 2])
					else if _.inRange(scrollY, @exit, @fadeOut)
						@factor = Utils.modulate(scrollY, [@exit, @fadeOut], [2, 3])
					else
						@factor = null
						
					if @factor > 0
						inLayers += "#{@name}: #{@factor.toFixed(2)}, "
						
			inLayersLabel.text = _.trimEnd(inLayers, ', ')
		
		@onMove @setFactors
	
	return view


# SceneLayer

class SceneLayer
	constructor: (className, options = {}) ->

		options.factorProps ?= {}
		
		_.defaults options.factorProps,
			points: [0, 100, 200, 300]
			fade: undefined
			fadeIn: undefined
			fadeOut: undefined
			ignoreOpacity: false
			opacity: [0, 1, 1, 0]
		
		layer = new className options

		do (layer) ->
			
			# Three ways to set transition points...
			#
			# 1. Set hard points for fadeIn, enter, exit, fadeOut
			# 2. Set hard points for enter and exit, and relative values for fadeIn and fadeOut.
			# 	 fadeIn and fadeOut will be set to enter - fadeIn, exit + fadeOut
			# 3. Set hard points for enter and exit, and a single value (fade) for both fadeIn and fadeOut
			# 	 fadeIn and fadeOut will be set to enter - fade, exit + fade
			
			fade = options.factorProps.fade
			fadeIn = fade ? options.factorProps.fadeIn
			fadeOut = fade ? options.factorProps.fadeOut
						
			if fade?
				_.assign layer,
					fadeIn: options.factorProps.points[0] - (fadeIn ? 0)
					enter: options.factorProps.points[0]
					exit: options.factorProps.points[1]
					fadeOut: options.factorProps.points[1] + (fadeOut ? 0)
			else
				_.assign layer,
					fadeIn: options.factorProps.points[0]
					enter: options.factorProps.points[1]
					exit: options.factorProps.points[2]
					fadeOut: options.factorProps.points[3]
			
			
			# Define a property "factor" that emits "change:factor"
			Utils.define layer, "factor", 1
			
			# setFactorProps(props, [startF, endF])
			#
			# manually set a property to change, according to the layer's factor
			# @example
			# red.setFactorProps({height: [200, 400]}, 1, 1.5)
			
			# set an array of points to hit at a layer's factor points
			# @example
			# red.setFactorProps({height: [150, 200, 200, 250]})

			layer.setFactorProps = (props = {}, startF, endF) ->
				do (props) =>
					@on "change:factor", (factor) ->
						# have manual factor values been provided?
						if startF? and endF?
							for k, v of props
								@[k] = Utils.modulate (factor), [startF, endF], [v[0], v[1]], true
							return
						
						# get the correct factorProps.points to modulate between
						start = Math.floor(factor % 3)
						end = start + 1
						
						# modulate just between 0 and 1, regardless of factor
						modf = factor % 1
						
						for k, v of props
							@[k] = Utils.modulate (modf), [0, 1], [v[start], v[end]], true
			
			# set props provided to constructor
			
			layer.points = options.factorProps.points
			
			delete options.factorProps.fade
			delete options.factorProps.fadeIn
			delete options.factorProps.fadeOut
			delete options.factorProps.points
			
			layer.setFactorProps(options.factorProps)
			
		return layer


# ----------------
# implementation

SHOW_GRID = false
# SHOW_GRID = true

app = new App

# Grid

gridX = Screen.width / 16
gridY = Screen.height / 12

gx = (num) -> return gridX * num
gy = (num) -> return gridY * num

if SHOW_GRID
	for i in _.range(Screen.width/gridX)
		l = new Layer
			name: '.'
			parent: app.header
			height: Screen.height
			width: 1
			x: gx(i)
			backgroundColor: '#ff66bb'
		l.sendToBack()
		
	for i in _.range(Screen.height/gridY)
		l = new Layer
			name: '.'
			parent: app.header
			width: Screen.width
			height: 1
			y: gy(i)
			backgroundColor: '#ff66bb'
		l.sendToBack()

# Scene View

# 	EXAMPLES
#
# 	red = new SceneLayer Layer,
# 		name: 'red'
# 		parent: @
# 		x: Align.center()
# 		y: Align.center()
# 		backgroundColor: 'red'
# 		factorProps:
# 			points: [100, 300]
# 			fade: 100
# 			midX:	[ app.midX - 400,  app.midX,  app.midX, app.midX + 400]
# 	
# 	# manually setting a property to change, according to the layer's factor
# 	red.setFactorProps({height: [200, 400]}, 1, 1.5)
# 	
# 	blue = new SceneLayer Layer,
# 		name: 'blue'
# 		parent: @
# 		x: Align.center()
# 		y: Align.center()
# 		backgroundColor: 'blue'
# 		factorProps:
# 			points: [300, 400, 500, 800]
# 			x: 		[  0,  30,  30, 100]


sceneView = new ScrollScene

Utils.bind sceneView, ->
	
	@backgroundColor = '#52489c'
	
	@leftContainer = new Layer
		parent: @
		width: @width / 2
		height: @height
		backgroundColor: '#ebebeb'
	
	# -----------------------
	# chap 1
	
	@chap1 = new SceneLayer Layer,
		name: 'Chap 1'
		parent: @
		x: @width / 2
		width: @width / 2
		height: @height
		backgroundColor: 'null'
		factorProps:
			fade: gy(2)
			points: [200, 400]

	title1 = new SceneLayer H1,
		parent: @
		fontSize: 64
		textAlign: 'center'
		text: 'Section One'
		factorProps:
			fade: gy(2)
			points: @chap1.points
			midY: [  gy(5),  gy(4),  gy(4), gy(3)]
			
	title1.midX = gx(4)

	subTitle1 = new SceneLayer H2,
		parent: @
		text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam erat arcu, sollicitudin ac convallis vel, bibendum vitae leo. Suspendisse potenti. In ut neque dignissim, vestibulum tortor sit amet, pharetra leo. Cras neque ipsum, condimentum in libero quis, iaculis hendrerit massa. Nullam lacus felis, dignissim ullamcorper lorem in, egestas vulputate nisi. Aliquam ipsum enim, euismod in nisi et, tincidunt porta eros. Sed tempus odio in turpis aliquam, at egestas libero pellentesque. Quisque pulvinar at nisl id posuere. Nullam sit amet varius dolor, ut facilisis metus. Nunc tincidunt lacus eu risus porta porttitor. Praesent pharetra egestas ante, nec rhoncus tellus ornare ut.'
		width: 500
		fontWeight: 400
		factorProps:
			fade: gy(2)
			points: @chap1.points
			y: [  gy(5.5),  gy(5),  gy(5), gy(4.5)]
			
	subTitle1.midX = gx(4)
	
	phone = new SceneLayer Layer,
		parent: @
		width: Screen.width/2
		height: Screen.width/2 * 1.618
		image: 'images/device_mask.png'
		backgroundColor: 'null'
		factorProps:
			points: [0, 100, 200, 600]
			scale: [ 1, 1, 1, 2.8]
			opacity: [ 0, 1, 1, 1]
	
	phone.midX = gx(12)
	phone.midY = gy(6)
	
	phone.sendToBack()
	
	startH = 220 * 1.77
	endH = (Screen.width / 2) * 1.77
	
	phoneImg = new SceneLayer Layer,
		parent: @
		width: 220
		height: 220 * 1.77
		image: 'images/full_device.png'
		backgroundColor: 'null'
		factorProps:
			points: [0, 100, 200, 600]
			width: [ 220, 220, 220, Screen.width/2]
			height: [ startH, startH, startH, endH]
			opacity: [ 0, 1, 1, 1]
	
	
	_.assign phoneImg,
		midX: gx(12)
		midY: gy(6)
	
	phoneImg.on "change:size", ->
		_.assign phoneImg,
			midX: gx(12)
			midY: gy(6)
	
	phoneImg.placeBehind(phone)
	
	# -----------------------
	# chap 2
			
	@chap2 = new SceneLayer Layer,
		name: 'Chap 2'
		parent: @
		x: @width / 2
		width: @width / 2
		height: @height
		backgroundColor: '#4061bb'
		factorProps:
			fade: gy(2)
			points: [800, 1000]
	
	title2 = new SceneLayer H1,
		parent: @
		fontSize: 64
		textAlign: 'center'
		text: 'Section Two'
		factorProps:
			fade: gy(2)
			points: @chap2.points
			midY: [  gy(5),  gy(4),  gy(4), gy(3)]
			
	title2.midX = gx(4)

	subTitle2 = new SceneLayer H2,
		parent: @
		text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam erat arcu, sollicitudin ac convallis vel, bibendum vitae leo. Suspendisse potenti. In ut neque dignissim, vestibulum tortor sit amet, pharetra leo. Cras neque ipsum, condimentum in libero quis, iaculis hendrerit massa. Nullam lacus felis, dignissim ullamcorper lorem in, egestas vulputate nisi. Aliquam ipsum enim, euismod in nisi et, tincidunt porta eros. Sed tempus odio in turpis aliquam, at egestas libero pellentesque. Quisque pulvinar at nisl id posuere. Nullam sit amet varius dolor, ut facilisis metus. Nunc tincidunt lacus eu risus porta porttitor. Praesent pharetra egestas ante, nec rhoncus tellus ornare ut.'
		width: 500
		fontWeight: 400
		factorProps:
			fade: gy(2)
			points: @chap2.points
			y: [gy(5.5),  gy(5),  gy(5), gy(4.5)]
			
	subTitle2.midX = gx(4)
	
	phone2 = new SceneLayer Layer,
		parent: @
		width: Screen.width/2
		height: Screen.width/2 * 1.618
		image: 'images/full_device.png'
		backgroundColor: '#333'
		factorProps:
			points: [580, 600, 3000, 3001]
			opacity: [0, 1, 1, 1]
	
	phone2.midX = gx(12)
	phone2.midY = gy(6)
	
	# -----------------------
	# chap 3
			
	@chap3 = new SceneLayer Layer,
		name: 'Chap 3'
		parent: @
		x: @width / 2
		width: @width / 2
		height: @height
		backgroundColor: 'null'
		factorProps:
			fade: gy(2)
			points: [1400, 1600]
	
	title3 = new SceneLayer H1,
		parent: @
		fontSize: 64
		textAlign: 'center'
		text: 'Section Three'
		factorProps:
			fade: gy(2)
			points: @chap3.points
			midY: [  gy(5),  gy(4),  gy(4), gy(3)]
			
	title3.midX = gx(4)

	subTitle3 = new SceneLayer H2,
		parent: @
		text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam erat arcu, sollicitudin ac convallis vel, bibendum vitae leo. Suspendisse potenti. In ut neque dignissim, vestibulum tortor sit amet, pharetra leo. Cras neque ipsum, condimentum in libero quis, iaculis hendrerit massa. Nullam lacus felis, dignissim ullamcorper lorem in, egestas vulputate nisi. Aliquam ipsum enim, euismod in nisi et, tincidunt porta eros. Sed tempus odio in turpis aliquam, at egestas libero pellentesque. Quisque pulvinar at nisl id posuere. Nullam sit amet varius dolor, ut facilisis metus. Nunc tincidunt lacus eu risus porta porttitor. Praesent pharetra egestas ante, nec rhoncus tellus ornare ut.'
		width: 500
		fontWeight: 400
		factorProps:
			fade: gy(2)
			points: @chap3.points
			y: [gy(5.5),  gy(5),  gy(5), gy(4.5)]
			
	subTitle3.midX = gx(4)

# crazy scrolling logic


Utils.bind sceneView, ->
		
	chapters = [@chap1, @chap2, @chap3]
	
	# -----------------------
	# progress indicator
	
	@progressIndicatorTrack = new Layer
		name: 'progress indicator track'
# 		parent: @touchLayer
		width: 8
		borderRadius: 8
		x: Align.center()
		y: app.header.maxY + 128
		height: (@height - app.header.maxY) - 256
		backgroundColor: '#CCC'
		
	
	@progressIndicator = new Layer
		parent: @progressIndicatorTrack
		width: 8
		borderRadius: 8
		x: Align.center()
		height: 0
		backgroundColor: '#84ce5c'
		
	@setProgress = =>
		factor = Utils.modulate(@scrollY, [chapters[0].enter, _.last(chapters).enter], [0, 1], true)
		@progressIndicator.height = @progressIndicatorTrack.height * factor
		
	for chapter in chapters
		chapterLink = new Layer
			parent: @progressIndicatorTrack
			height: 32
			width: 32
			borderRadius: 16
			x: Align.center()
			backgroundColor: '#555'
		
		chapterLink.midY = Utils.modulate(
			chapter.enter, 
			[chapters[0].enter, _.last(chapters).enter], 
			[0, @progressIndicatorTrack.height], 
			true
			)
		
		do (chapterLink, chapter) =>
		
			chapterLink.onTap =>
				@scrollToPoint(
					x: 0, y: chapter.enter
					true
					time: 1
					)
	
	
	
	# -----------------------
	# Events
	
	
	# when moving, if not dragging, find the closest chapter
	
	@onMove (event) =>
		@setProgress()
		
		if @content.draggable.isDragging
			return
		
		currentChapter = _.find(chapters, (c) =>
			c.fadeIn < @scrollY < c.fadeOut
			)
			
		return if not currentChapter or @currentChapter is currentChapter
		
		@currentChapter = currentChapter
		@currentIndex = chapters.indexOf(@currentChapter)
	
	
	@snapToNextChapter = =>
		next = chapters[@currentIndex + 1]
		if not next
			@snapToCurrentChapter()
			return
			
		return if @changed
		@content.animateStop()
		
		Utils.delay 0, =>
			@scrollToPoint(
				x: 0, y: next.enter
				true
				time: 1
				)
	
	
	@snapToPrevChapter = =>
		prev = chapters[@currentIndex - 1]
		if not prev
			@snapToCurrentChapter()
			return
			
		return if @changed
		@content.animateStop()
		
		Utils.delay 0, =>
			@scrollToPoint(
				x: 0, y: prev.enter
				true
				time: 1
				)
	
	
	@snapToCurrentChapter = =>
		if not @currentChapter
			return
			
		@content.animateStop()
				
		Utils.delay 0, =>
			@scrollToPoint(
				x: 0, y: @currentChapter.enter
				true
				time: 1
				)
	
	
	@content.onDrag (event) =>
		if event.deltaDirection is 'up'
			currentChapter = _.find(chapters, (c) =>
				c.fadeIn < @scrollY < c.exit
				)
		else if event.deltaDirection is 'down'
			currentChapter = _.find(chapters, (c) =>
				c.enter < @scrollY < c.fadeOut
				)
				
		return if not currentChapter or @currentChapter is currentChapter
		@changed = true
		@currentChapter = currentChapter
		@currentIndex = chapters.indexOf(currentChapter)
		
		
	@content.onDragEnd (event) =>
		if event.offsetDirection is "up" and event.velocity.y < -.2
			@snapToNextChapter()
			return
			
		if event.offsetDirection is "down" and event.velocity.y > .2
			@snapToPrevChapter()
			return
		
		@snapToCurrentChapter()
		
	@onScrollEnd => @changed = false
	
	@on Events.ScrollAnimationDidEnd, => 
		@snapToCurrentChapter()
	
	@currentChapter = chapters[0]
	@currentIndex = 0
	@snapToCurrentChapter()


app.showNext(sceneView)