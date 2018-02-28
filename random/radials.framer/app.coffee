setAttributes = (element, attributes = {}) ->
	for key, value of attributes
		element.setAttribute(key, value)

# Segment 

class Segment extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		@_value
		@_strokeWidth
		@i = options.i ? 0
		
		# set forced options
		
		_.assign options,
			backgroundColor: 'null'
			borderRadius: 999
		
		options.start ?= 0
		options.strokeWidth ?= 2
		options.value ?= 62
		options.color ?= '#CC07D0'
	
		super _.defaults options,
			name: 'Segment'
		
		svgNS = "http://www.w3.org/2000/svg"
		
		# SVG element
		
		@svg = document.createElementNS(svgNS, 'svg')
		
		setAttributes @svg, 
			height: @height
			width: @width
			viewBox: "0 0 #{@height} #{@width}"
			
		# Gradient
		
		@svgDefs = document.createElementNS(svgNS, 'defs')
		@svg.appendChild(@svgDefs)
		
		@gradientId = _.uniqueId()
		
		@svgGradient = document.createElementNS(svgNS, 'linearGradient')
		setAttributes @svgGradient,
			id: @gradientId
			x1: '100%'
			y1: '0%'
			x2: '0%'
			y2: '100%'
		@svg.appendChild(@svgGradient)
		
		@svgStop1 = document.createElementNS(svgNS, 'stop')
		setAttributes @svgStop1,
			offset: '0%'
			'stop-color': @gradient?.start ? options.color
		@svgGradient.appendChild(@svgStop1)
		
		@svgStop2 = document.createElementNS(svgNS, 'stop')
		setAttributes @svgStop2,
			offset: '100%'
			'stop-color': @gradient?.end ? options.color
		@svgGradient.appendChild(@svgStop2)
		
		# Circle
		
		@circle = document.createElementNS(svgNS, 'circle')
	
		@svg.appendChild(@circle)
		@_element.appendChild(@svg)
		
		@on "change:strokeWidth", @setCircle
		@on "change:color", @setCircle
		@on "change:start", @setCircle
		@on "change:value", @setArc
			
		delete @__constructor
		
		@setCircle()
		@setArc()

	setCircle: ->
		return if @__constructor
		
		@radius = @width / 2
		@circumference = (2 * Math.PI) * (@radius - (@strokeWidth / 2))
		
		start = Utils.modulate(@start, [0, 100], [-90, 270], true)
		
		setAttributes @circle, 
			cx: @radius
			cy: @radius
			r: @radius - (@strokeWidth / 2)
			fill: "none"
			stroke: if @gradient? then "url(##{@gradientId})" else "#{@color}"
# 			'stroke-linecap': 'round'
			'stroke-width': @strokeWidth
			'stroke-dasharray': @circumference
			'stroke-dashoffset': @circumference * (1 - (@value / 100))
			transform: "rotate(#{start}, #{@radius}, #{@radius})"
			
		@moveGroup()
		
	setArc: =>
		setAttributes @circle,
			'stroke-dashoffset': @circumference * (1 - (@value / 100))
			
		@moveGroup()

	moveGroup: =>
		return if not @group
		
		@group[@i + 1]?.start = @end

	@define "group",
		get: -> return @_group
		set: (array) ->
			if not _.isArray(array)
				throw 'Group must be an array.'
			
			array.push(@)
			@_group = array

	@define "value",
		get: -> return @_value
		set: (num) ->
			
			@_value = num
			@emit "change:value", num, @
	
	@define "gradient",
		get: -> return @_gradient
		set: (gradient) ->
			@_gradient = gradient
			
			@emit "change:gradient", gradient, @
			
	@define "start",
		get: -> return @_start
		set: (num) ->
			@_start = num
			
			@emit "change:start", num, @
			
	@define "end",
		get: -> return @start + @value
	
	@define "strokeWidth",
		get: -> return @_strokeWidth
		set: (num) ->
			@_strokeWidth = num
			
			@emit "change:strokeWidth", num, @

# Radial Graph

class RadialGraph extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		@segments = []
		
		@_strokeWidth
		options.strokeWidth ?= 16
		
		_.assign options,
			backgroundColor: null
		
		super options
		
		@remainder = new Segment
			name: "Remainder"
			parent: @
			size: @size
			value: 0
			strokeWidth: @strokeWidth
			color: '#CCC' 
			start: @start
		
		# Events
		
		@on "change:strokeWidth", =>
			for seg in @segments
				seg.strokeWidth = @strokeWidth
			@remainder.strokeWidth = @strokeWidth
		
		@on "change:size", =>
			for seg in @segments
				seg.size = @size
			@remainder.size = @size
			
		delete @__constructor
		
		@strokeWidth = options.strokeWidth
		@makeSegments(options.segments)

		@setRemainder()
		
	makeSegments: (segments) =>
		
		segment.destroy() for segment in @segments
		
		@segments = []
		
		start = @start ? 0
		
		for seg, i in segments
		
			segment = new Segment
				name: seg.name ? "Segment #{i}"
				parent: @
				size: @size
				value: seg.value ? 33
				strokeWidth: @strokeWidth
				color: seg.color 
				gradient: seg.gradient
				start: start
				opacity: 1
				group: @segments
				i: i
				
			segment.i = i
			
			start += segment.value
			
			segment.on "change:value", @setRemainder
				
			segment.on "change:start", @setRemainder
	
	setRemainder: =>
		total = _.sumBy(@segments, 'value')

		@remainder.start = total
		@remainder.value = 100 - total
		
		@remainder.sendToBack()
	
	@define "remaining",
		get: -> return 100 - _.sumBy(@segments, 'value')
		
	@define "strokeWidth",
		get: -> return @_strokeWidth
		set: (num) ->
			return if @__constructor
			@_strokeWidth = num
			
			@emit "change:strokeWidth", num, @

# implementation

graph = new RadialGraph
	x: Align.center
	y: Align.center(-128)
	segments: [
		{name: 'blue', gradient: {start: '#21ccff', end: '#0069c5'}, value: 20}
		{name: 'green', gradient: {start: '#98ee66', end: '#098a5f'}, value: 30}
		{name: 'orange', gradient: {start: '#ffcc33', end: '#d87800'}, value: 40}
	]

# blue slider

blueSlider = new SliderComponent
	x: Align.center
	y: Align.center(64)
	backgroundColor: '#21ccff'
	min: 10
	max: 100
	value: graph.segments[0].value

blueSlider.fill.backgroundColor = '0069c5'

blueSlider.target = graph.segments[0]

blueSlider.on "change:value", (value) ->
	return if shifting is true
	setKnobs()	
	@target.value = @value

# green slider

greenSlider = new SliderComponent
	x: Align.center
	y: blueSlider.maxY + 48
	backgroundColor: '#98ee66'
	min: 10
	max: 100
	value: graph.segments[1].value

greenSlider.fill.backgroundColor = '098a5f'

greenSlider.target = graph.segments[1]

greenSlider.on "change:value", (value) ->
	return if shifting is true
	setKnobs()
	@target.value = @value

# orange slider

orangeSlider = new SliderComponent
	x: Align.center
	y: greenSlider.maxY + 48
	backgroundColor: '#ffcc33'
	min: 10
	max: 100
	value: graph.segments[2].value

orangeSlider.fill.backgroundColor = 'd87800'

orangeSlider.target = graph.segments[2]

orangeSlider.on "change:value", (value) ->
	return if shifting is true
	setKnobs()
	@target.value = @value
	
setKnobs = ->
	orangeSlider.max = 100 - (blueSlider.value + greenSlider.value)
	greenSlider.max = 100 - (blueSlider.value + orangeSlider.value)
	blueSlider.max = 100 - (orangeSlider.value + greenSlider.value)

shifting = false

for layer in [blueSlider, greenSlider, orangeSlider]
	do (layer) ->
	
		layer.onTouchEnd =>
			shifting = true
			orangeSlider.animateToValue(orangeSlider.value)
			blueSlider.animateToValue(blueSlider.value)
			greenSlider.animateToValue(greenSlider.value)
			Utils.delay .5, =>
				shifting = false
				
setKnobs()
