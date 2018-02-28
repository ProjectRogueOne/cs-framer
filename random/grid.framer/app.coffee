# Setup
Screen.backgroundColor = '#efefef'

setAttributes = (element, attributes = {}) ->
	for key, value of attributes
		element.setAttribute(key, value)

# Helpers

getDistance = (pointA, pointB) ->
	a = (pointB.x - pointA.x) * (pointB.x - pointA.x)
	b = (pointB.y - pointA.y) * (pointB.y - pointA.y)
	c = Math.sqrt(a + b)
	return c
	

svgContext = undefined
grid = undefined
hero = undefined

# SVGContext
class SVGContext extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		@shapes = []
		
		super options
		
		svgContext = @
	
		# namespace
		svgNS = "http://www.w3.org/2000/svg"
		
		# set attributes 
		setAttributes = (element, attributes = {}) ->
			for key, value of attributes
				element.setAttribute(key, value)

			
		@svg = document.createElementNS(svgNS, 'svg')
		@_element.appendChild(@svg)
		
		setAttributes @svg, 
			height: @height
			width: @width
			viewBox: "0 0 #{@width} #{@height}"
		
		# defs
		
		@svgDefs = document.createElementNS(svgNS, 'defs')
		@svg.appendChild @svgDefs
		
		delete @__constructor
				

	addShape: (shape) ->
		@shapes.push(shape)
		@emit "change:shapes", shape, @
		@showShape(shape)
		
	removeShape: (shape) ->
		_.pull(@shapes, shape)
		@emit "change:shapes", shape, @
		@hideShape(shape)
		
	hideShape: (shape) ->
		@svg.removeChild(shape)
	
	showShape: (shape) ->
		@svg.appendChild(shape)
		
	addDef: (def) ->
		@defs.appendChild(def)

# Shape
class Shape
	constructor: (options = {type: 'circle'}) ->
		@__constructor = true
		
		options.fill ?= '#000'
		
		@element = document.createElementNS(
			"http://www.w3.org/2000/svg", 
			options.type
			)
				
		# assign attributes set by options
		for key, value of options
			@setAttribute(key, value)
			
	setAttribute: (key, value) ->
		if not @[key]?
			Object.defineProperty @,
				key,
				get: ->
					return @element.getAttribute(key)
				set: (value) -> 
					@element.setAttribute(key, value)
		
		@[key] = value
		
	hide: -> svgContext.hideShape(@element)
	show: -> svgContext.showShape(@element)

# ---

# Tile

class Tile extends Layer
	constructor: (options = {}) ->
		
		@lat = options.lat
		@lon = options.lon
		
		_.assign options,
			height: 32
			width: 64
			backgroundColor: null
			style:
				color: 'rgba(0,0,0,.34)'
				fontSize: '12px'
				textAlign: 'center'
			
		super options
		
		@html = "#{@lon} #{@lat}"
		
		# make SVG
		
		left = 		@x
		right = 	@x + @width
		middleX = 	@x + (@width / 2)
		middleY = 	@y + (@height / 2)
		top = 		@y
		bottom = 	@y + @height
		
		@base =
			'stroke-width': options.strokeWidth ? 1
			stroke: options.stroke ? "#000"
			fill: options.fill ? 'green'
		
		@svg = new Shape
			type: "polyline"
			points: """
				#{left},#{middleY}
				#{middleX},#{bottom} 
				#{right},#{middleY} 
				#{middleX},#{top}
				#{left},#{middleY}
				"""
			'stroke-width': @base['stroke-width']
			stroke: @base.stroke
			fill: @base.fill
		
		@svg.show()

# Grid

class Grid extends SVGContext
	constructor: (options = {}) ->
		
		@tiles = []
		
		_.assign options,
			height: 320
			width: 640
			backgroundColor: null
		
		super options
		
		grid = @
		
		startX = (@width / 2) - 32
		startY = 0
		
		for i in _.range(100)
			lon = Math.floor(i/10)
			lat = i % 10
		
			tile = new Tile
				name: "#{lon} #{lat}"
				parent: @
				x: startX + (32 * (i % 10)) - (32 * lon)
				y: startY + 16 * lon + (16 * lat)
				lon: lon
				lat: lat
				fill: '#FFF'
			
			tile.svg.fill = Color.mix('#98ee66', '#4ac669', 1 - (tile.y / 320))
			tile.svg['stroke-width'] = .1
			
			tile.base.fill = tile.svg.fill
			tile.base['stroke-width'] = tile.svg['stroke-width']
			
			@tiles.push(tile)
			
	getTile: ([lon, lat]) =>
		lon = _.clamp(lon, 0, 9)
		lat = _.clamp(lat, 0, 9)
		
		tile = _.find(@tiles, {'lon': lon, 'lat': lat})
		return tile
	
	getRelativeTile: (start = [], offset = []) ->
		[lon, lat] = start
		
		lon = start[0] + offset[0]
		lat = start[1] + offset[1]
		
		return [
			_.clamp(lon, 0, 9), 
			_.clamp(lat, 0, 9)
			]
		
	indicateTile: (tile) ->
		tile.svg.fill = new Color(tile.svg.fill).brighten(10).saturate(20)
	
	resetTile: (tile) ->
		_.assign tile.svg, tile.base

# Hero

class Hero extends Layer
	constructor: (options = {}) ->
		
		@currentPosition = undefined
		@nextPosition = undefined
		
		@grid = options.grid ? grid
		
		_.assign options,
			parent: @grid
			height: 56
			width: 12
		
		super options
		
		@on "change:position", @moveToTile
		
		@snapToTile()
		
	snapToTile: ->
		@midX = @position.midX
		@y = @position.midY - @height
		@currentPosition = @position
		
	moveToTile: =>
		distance = getDistance(@position.point, @currentPosition.point)
		
		@animate
			x: @position.midX - (@width / 2)
			y: @position.midY - @height
			options: 
				time: (distance / 36) * .15
				
		@currentPosition = @position
	
	getNextPosition: (direction) ->
		current =	[@position.lon, @position.lat]
		next =		[0, 0]
		
		switch direction
			when 'n'	then next = [-1,  0]
			when 'ne'	then next = [-1,  1]
			when 'e'	then next = [ 0,  1]
			when 'se'	then next = [ 1,  1]
			when 's'	then next = [ 1,  0]
			when 'sw'	then next = [ 1, -1]
			when 'w'	then next = [ 0, -1]
			when 'nw'	then next = [-1, -1]
		
		if @nextPosition?
			nextTile = grid.getTile(@nextPosition)
			grid.resetTile(nextTile)
		
		@nextPosition = grid.getRelativeTile(current, next)
		
		nextTile = grid.getTile(@nextPosition)
		grid.indicateTile(nextTile)
	
	go: =>	@position = @nextPosition
	
	@define "position",
		get: -> return @_position
		set: ([lon, lat]) ->
			tile = @grid.getTile([lon, lat])
			@_position = tile
			
			@emit "change:position", tile, lon, lat, @

# Controller
class Controller extends Layer
	constructor: (options = {}) ->
		
		@_selected = undefined
		
		@directionInterval = undefined
		@touchStartTime = undefined
		@swipeOkay = false
		@selectedTile = undefined
		
		_.assign options,
			size: Screen.size
			backgroundColor: null
			
		super options
		
		@draggable.enabled = true
		@draggable.constraints = @frame
# 		@onDragStart @startInterval
# 		@onDragEnd @stopInterval
		@onDrag (event) => @setDirection(event)
		@onSwipeEnd (event) => @sendSwipe(event)
		
		@on "change:selected", @showSelected
	
	startInterval: =>
		@touchStartTime = _.now()
		@directionInterval = Utils.interval 1, @sendDirection
	
	stopInterval: => 
		clearInterval @directionInterval
		
	setDirection: (event) =>
	
		offset = getDistance(event.start, event.point)
		return if offset < 32
		
		next = [0, 0]
		
		p1 = {x: 0, y: 0}
		p2 = @point
		
		angleDeg = Math.atan2(p2.y - 0, p2.x - 0) * 180 / Math.PI;
		
		if -157.5 < angleDeg <= -112.5
			next = [ 0, -1] # w
		else if -112.5 < angleDeg <= -67.5
			next = [-1, -1] # nw
		else if -67.5 < angleDeg <= -22.5
			next = [-1,  0] # n
		else if -22.5 < angleDeg <= 22.5
			next = [-1,  1] # ne
		else if 22.5 < angleDeg <= 67.5
			next = [ 0,  1] # e
		else if 67.5 < angleDeg <= 112.5
			next = [ 1,  1] # se
		else if 112.5 < angleDeg <= 157.5
			next = [ 1,  0] # s
		else 
			next = [ 1, -1] # sw
		
		@selected = grid.getTile(next)
		print @selected
		
# 		hero.getNextPosition(next)

	showSelected: => grid.indicateTile(@selected)
	
	sendDirection: => hero.go()
	
	sendSwipe: (event) =>
		duration = (event.time - @touchStartTime) / 1000
		if duration <= 1
			@setDirection(event)
			@sendDirection()
	
	@define "selected",
		get: -> return @_selected
		set: (tile) ->
			return if @__constructor
			
			if @_selected? then grid.reset(@_selected)
			@_selected = tile
			
			@emit "change:selected", tile, @

# ---

grid = new Grid
	x: Align.center
	y: Align.center(64)

controller = new Controller

hero = new Hero
	position: [0, 0]