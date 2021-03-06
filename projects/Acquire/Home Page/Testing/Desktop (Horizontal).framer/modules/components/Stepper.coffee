{ theme } = require 'components/Theme'

MODEL = 'segment'

class exports.Stepper extends Layer
	constructor: (options = {}) ->

		# ---------------
		# Options

		@app = options.app

		_.defaults options,
			name: 'Stepper'
			height: 48
			borderRadius: 4
			shadowY: 2
			shadowBlur: 6
			shadowColor: 'rgba(0,0,0,.16)'
			clip: true
			animationOptions:
				time: .2

			options: ["minus", "plus"]
			icon: true
			min: 0
			max: 10
			value: 5
			width: 180

		@customTheme = if options.backgroundColor and options.color then @_getCustomTheme(options.color, options.backgroundColor) else undefined
		@customOptions = {}

		@options = options.options
		@icon = options.icon

		@__constructor = true

		super options

		# ---------------
		# Layers

		_.assign @,
			min: options.min 
			max: options.max
			options: options.options
			buttons: []
			icon: options.icon

		@textLayer = new Label
			parent: @
			y: Align.center()
			padding: {left: 24, right: 24}
			textAlign: 'center'
			width: @width
			text: options.value

		for option, i in @options[0..1]
			button = new Button
				name: '.'
				parent: @
				x: 0
				y: 0
				color: options.color
				text: if @icon then '' else option
				icon: if @icon then option
				backgroundColor: options.backgroundColor

			customTheme = @customTheme
			button.palette = 'active'

			button._setTheme = (value) ->
				@animateStop()

				if customTheme?
					props = customTheme[value]
				else props = theme[MODEL][@palette][value]

				if @__instancing then @props = props else @animate props


			radius = switch i
				when 0 then "#{Utils.px(button.borderRadius)} 0px 0px #{Utils.px(button.borderRadius)}"
				when 1 then "0px #{Utils.px(button.borderRadius)} #{Utils.px(button.borderRadius)} 0px"
				else "0px 0px 0px 0px"
			
			button._element.childNodes[0].style['border-radius'] = radius

			@buttons.push(button)


		# set positions

		maxW = _.maxBy(@buttons, 'width').width

		if @width < (maxW * 3)
			@width = maxW * 3
			@textLayer.width = @width
			
		_.assign @buttons[0],
			select: => @value--
			x: 0
			width: maxW

		_.assign @buttons[1],
			select: => @value++
			x: Align.right()
			width: maxW

		_.assign @,
			backgroundColor: white
			height: _.maxBy(@children, 'maxY')?.maxY


		delete @__constructor

		# ---------------
		# Events

		@on "change:value", @_showValue

		# ---------------
		# Definitions

		Utils.defineValid @, 'value', options.value, _.isNumber, 'Stepper.value must be a number.', @_setValue


	# ---------------
	# Private Methods

	_getCustomTheme: (color, backgroundColor) ->
		return {
			default:
				color: color
				borderColor: new Color(backgroundColor).darken(10)
				backgroundColor: backgroundColor
				shadowColor: 'rgba(0,0,0,0)'
			disabled:
				color: new Color(color).alpha(.15)
				borderColor: new Color(color).alpha(.15)
				backgroundColor: new Color(backgroundColor).alpha(0)
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: color
				borderColor: new Color(backgroundColor).darken(20)
				backgroundColor: new Color(backgroundColor).darken(20)
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: color
				borderColor: new Color(backgroundColor).darken(20)
				backgroundColor: new Color(backgroundColor).darken(10)
				shadowColor: 'rgba(0,0,0,0)'
			}

	_showValue: (num) =>
		switch num
			when @min
				@buttons[0].disabled = true
				@buttons[1].disabled = false 
			when @max
				@buttons[0].disabled = false
				@buttons[1].disabled = true 
			else 
				@buttons[0].disabled = false
				@buttons[1].disabled = false

		@textLayer.text = num

	# ---------------
	# Public Methods


	# ---------------
	# Special Definitions

	@define 'value',
		get: -> return @_value 
		set: (num) ->
			return if @__constructor

			if not _.isNumber(num)
				throw 'Stepper.value must be a number.'
			
			num = _.clamp(num, @min, @max)
			
			return if num is @_value

			@_value = num

			@emit "change:value", num, @


