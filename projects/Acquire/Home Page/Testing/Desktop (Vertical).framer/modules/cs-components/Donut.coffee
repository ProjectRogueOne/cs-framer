# Donut

class exports.Donut extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: 'Donut'
			min: 0
			max: 700
			value: 420
			height: 240
			width: 240
			color: green
			backgroundColor: 'rgba(255,255,255,.1)'
			borderRadius: 999
			borderWidth: 1
			borderColor: 'rgba(255,255,255,.2)'
			backgroundBlur: 30
			dark: false
		
		super options
		
		_.assign @,
			min: options.min
			max: options.max
			value: undefined
			dark: options.dark
			_uniqId: _.uniqueId()

		@backgroundColor = if @dark then 'rgba(255,255,255,.1)' else 'rgba(0,0,0,.05)'
		
		# title 
		
		@titleLayer = new Body2
			parent: @
			text: 'Your credit score is'
			color: if @dark then white else grey80
			x: Align.center
			y: @height * .24
		
		# number 
		
		@numberLayer = new H2
			parent: @
			x: Align.center()
			y: @height * .36
			text: "{value}"
			width: @width
			textAlign: 'center'
			fontWeight: 200
		
		# out of...
		
		@outOfLayer = new Body2
			parent: @
			text: "out of #{@max}"
			color: if @dark then white else grey80
			x: Align.center
			y: @height * .58
		
		# meaning
		
		@outOfLayer = new Body2
			parent: @
			x: Align.center
			y: @height * .72
			text: 'On good ground'
			color: options.color
		
		# svg circle
		
		@svgCircle = new SVGLayer
			name: 'Circle'
			parent: @
			size: @size
			svg: "<svg><circle id='svg_circle_#{@_uniqId}' stroke-linecap='round' " +
				" transform='rotate(-90 #{@width/2} #{@width/2})' " +
				" cx='#{@width/2}' cy='#{@width/2}' " + 
				" r='#{(@width/2) - 3}'/></g>"
			fill: 'rgba(0,0,0,0)'
			strokeWidth: 3
			stroke: black
		
		@svgCircleElement = document.getElementById("svg_circle_#{@_uniqId}")
		
		# definitions
		
		Utils.defineValid @, "min", options.min, _.isNumber, 'Donut.min must be a number.', @_setValue
		Utils.defineValid @, "max", options.max, _.isNumber, 'Donut.max must be a number.', @_setValue
		Utils.defineValid @, "value", options.value, _.isNumber, 'Donut.value must be a number.', @_setValue
		
		# Events
		
		@on "change:size", =>
			@svgCircle.size = @size
			
			_.assign @numberLayer,
				width: @width
			
			Utils.setAttributes @svgCircleElement,
				cx: @width/2
				cy: @width/2
				r: (@width/2) - 8
				transform: "rotate(-90 #{@width/2} #{@width/2})"
		
		@on "change:color", => 
			@svgCircle.stroke = @color
			@numberLayer.color = @color
		
		@color = options.color
		
		
	_setValue: (value) ->
		return if not value
		
		_.clamp(value, @min, @max)
		
		@numberLayer.template = value.toFixed(0)
		
		r = (@width/2) - 8
		c = Math.PI*(r*2)
		
		range = @max - @min
		pct = ((range-value)/range)*c;
		
		Utils.setAttributes @svgCircleElement,
			'stroke-dasharray': "#{Math.PI*(r*2)} #{Math.PI*(r*2)}" 
			'stroke-dashoffset': "#{pct}"