# SVGContext
class SVGContext extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		@shapes = []
		
		_.defaults options,
			size: Screen.size
		
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
			height: @height * Framer.Device.context.scale
			width: @width * Framer.Device.context.scale
			viewBox: "0 0 #{@width * Framer.Device.context.scale} #{@height * Framer.Device.context.scale}"
		
		# defs
		
		@svgDefs = document.createElementNS(svgNS, 'defs')
		@svg.appendChild @svgDefs
		
		delete @__constructor

	addShape: (shape) ->
		@shapes.push(shape)
		@emit "change:shapes", shape, @
		@showShape(shape)
		
	removeShape: (shape) ->
		@hideShape(shape)
		_.pull(@shapes, shape)
		@emit "change:shapes", shape, @
		
	hideShape: (shape) ->
		@svg.removeChild(shape.element)
	
	showShape: (shape) ->
		@svg.appendChild(shape.element)
		
	addDef: (def) ->
		@svgDefs.appendChild(def)

# SVGShape
class SVGShape
	constructor: (options = {type: 'circle'}) ->
		@__constructor = true
		
		@parent = options.parent ? throw 'Shape needs an SVGContext parent.'
		
		options.fill ?= 'none'
		options.stroke ?= 'none'
		
		@element = document.createElementNS(
			"http://www.w3.org/2000/svg", 
			options.type
			)
				
		# assign attributes set by options
		for key, value of options
			@setAttribute(key, value)
		
		@parent.addShape(@)
		
		@show()
			
	setAttribute: (key, value) ->
		if not @[key]?
			Object.defineProperty @,
				key,
				get: ->
					return @element.getAttribute(key)
				set: (value) -> 
					@element.setAttribute(key, value)
		
		@[key] = value
		
	hide: -> 
		@parent.hideShape(@)
	
	show: -> 
		@parent.showShape(@)
		
	remove: ->
		@parent.removeShape(@)

context = new SVGContext

path = new SVGShape
	parent: context
	type: 'path'
	d: 'M 100,200 c 200,250 300, 300 150, 350'
	stroke: 'red'
	
button = new Layer
	x: Align.right(-16)
	y: 16
	height: 48
	width: 128
	borderRadius: 8
	backgroundColor: '2954da'
	html: 'Tap Here'
	style:
		fontSize: '12px'
		padding: '12px 0'
		textAlign: 'center'
		
path.c = 250

button.onTap ->
	
	path.c -= 25
	path.d = "M 100,200 c 200,#{path.c} 300, 300 150, 350"
	