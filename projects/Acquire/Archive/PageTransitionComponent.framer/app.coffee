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

# Page Transition Component

class PageTransitionComponent extends PageComponent
	constructor: (options = {}) ->
		
		_.defaults options,
			direction: 'bottom'
			originY: 0
		
		super options
		
		# -----------------
		# Settings
		
		_.assign @,
			edge: options.direction
			velocityThreshold: 2
		
		_.assign @content.draggable,
			momentum: true
			momentumOptions:
				friction: 6
				tolerance: 100
		
		# Desktop options
		# enabled when the device is not a touch device
		
		@mouseWheelEnabled = Utils.isTouch() 
		if @mouseWheelEnabled
			_.assign @content.draggable, 
				enabled: false
		
		# remove default listeners
		@content.off(Events.DragSessionEnd, @_scrollEnd)
		
		# -----------------
		# definitions
		
		Utils.define @, 'transitioning', false
		
		# -----------------
		# Events
		
		@onScrollEnd @_checkGestureEnd
		
		@content.on "change:y", @_setChildLayerFactors
		
		# timer for checking interstitial deadpoints
		
		@timer = undefined
		
		@time = 0
		
		@timer = Utils.interval .016, =>
			@time += .016
			if @time >= .15
				@content.animateStop()
				@time = 0
				@_checkScrollEnd()
	
	
	# A custom function for handling flick gestures, where a scroll's velocity
	# is high enough to suggest a page change intent. Since pages can be taller
	# than the window, this dynamically sets originY depending on the direction
	_checkGestureEnd: (event) =>
		return if @mouseWheelEnabled
	
		# if we have an event, a gesture just ended. New question is:
		# was that gesture fast enough to suggest a page change intent?
		
		# If it's fast for a page turn, it's a page change intent
		if Math.abs(event.velocity.y) > @velocityThreshold
			if event.offsetDirection is "up"
				@originY = 0
				@snapToNextPage("down")
			else
				@originY = 1
				@snapToNextPage("up")
				@originY = 0
			return
	
	
	# Every .2 seconds, run this function to check whether a scroll
	# ended in a transition (between two pages)
	_checkScrollEnd: (event) =>
		transitioning = _.some(@content.children, 'transitioning')
		# if we're still in the page, or if the content is still scrolling
		# do nothing and behave like a scroll
		return if @isMoving or not transitioning
			
		# if we're between pages and the content isnt moving...
		
		# if the current page is just a little out of bounds,
		# snap either to the top or bottom of the current page, 
		# depending on which edge is out of bounds
		
		yCloseEnough = @scrollY < @currentPage.y < (@scrollY + @height * .2)
		maxYCloseEnough = (@scrollY + @height * .8) < @currentPage.maxY < @scrollMaxY
		
		# snap to the top of the current page
		if yCloseEnough
			@originY = 0
			@snapToPage(@currentPage)
			return true
	
		# snap to the bottom of the current page
		if maxYCloseEnough
			@originY = 1
			@snapToPage(@currentPage)
			return true
		
		# If we're too far to stay, move back a page or down a page, 
		# depending on where the current page's edges are
		
		yInside = @scrollY < @currentPage.y < @scrollMaxY
		maxYInside = @scrollY < @currentPage.maxY < @scrollMaxY
		
		if yInside and not yCloseEnough
			@originY = 1
			@snapToNextPage("up")
		else if maxYInside and not maxYCloseEnough
			@originY = 0
			@snapToNextPage("down")
		
		# if nothing's close enough... do nothing
		# (but something should be close enough)
		return false

	
	# Set a factor for each child layer:
	# 0, layer is out of the window (higher up in the scroll)
	# 0-1, layer's progress into the current window
	# 1-2, layer's progress within the current window
	# 2-3, layer's progress out of the current window
	# 3, layer is out of the window (lower down in the scroll)
	
	# This factor can be used to set listeners (layer.on "change:factor")
	# that control how a layer (and any other layers) appear as a 
	# given layer is scrolled
	
	_setChildLayerFactors: =>
			# reset interval time
			@time = 0
			
			@scrollMaxY = @scrollY + @height
			
			# set child factors
			for layer in @content.children
				
				# simple edge relationships
				
				tooHigh = layer.maxY <= @scrollY
				tooLow = layer.y >= @scrollMaxY
				
				if tooHigh
					layer.factor = 3
					return
				
				if tooLow
					layer.factor = 0
					return
				
				# complex edge relationships
				
				yAbove = layer.y < @scrollY
				yInside = @scrollY < layer.y < @scrollMaxY
				
				maxYInside = @scrollY < layer.maxY < @scrollMaxY
				maxYBelow = layer.maxY > @scrollMaxY
				
				
				# entering
				if yInside and maxYBelow
					layer.transitioning = true
					layer.factor = Utils.modulate(
						layer.y,
						[@scrollMaxY, @scrollY]
						[0, 1]
					)
				# inside
				else if yAbove and maxYBelow
					layer.transitioning = false
					layer.factor = Utils.modulate(
						@scrollY,
						[layer.y, layer.maxY - @height]
						[1, 2]
					)
				# exiting
				else if maxYInside and yAbove
					layer.transitioning = true
					layer.factor = Utils.modulate(
						layer.maxY,
						[@scrollMaxY, @scrollY]
						[2, 3]
					)
	
	
	# add a TransitionPage to this component
	newPage: (options = {}) =>
		_.defaults options,
			width: @width
			height: @height * 2
			
		page = new TransitionPage(options)
		
		@addPage(page, options.direction ? @edge)
			
		return page

# Transition Page

class TransitionPage extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			grid: true
		
		super options
		
		# layers
		
		if options.grid
			Utils.delay .5, =>
				lines = Math.floor(@height / 100)
				for i in _.range(lines)
					line = new Layer
						name: '.'
						parent: @
						width: @width * 5/6
						height: 1
						x: @width/6
						y: i * (@height / lines)
						backgroundColor: '#000'
						
					new TextLayer
						name: '.'
						parent: @
						fontSize: 12
						x: 0
						width: @width/6
						textAlign: 'center'
						y: line.y - 8
						color: '#000'
						text: (@y + line.y).toFixed()
		
		# definition
		
		Utils.define @, 'factor', 0, @_setFactor
		
		# events
		
	
	_setFactor: (factor) =>
		null

	

# ----------------
# implementation

app = new App

# View 
view = new View

pageTransitionComponent = new PageTransitionComponent
	parent: view
	y: app.header.height
	height: Screen.height - app.header?.height - app.footer?.height
	width: Screen.width
	scrollHorizontal: false

page1 = pageTransitionComponent.newPage({name: 'page1', backgroundColor: '#ef8a7d'})
page2 = pageTransitionComponent.newPage({name: 'page2', backgroundColor: '##e4e391'})
page3 = pageTransitionComponent.newPage({name: 'page3', backgroundColor: '#9abd8a'})

app.showNext(view)