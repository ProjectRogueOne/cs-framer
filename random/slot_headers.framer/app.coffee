# Long Read
# @steveruizok

# Improving orientation on a single, long page of several sections.


# Setup / Options

Utils.loadWebFont('Open Sans')
Canvas.backgroundColor = '898'

MAIN_HEADER_FULL_POSITION = 34
MAIN_HEADER_REDUCED_POSITION = 24
MAIN_HEADER_REDUCED_SCALE = .7

SECTION_HEADER_POSITION = 45

SHOW_PROGRESS = true
PROGRESS_COLORS = false

PROGRESS_RADIUS = 6
PROGRESS_STROKE_WIDTH = 2

PROGRESS_BG_COLOR = '#ccc'
PROGRESS_COLOR = '#555'

PROGRESS_DOTS = false
PROGRESS_DOT_COLOR = '#fff'

# ------------------
# Components

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
			height: @height * Framer.Device.context.scale
			width: @width * Framer.Device.context.scale
			viewBox: "0 0 #{@width * Framer.Device.context.scale} #{@height * Framer.Device.context.scale}"
		
		# defs
		
		@svgDefs = document.createElementNS(svgNS, 'defs')
		@svg.appendChild @svgDefs
		
		filter = document.createElementNS(svgNS, 'filter')
		setAttributes filter, 
			'id': "filter"
		
		flood = document.createElementNS(svgNS, "feFlood")
		setAttributes flood,
			result: "floodFill"
			x: "0" 
			y: "0" 
			width:"100%" 
			height: "100%"
			'flood-color': "green" 
			'flood-opacity': ".5"
			
		multiply = document.createElementNS(svgNS, "feBlend")
		setAttributes multiply,
			in: "BackgroundImage"
			in2: "floodFill"
			mode: 'multiply'
		
		filter.appendChild(flood)
		filter.appendChild(multiply)
		@addDef(filter)
		
		
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
		@svg.removeChild(shape)
	
	showShape: (shape) ->
		@svg.appendChild(shape)
		
	addDef: (def) ->
		@svgDefs.appendChild(def)

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
		
	hide: -> 
		flow.header.svgContext.hideShape(@element)
	
	show: -> 
		flow.header.svgContext.showShape(@element)
		
	remove: ->
		flow.header.svgContext.removeShape(@element)

# Section View Header

class SectionViewHeader extends Layer
	constructor: (options = {}) ->
		
		@segments = []
		@segmentSVGs = []
		
		_.defaults options,
			height: 80
			width: Screen.width
			backgroundColor: '#FFF'
			shadowColor: '#ccc'
			clip: true
			animationOptions:
				time: .15
		
		super options
		
		cy = SECTION_HEADER_POSITION + 1
		
				
		for el, i in ['curr', 'prev', 'next', 'main']
		
			@[el] = new Layer
				name: 'Header ' + el
				parent: @
				size: @size
				backgroundColor: null
				visible: false
	
			@[el].labelLayer = new TextLayer
				name: 'Label'
				parent: @[el]
				y: SECTION_HEADER_POSITION
				x: 64
				width: Screen.width
				fontSize: 20
				fontWeight: 500
				color: '#333'
				fontFamily: 'Futura'
				text: 'Header' + el


		@main.visible = true
		@main.backgroundColor = null
		@main.labelLayer.originX = 0
		@main.labelLayer.y = MAIN_HEADER_FULL_POSITION
		
		
		fade = new Gradient
			start:	"rgba(255, 255, 255, 1)"
			end:	"rgba(255, 255, 255, 0)"
			angle:	180
		
		@fade = new Layer
			name: 'Fade'
			parent: @
			width: @width
			backgroundColor: '#FFF'
			height: cy
			#gradient: fade
			
		@main.bringToFront()
		
		# furniture
		
		@statusBar = new Layer
			name: 'Status Bar'
			parent: @
			width: @width
			height: @width * (40/750)
			image: "images/ios_status_bar.png"
		
		if SHOW_PROGRESS
			@dotsVertical = new Layer
				name: 'Menu Dots'
				parent: @
				x: Align.right(-12)
				midY: cy
				width: 24
				height: 24
				backgroundColor: null
				html: "<svg style='width:24px;height:24px' viewBox='0 0 24 24'><path fill='#ccc' d='M12,16A2,2 0 0,1 14,18A2,2 0 0,1 12,20A2,2 0 0,1 10,18A2,2 0 0,1 12,16M12,10A2,2 0 0,1 14,12A2,2 0 0,1 12,14A2,2 0 0,1 10,12A2,2 0 0,1 12,10M12,4A2,2 0 0,1 14,6A2,2 0 0,1 12,8A2,2 0 0,1 10,6A2,2 0 0,1 12,4Z' /></svg>"
		else
			@menuIcon = new Layer
				name: 'Menu Dots'
				parent: @
				x: 18
				midY: cy
				width: 24
				height: 24
				backgroundColor: null
				html: "<svg style='width:24px;height:24px' viewBox='0 0 24 24'><path fill='#ccc' d='M3,6H21V8H3V6M3,11H21V13H3V11M3,16H21V18H3V16Z' /></svg>"

	# create progress and circle SVGs
	setSVGs: ->
		return if not SHOW_PROGRESS
		
		cy = SECTION_HEADER_POSITION + 1
		
		@svgContext = new SVGContext
			name: 'SVG context'
			parent: @
			height: @height
			width: @height
			backgroundColor: null
			originY: cy/@height
			originX: 32/@height
		
		@circle = new Shape
			type: 'circle'
			cx: (32 * Framer.Device.context.scale) + 'px'
			cy: "#{cy * Framer.Device.context.scale}px"
			r: (PROGRESS_RADIUS * 2) * Framer.Device.context.scale + 'px'
			'stroke-width': PROGRESS_STROKE_WIDTH * Framer.Device.context.scale + 'px'
			stroke: PROGRESS_BG_COLOR
			fill: 'none'
		
		@progress = new Shape
			type: 'circle'
			cx: (32 * Framer.Device.context.scale) + 'px'
			cy: "#{cy * Framer.Device.context.scale}px"
			r: (PROGRESS_RADIUS * 2) * Framer.Device.context.scale + 'px'
			'stroke-width': PROGRESS_STROKE_WIDTH * Framer.Device.context.scale + 'px'
			stroke: PROGRESS_COLOR
			fill: 'none'
			transform: "rotate(-90, #{32 * Framer.Device.context.scale}, #{cy * Framer.Device.context.scale})"

		@progress.circumference = (2 * Math.PI) * ((PROGRESS_RADIUS * 2) * Framer.Device.context.scale)

		for shape in [@circle, @progress]
			shape.show()

		@on "change:color", ->
			@progress.element.setAttribute('stroke', @color)
		
		@on "change:backgroundColor", ->
			@fade.backgroundColor = @backgroundColor
		
		scaleCycle = Utils.cycle([.25, 1])
		
		@svgContext.onTap ->
			@animate
				scale: scaleCycle()
				options:
					curve: Spring
	
	
	# create marker svgs for sections
	setSectionSVGs: ->
		return if not flow?
		return if not SHOW_PROGRESS
		return if not PROGRESS_DOTS
		
		cy = SECTION_HEADER_POSITION + 1
		
		for segment, i in flow.current.sections

			startA = -90 + (360 * segment.y/flow.current.scrollMax)
			length = .03
			
			seg = new Shape
				type: 'circle'
				cx: 32 * Framer.Device.context.scale + 'px'
				cy: "#{cy * Framer.Device.context.scale}px"
				r: ((PROGRESS_RADIUS * 2) * Framer.Device.context.scale) + 'px'
				'stroke-width': PROGRESS_STROKE_WIDTH * Framer.Device.context.scale + 'px'
				stroke: PROGRESS_DOT_COLOR
				'stroke-dasharray': @progress.circumference
				'stroke-dashoffset': @progress.circumference * (1 - length)
				transform: "rotate(#{startA}, #{32 * Framer.Device.context.scale}, #{cy * Framer.Device.context.scale})"
				fill: 'none'
			
			seg.show()
	
	
	setProgress: (factor) ->
		return if not SHOW_PROGRESS
		
		setAttributes = (element, attributes = {}) ->
			for key, value of attributes
				element.setAttribute(key, value)
				
		setAttributes @progress,
			'stroke-dasharray': @progress.circumference
			'stroke-dashoffset': @progress.circumference * (1 - factor)


# Section

class Section extends Layer
	constructor: (options = {}) ->
		
		if not flow? then throw "Section needs a FlowComponent named flow."
		if not flow.header? then throw "Flow needs a header first."
		
		_.assign options,
			width: Screen.width
		
		_.defaults options,
			name: options.header ? 'Section'
			header: 'Header title'
			body: 'Lorem ipsum...'
			backgroundColor: null
			color: Utils.randomColor()
		
		@header = options.header
		
		@img = options.image
		
		delete options.image
		
		super options
		
		@headerLayer = new Layer
			parent: @
			name: 'Header'
			width: @width
			height: flow.header.height
			backgroundColor: null
			
		@headerTitle = new TextLayer
			parent: @headerLayer
			name: 'Section Title'
			fontSize: 20
			fontFamily: 'Futura'
			fontWeight: 500
			color: '#333'
			y: SECTION_HEADER_POSITION
			x: 64
			text: options.header
		
		if PROGRESS_COLORS
			@headerTitle.color = @color
			
		@content = new Layer
			parent: @
			name: 'Content'
			width: @width
			y: @headerLayer.maxY
			backgroundColor: null
		
		@body = new TextLayer
			name: 'Body'
			parent: @content
			fontSize: 16
			color: '#333'
			y: 24
			x: 64
			width: @width - 64 - 32
			text: options.body
			lineHeight: 1.5
			fontFamily: 'Open Sans'
		
		if @img?
			@imgLayer = new Layer
				parent: @content
				name: 'Image'
				x: 0
				width: @width
				height: @width - 96
				y: @body.maxY + 32
				image: @img ? Utils.randomImage()
			
			@imgLayerLabel = new TextLayer
				parent: @content
				name: 'Image Label'
				x: 64
				y: @imgLayer.maxY + 16
				width: @width
				fontFamily: 'Futura'
				fontSize: 12
				color: '#000'
				text: 'Colorado River toad, Incilius alvarius'
			
			@body.height = @imgLayerLabel.maxY
		
		@content.height = _.clamp(@body.maxY, 20, 9999)
		
		@height = @content.maxY

	@define "top",
		get: -> return @screenFrame.y
	
	@define "bottom",
		get: -> return @screenFrame.y + @height

# SectionsView

class SectionsView extends ScrollComponent
	constructor: (options = {}) ->
	
		if not flow? then throw "SectionsView needs a FlowComponent named flow."
		
		_.assign options,
			size: Screen.size
			scrollHorizontal: false
			contentInset: {top: 0, bottom: 300}
		
		_.defaults options,
			name: 'SectionsView'
			backgroundColor: '#FFF'
			sections: []
		
		super options
		
		_.assign @,
			sections: []
			prev: undefined
			curr: undefined
			mext: undefined
			currIndex: 0
			
		for section in options.sections
			@addSection(section)
		
		@onMove @_setHeaders
		@on "change:parent", @_setHeadersOnLoad
		
		flow.header.setSVGs()
		flow.header.setSectionSVGs()
	
	
	# Set up initial headers
	_setHeadersOnLoad: =>
		Utils.delay 0, =>
			if flow.current is @
				@_setHeaderLabels()
				@_setHeaders()
				flow.header.main.labelLayer.text = @sections[0].header
			
			if PROGRESS_COLORS
				flow.header.main.labelLayer.color = @current.color
	
	# Run each time scrollY changes
	_setHeaders: =>
		return if not flow.current
		
		# update progress donut
		@_updateProgress()
		
		# set positions when overscrolling from top
		if @scrollY < 0
			@currIndex = 0
		
		# check for a section change
		@_setCurrentSection()
		
		if 0 <= @current.bottom <= flow.header.maxY
			# transition headers forward if needed
			@_transitionSections()
		else
			# set standard (inside of section) properties
			@_setStandardPositions()
	
	
	# check if section has changed
	_setCurrentSection: =>
		# decrease current index
		if @current.bottom >= @current.height and @currIndex isnt 0
			@currIndex--
			@_setHeaderLabels()
		
		# increase current index
		else if @current.bottom < 0 and @current isnt _.last(@sections)
			@currIndex++
			@_setHeaderLabels()
	
	# update header labels when current section changes
	_setHeaderLabels: =>
		flow.header.prev.labelLayer.text = @current.header
		flow.header.curr.labelLayer.text = @current.header
		flow.header.next.labelLayer.text = @next?.header
		
		if PROGRESS_COLORS
			flow.header.color = @current.color
				
			flow.header.prev.labelLayer.color = @current.color
			flow.header.curr.labelLayer.color = @current.color
			flow.header.next.labelLayer.color = @next?.color
	
	
	# update donut progress
	_updateProgress: ->
		scrollProgress = @scrollY / @scrollMax
		
		flow.header.setProgress(_.clamp(scrollProgress, 0, 1))
	
	
	# set header props when transitioning from section 0
	_transitionMainHeader: ->
		factor = Utils.modulate(
			flow.header.next.y, 
			[flow.header.maxY, 0], 
			[0, 1], 
			true
			)
		
		diff = MAIN_HEADER_FULL_POSITION - MAIN_HEADER_REDUCED_POSITION
		ypos = MAIN_HEADER_FULL_POSITION - (diff * factor)
		
		sdiff = 1 - MAIN_HEADER_REDUCED_SCALE
		scale = 1 - (sdiff * factor)
		
		_.assign flow.header.main.labelLayer,
			y: ypos
			scale: scale
	
	
	# set props during a standard transition
	_transitionSections: ->
		flow.header.curr.visible = false
		
		# set next header position
		_.assign flow.header.next,
			y: @current.bottom
			visible: true
		
		# set previous header position
		if @currIndex is 0
			@_transitionMainHeader()
		else
			_.assign flow.header.prev,
				maxY: @current.bottom
				visible: true
			
			if PROGRESS_COLORS
				factor = Utils.modulate(
					flow.header.next.y, 
					[flow.header.maxY, 0], 
					[0, 1], 
					true
					)
					
				flow.header.color = Color.mix(@current.color, @next?.color, factor)
	
	
	# set props when not transitioning
	_setStandardPositions: ->
		return if flow.header.next.visible is false
		
		# fix post-transition properties if needed
		if @currIndex is 0
			_.assign flow.header.main.labelLayer,
				y: MAIN_HEADER_FULL_POSITION
				scale: 1
		
		# fix other sections...
		else if @currIndex > 0 
			_.assign flow.header.main.labelLayer,
				y: MAIN_HEADER_REDUCED_POSITION
				scale: MAIN_HEADER_REDUCED_SCALE
		
		flow.header.curr.visible = @currIndex > 0
		flow.header.prev.visible = false
		flow.header.next.visible = false
	
	
	# add a new section
	addSection: (section) ->
		i = @sections.length
		
		
		s = new Section(section)
		
		_.assign s,
			parent: @content
			y: _.last(@sections)?.maxY ? 0
		
		if i is 0
			s.headerTitle.visible = false
		
		@sections.push(s)
		
		@updateContent()
		
		@scrollMax = ((@content.height - @height) + @contentInset.bottom)
		
	@define "current",
		get: -> return @sections[@currIndex]
		
	@define "next",
		get: -> return @sections[@currIndex + 1]

# ------------------
# Data

# Sections 

getColor = Utils.cycle(['31393C', '34a1fd', 'F79824', '5942a9', '468B26', '424BF4'])

sectionsData = [
	{
		color: getColor()
		header: "Colorado River Toad"
		body: "The Colorado River toad (Incilius alvarius), also known as the Sonoran Desert toad, is found in northern Mexico and the southwestern United States. Its toxin, as an exudate of glands within the skin, contains 5-MeO-DMT and bufotenin."
		image: 'images/toad.jpg'
	}, {
		color: getColor()
		header: "Description"
		body: "The Colorado River toad can grow to about 190 millimetres (7.5 in) long and is the largest toad in the United States apart from the non-native cane toad (Rhinella marina). It has a smooth, leathery skin and is olive green or mottled brown in color. Just behind the large golden eye with horizontal pupil is a bulging kidney-shaped parotoid gland. Below this is a large circular pale green area which is the tympanum or ear drum. By the corner of the mouth there is a white wart and there are white glands on the legs. All these glands produce toxic secretions. Dogs that have attacked toads have been paralyzed or even killed. Raccoons have learned to pull a toad away from a pond by the back leg, turn it on its back and start feeding on its belly, a strategy that keeps the raccoon well away from the poison glands.[2] Unlike other vertebrates, this amphibian obtains water mostly by osmotic absorption across their abdomen. Toads in the family bufonidae have a region of skin known as the seat patch, which extends from mid abdomen to the hind legs and is specialized for rapid rehydration."
	}, {
		color: getColor()
		header: "Distribution and habitat"
		image: 'images/toad1.jpg'
		body: "The Colorado River toad is found in the lower Colorado River and the Gila River catchment areas, in southeastern California, New Mexico, Mexico and much of southern Arizona. It lives in both desert and semi-arid areas throughout its range. It is semiaquatic and is often found in streams, near springs, in canals and drainage ditches, and under water troughs.[2] The Colorado River toad is known to breed in artificial water bodies (e.g., flood control impoundments, reservoirs) and as a result, the distributions and breeding habitats of these species may have been recently altered in south central Arizona.[4] It often makes its home in rodent burrows and is nocturnal. Its call is described as, 'a weak, low-pitched toot, lasting less than a second.'[5]"
	}, {
		color: getColor()
		header: "Biology"
		body: "Bufo alvarius is sympatric with the spadefoot toad (Scaphiopus spp.), Great Plains toad (Bufo cognatus), red-spotted toad (Bufo punctatus), and Woodhouse's toad (Bufo woodhousei). Like many other toads, they are active foragers and feed on invertebrates, lizards, small mammals, and amphibians. The most active season for toads is May–September, due to greater rainfalls (needed for breeding purposes). The age of B. alvarius ranges from 2 to 4 years within a population at Adobe Dam in Maricopa County, Arizona; however, other species in the toad family have a longer lifespan of 4 to 5 years.[6] The taxonomic affinities of B. alvarius remain unclear, but immunologically, it is equally close to the boreas and valliceps groups.[7]"
	}, {
		color: getColor()
		header: "Breeding"
		body: "The breeding season starts in May, when the rainy season begins, and can last up to August. Normally, 1–3 days after the rain is when toads begin to lay eggs in ponds, slow-moving streams, temporary pools or man-made structures that hold water. Eggs are 1.6 mm in diameter, 5–7 cm apart, and encased in a long single tube of jelly with a loose but distinct outline. The female toad can lay up to 8,000 eggs.[8]"
	}, {
		color: getColor()
		header: "Drug use of poison"
		body: "The toad's primary defense system are glands that produce a poison that may be potent enough to kill a grown dog.[9] These parotoid glands also produce the 5-MeO-DMT[10] and bufotenin for which the toad is known; both of these chemicals belong to the family of hallucinogenic tryptamines. 5-MeO-DMT may be smoked and is powerfully psychoactive. After inhalation, the user usually experiences a warm sensation, euphoria, and strong visual and auditory hallucinations. No long-lasting effects have been reported.[11]"
	}
]

# ------------------
# Implementation

flow = new FlowComponent

flow.header = new SectionViewHeader

view = new SectionsView
	sections: sectionsData

flow.showNext(view)