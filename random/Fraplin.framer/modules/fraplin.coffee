# SVGContext

Framer.Extras.Hints.disable()

svgContext = undefined

class SVGContext
	constructor: (options = {}) ->
		@__constructor = true
		
		@shapes = []

		svgContext = @

		# namespace
		svgNS = "http://www.w3.org/2000/svg"
		
		# set attributes 
		setAttributes = (element, attributes = {}) ->
			for key, value of attributes
				element.setAttribute(key, value)

		@frameLayer = new Layer
			size: Screen.size
			name: '.'
			visible: false

		@frameElement = @frameLayer._element

		@lFrame = @frameElement.getBoundingClientRect()


		_.assign @,
			width: @lFrame.width.toFixed()
			height: @lFrame.height.toFixed()
			x: @lFrame.left.toFixed()
			y: @lFrame.top.toFixed()

		# Create SVG element

		@svg = document.createElementNS(svgNS, 'svg')
	
		context = document.getElementById('FramerContextRoot-TouchEmulator')
		context.appendChild(@svg)

		@screenElement = document.getElementsByClassName('framerContext')[0]
		sFrame = @screenElement.getBoundingClientRect()

		setAttributes @svg,
			x: 0
			y: 0
			width: sFrame.width
			height: sFrame.height
			viewBox: "0 0 #{sFrame.width} #{sFrame.height}"

		_.assign @svg.style,
			position: "absolute"
			left: 0
			top: 0
			width: '100%'
			height: '100%'
			'pointer-events': 'none'

		# defs
		
		@svgDefs = document.createElementNS(svgNS, 'defs')
		@svg.appendChild @svgDefs
		
		delete @__constructor

	addShape: (shape) ->
		@shapes.push(shape)
		@showShape(shape)
		
	removeShape: (shape) ->
		@hideShape(shape)
		_.pull(@shapes, shape)
		
	hideShape: (shape) ->
		@svg.removeChild(shape.element)
	
	showShape: (shape) ->
		@svg.appendChild(shape.element)
		
	addDef: (def) ->
		@svgDefs.appendChild(def)

	removeAll: =>
		for shape in @shapes
			@svg.removeChild(shape.element)
		@shapes = []

# SVGShape
class SVGShape
	constructor: (options = {type: 'circle'}) ->
		@__constructor = true
		
		@parent = svgContext
		
		@element = document.createElementNS(
			"http://www.w3.org/2000/svg", 
			options.type
			)

		@setCustomProperty('text', 'textContent', 'textContent', options.text)
				
		# assign attributes set by options
		for key, value of options
			@setAttribute(key, value)

		@parent.addShape(@)
		
		@show()
			
	setAttribute: (key, value) =>
		return if key is 'text'
		if not @[key]?
			Object.defineProperty @,
				key,
				get: =>
					return @element.getAttribute(key)
				set: (value) => 
					@element.setAttribute(key, value)
		
		@[key] = value
	
	setCustomProperty: (variableName, returnValue, setValue, startValue) ->
		Object.defineProperty @,
			variableName,
			get: ->
				return returnValue
			set: (value) ->
				@element[setValue] = value

		@[variableName] = startValue

	hide: -> 
		@parent.hideShape(@)
	
	show: -> 
		@parent.showShape(@)
		
	remove: ->
		@parent.removeShape(@)

class Label extends TextLayer
	constructor: (options = {}) ->
		@__constructor = true

		_.assign options,
			name: '.'
			fontSize: 12
			fontWeight: 500
			color: '#777'
			fontFamily: 'Menlo'

		_.defaults options,
			text: 'x'
			value: 0

		w = options.width
		delete options.width

		super options

		@valueLayer = new TextLayer
			parent: @parent
			name: '.'
			fontSize: @fontSize
			fontWeight: 500
			color: '#333'
			fontFamily: @fontFamily
			x: @x + w
			y: @y
			text: '{value}'

		delete @__constructor

		@value = options.value
		

	@define "value",
		get: -> return @_value
		set: (value) ->
			return if @__constructor
			@_value = value
			@valueLayer.template = value

ctx = new SVGContext
	size: Screen.size
	backgroundColor: null





###
	 88888888b                            dP oo
	 88                                   88
	a88aaaa    88d888b. .d8888b. 88d888b. 88 dP 88d888b.
	 88        88'  `88 88'  `88 88'  `88 88 88 88'  `88
	 88        88       88.  .88 88.  .88 88 88 88    88
	 dP        dP       `88888P8 88Y888P' dP dP dP    dP
	                             88
	                             dP
###


class Fraplin
	constructor: (options = {}) ->

		_.defaults options,
			color: 'red'
			secondaryColor: 'white'
			fontFamily: 'Arial'
			fontSize: '10'
			fontWeight: '600'
			borderRadius: 4
			padding: {top: 2, bottom: 2, left: 4, right: 4}

		_.assign @,
			color: options.color
			secondaryColor: options.secondaryColor
			fontFamily: options.fontFamily
			fontSize: options.fontSize
			fontWeight: options.fontWeight
			shapes: []
			borderRadius: options.borderRadius
			padding: options.padding
			focusedElement: undefined
			enabled: false
			screenElement: document.getElementsByClassName('DeviceComponentPort')[0]
			viewport: document.getElementsByClassName('DeviceComponentPort')[0]
			layers: []

		document.addEventListener('keyup', @toggle)

		@context = document.getElementsByClassName('framerLayer DeviceScreen')[0]
		@context.classList.add('hoverContext')

		@context.childNodes[2].classList.add('IgnorePointerEvents')

		@context.addEventListener("mouseover", @focus)
		@context.addEventListener("mouseout", @unfocus)

		Utils.insertCSS """ 
			.framerLayer { 
				pointer-events: all !important; 
				} 

			.DeviceContent {
				pointer-events: none !important; 
				}

			.DeviceBackground {
				pointer-events: none !important; 
				}

			.DeviceHands {
				pointer-events: none !important; 
				}

			.DeviceComponentPort {
				pointer-events: none !important; 
			}

			.IgnorePointerEvents {
				pointer-events: none !important; 
			}
			"""

		@window = new Layer
			parent: null
			name: 'Details'
			y: Align.bottom(-16)
			x: 32
			height: 156
			width: Screen.width - 64
			backgroundColor: '#f5f5f5'
			borderRadius: 4
			shadowX: 1
			shadowY: 3
			shadowBlur: 6
			shadowColor: 'rgba(0,0,0,.30)'
			visible: false

		@window.draggable.enabled = true
		@window.draggable.constraints = 
			width: Screen.width
			height: Screen.height

		@window.onDoubleClick -> @visible = false

		do _.bind( ->

			@xLabel = new Label
				parent: @
				x: 8, y: 8
				width: 24
				text: 'x:'

			@yLabel = new Label
				parent: @
				x: 8, y: 28
				width: 24
				text: 'y:'

			@widthLabel = new Label
				parent: @
				x: 96, y: 8
				width: 60
				text: 'width:'

			@heightLabel = new Label
				parent: @
				x: 96, y: 28
				width: 60
				text: 'height:'

			@radiusLabel = new Label
				parent: @
				x: 8, y: 48
				width: 60
				text: 'radius:'

			@borderLabel = new Label
				parent: @
				x: 8, y: 72
				width: 60
				text: 'border:'

			@shadowLabel = new Label
				parent: @
				x: 8, y: 96
				width: 60
				text: 'shadow:'

			@componentLabel = new Label
				parent: @
				x: 8, y: 120
				width: 80
				text: 'Component:'

			@close = new TextLayer
				parent: @
				y: 0
				x: Align.right()
				text: 'x'
				fontFamily: 'Menlo'
				color: '#333'
				fontSize: 14
				fontWeight: 600
				padding: 8

			@close.onTap => @visible = false

			@style['pointer-events'] = 'none'

		, @window)

		for layer in @window.descendants
			layer.classList.add('IgnorePointerEvents')

	toggle: (event) =>
		if event.key is "`"
			if @enabled then @disable() else @enable()

			return

		if event.key is "/"
			return if not @enabled

			if @hoveredElement is @selectedElement
				@deselect()
			else
				@select()

			return


	resetLayers: =>
		@layers = []

		for layer in Framer.CurrentContext._layers
			@layers.push layer

	enable: =>

		@resetLayers()

		@enabled = true
		@window.visible = true
		@window.bringToFront()
		@focus()

	disable: =>

		@enabled = false
		@window.visible = false
		@window.sendToBack()
		@unfocus()


	getLayerFromElement: (element) =>
		if element.classList.contains('framerLayer')
			layer = _.find(@layers, ['_element', element])
		else
			element = element.parentNode?.parentNode?.parentNode
			layer = _.find(@layers, ['_element', element])

		return layer 

	select: (event) =>
		return if not @hoveredElement

		@selectedElement = @hoveredElement
		@selectedElement.addEventListener('click', @deselect)
		@focus()

	deselect: (event) =>
		@selectedElement.removeEventListener('click', @deselect)
		@selectedElement = undefined
		@focus()


	getDimensions: (element) =>
		d = element.getBoundingClientRect()

		dimensions = {
			x: d.left
			y: d.top
			width: d.width
			height: d.height
			midX: d.left + (d.width / 2)
			midY: d.top + (d.height / 2)
			maxX: d.left + d.width
			maxY: d.top + d.height
			frame: d
		}

		return dimensions

	makeLine: (pointA, pointB, label = true) =>
		line = new SVGShape
			type: 'path'
			d: "M #{pointA[0]} #{pointA[1]} L #{pointB[0]} #{pointB[1]}"
			stroke: @color
			'stroke-width': '1px'

		if pointA[0] is pointB[0]

			capA = new SVGShape
				type: 'path'
				d: "M #{pointA[0] - 4} #{pointA[1]} L #{pointA[0] + 5} #{pointA[1]}"
				stroke: @color
				'stroke-width': '1px'

			capB = new SVGShape
				type: 'path'
				d: "M #{pointB[0] - 4} #{pointB[1]} L #{pointB[0] + 5} #{pointB[1]}"
				stroke: @color
				'stroke-width': '1px'

		else if pointA[1] is pointB[1]

			capA = new SVGShape
				type: 'path'
				d: "M #{pointA[0]} #{pointA[1] - 4} L #{pointA[0]} #{pointA[1] + 5}"
				stroke: @color
				'stroke-width': '1px'

			capB = new SVGShape
				type: 'path'
				d: "M #{pointB[0]} #{pointB[1] - 4} L #{pointB[0]} #{pointB[1] + 5}"
				stroke: @color
				'stroke-width': '1px'

	makeLabel: (x, y, text) =>
		label = new SVGShape
			type: 'text'
			parent: ctx
			x: x
			y: y
			'font-family': @fontFamily
			'font-size': @fontSize
			'font-weight': @fontWeight
			fill: @secondaryColor
			text: (text / @ratio).toFixed()

		l = @getDimensions(label.element)

		label.x = x - l.width / 2
		label.y = y + l.height / 4

		box = new SVGShape
			type: 'rect'
			parent: ctx
			x: label.x - @padding.left
			y: label.y - l.height
			width: l.width + @padding.left + @padding.right
			height: l.height + @padding.top + @padding.bottom
			rx: @borderRadius
			ry: @borderRadius
			fill: @color

		label.show()

	showDistances: (selected, hovered) =>

		s = @getDimensions(@selectedElement)
		h = @getDimensions(@hoveredElement)

		@ratio = @screenElement.getBoundingClientRect().width / Screen.width

		@setWindowLabels(s)

		if @selectedElement is @hoveredElement
			h = @getDimensions(@screenElement)

		# When selected element contains hovered element

		if s.x < h.x and s.maxX > h.maxX and s.y < h.y and s.maxY > h.maxY
			
			# top

			d = Math.abs(s.y - h.y).toFixed()
			m = s.y + d / 2

			@makeLine([h.midX, s.y + 5], [h.midX, h.y - 4])
			@makeLabel(h.midX, m, d)

			# right

			d = Math.abs(s.maxX - h.maxX).toFixed()
			m = h.maxX + (d / 2)

			@makeLine([h.maxX + 5, h.midY], [s.maxX - 4, h.midY])
			@makeLabel(m, h.midY, d)

			# bottom

			d = Math.abs(s.maxY - h.maxY).toFixed()
			m = h.maxY + (d / 2)

			@makeLine([h.midX, h.maxY + 5], [h.midX, s.maxY - 4])
			@makeLabel(h.midX, m, d)

			# left

			d = Math.abs(s.x - h.x).toFixed()
			m = s.x + d / 2

			@makeLine([s.x + 5, h.midY], [h.x - 4, h.midY])
			@makeLabel(m, h.midY, d)

			@makeBoundingRects(s, h)

			return

		# When hovered element contains selected element

		if s.x > h.x and s.maxX < h.maxX and s.y > h.y and s.maxY < h.maxY
			
			# top

			d = Math.abs(h.y - s.y).toFixed()
			m = h.y + d / 2

			@makeLine([s.midX, h.y + 5], [s.midX, s.y - 4])
			@makeLabel(s.midX, m, d)
			@setWindowLabel('yLabel', d)

			# right

			d = Math.abs(h.maxX - s.maxX).toFixed()
			m = s.maxX + (d / 2)

			@makeLine([s.maxX + 5, s.midY], [h.maxX - 4, s.midY])
			@makeLabel(m, s.midY, d)

			# bottom

			d = Math.abs(h.maxY - s.maxY).toFixed()
			m = s.maxY + (d / 2)

			@makeLine([s.midX, s.maxY + 5], [s.midX, h.maxY - 4])
			@makeLabel(s.midX, m, d)

			# left

			d = Math.abs(h.x - s.x).toFixed()
			m = h.x + d / 2

			@makeLine([h.x + 5, s.midY], [s.x - 4, s.midY])
			@makeLabel(m, s.midY, d)
			@setWindowLabel('xLabel', d)

			@makeBoundingRects(s, h)

			return

		# When selected element doesn't contain hovered element
		
		# top

		if s.y > h.maxY

			d = Math.abs(s.y - h.maxY).toFixed()
			m = s.y - (d / 2)

			@makeLine([s.midX, h.maxY + 5], [s.midX, s.y - 4])
			@makeLabel(s.midX, m, d)

		else if s.y > h.y

			d = Math.abs(s.y - h.y).toFixed()
			m = s.y - (d / 2)

			if h.x < s.x
				@makeLine([s.midX, h.y + 5], [s.midX, s.y - 4])
				@makeLabel(s.midX, m, d)
			else
				@makeLine([s.midX, h.y + 5], [s.midX, s.y - 4])
				@makeLabel(s.midX, m, d)

		# left

		if s.x > h.maxX

			d = Math.abs(s.x - h.maxX).toFixed()
			m = s.x - (d / 2)

			@makeLine([h.maxX + 5, s.midY], [s.x - 4, s.midY])
			@makeLabel(m, h.midY, d)

		else if s.x > h.x

			d = Math.abs(s.x - h.x).toFixed()
			m = s.x - (d / 2)

			if s.y > h.maxY
				@makeLine([h.x + 5, s.midY], [s.x - 4, s.midY])
				@makeLabel(m, s.midY, d)
			else
				@makeLine([h.x + 5, s.midY], [s.x - 4, s.midY])
				@makeLabel(m, s.midY, d)

		# right

		if s.maxX < h.x

			d = Math.abs(h.x - s.maxX).toFixed()
			m = s.maxX + (d / 2)

			@makeLine([s.maxX + 5, s.midY], [h.x - 4, s.midY])
			@makeLabel(m, s.midY, d)

		else if s.x < h.x

			d = Math.abs(h.x - s.x).toFixed()
			m = s.x + (d / 2)

			if s.y > h.maxY
				@makeLine([s.x + 5, h.midY], [h.x - 4, h.midY])
				@makeLabel(m, h.midY, d)
			else
				@makeLine([s.x + 5, s.midY], [h.x - 4, s.midY])
				@makeLabel(m, s.midY, d)

		# bottom

		if s.maxY < h.y

			d = Math.abs(h.y - s.maxY).toFixed()
			m = s.maxY + (d / 2)

			@makeLine([s.midX, s.maxY + 5], [s.midX, h.y - 4])
			@makeLabel(s.midX, m, d)

		else if s.y < h.y

			d = Math.abs(h.y - s.y).toFixed()
			m = s.y + (d / 2)

			if h.x < s.x
				@makeLine([h.midX, s.y + 5], [h.midX, h.y - 4])
				@makeLabel(h.midX, m, d)
			else
				@makeLine([h.midX, s.y + 5], [h.midX, h.y - 4])
				@makeLabel(h.midX, m, d)

		@makeBoundingRects(s, h)

	makeBoundingRects: (s, h) =>

		hoveredRect = new SVGShape
			type: 'rect'
			parent: ctx
			x: h.x + 1
			y: h.y + 1
			width: h.width - 2
			height: h.height - 2
			stroke: 'blue'
			fill: 'none'
			'stroke-width': '1px'

		selectedRect = new SVGShape
			type: 'rect'
			parent: ctx
			x: s.x + 1
			y: s.y + 1
			width: s.width - 2
			height: s.height - 2
			stroke: 'red'
			fill: 'none'
			'stroke-width': '1px'

	setWindowLabel: (layerName, value) =>
		@window[layerName].value = value ? ''

	setWindowLabels: () =>
		h = @hoveredLayer
		he = @hoveredElement
		s = @selectedLayer
		se = @selectedElement

		if not s? and not h?
			@setWindowLabel 'componentLabel', ''
			@setWindowLabel 'xLabel', ''
			@setWindowLabel 'yLabel', ''
			@setWindowLabel 'widthLabel', ''
			@setWindowLabel 'heightLabel', ''
			@setWindowLabel 'radiusLabel', ''
			@setWindowLabel 'borderLabel', ''
			
			return

		if h? and not s?
			@setWindowLabel 'componentLabel', h.constructor.name
			@setWindowLabel 'xLabel', h.x
			@setWindowLabel 'yLabel', h.y
			@setWindowLabel 'widthLabel', h.screenFrame.width
			@setWindowLabel 'heightLabel', h.screenFrame.height
			@setWindowLabel 'radiusLabel', h.borderRadius

			if h.borderWidth > 0
				@setWindowLabel 'borderLabel', h.borderWidth + ' ' + h.borderColor
			else
				@setWindowLabel 'borderLabel', 'none'

			if h.shadowX > 0 or h.shadowY > 0 or h.shadowSpread > 0
				@setWindowLabel 'shadowLabel', h.shadowX + ' ' + h.shadowY + ' ' + h.shadowSpread + ' ' + h.shadowColor
			else
				@setWindowLabel 'shadowLabel', 'none'

			return


	focus: (event) =>
		if @enabled is false
			return 

		@unfocus()

		@selectedElement ?= @screenElement
		@hoveredElement = (event?.target ? @hoveredElement)
		
		if not @hoveredElement
			return

		if @hoveredElement is @window._element
			@hoveredElement = @screenElement

		@selectedLayer = @getLayerFromElement(@selectedElement)
		@hoveredLayer = @getLayerFromElement(@hoveredElement)
		@setWindowLabels()

		@showDistances(@selectedElement, @hoveredElement)

		if @screenElement is @hoveredElement
			return
		
		@hoveredElement.addEventListener('click', @select)

	unfocus: (event) =>
		ctx.removeAll()


exports.fraplin = new Fraplin
