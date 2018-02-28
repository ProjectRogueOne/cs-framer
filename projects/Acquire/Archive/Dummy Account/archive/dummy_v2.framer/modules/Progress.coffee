# Progress
# Authors: Steve Ruiz
# Last Edited: 27 Sep 17

Type = require 'Mobile'
{ Colors } = require 'Colors'
{ Text } = require 'Text'
{ Icon } = require 'Icon'

class StepperCircle extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		@value = options.value ? 1

		super _.defaults options,
			name: 'Step'
			height: 38, width: 38
			borderRadius: 19
			backgroundColor: Colors.white
			borderColor: Colors.grey

		@icon = new Icon
			parent: @
			type: 'check'
			color: "white"
			point: Align.center
			visible: false

		@number = new Type.MediumBold
			parent: @
			y: Align.center
			width: @width
			textAlign: 'center'
			text: @value

		delete @__constructor

	showIncomplete: ->
		@borderWidth = 0
		@icon.visible = false
		@number.visible = true
		@backgroundColor = Colors.white

	showCurrent: ->
		@borderWidth = 1
		@icon.visible = false
		@number.visible = true
		@backgroundColor = Colors.white

	showComplete: ->
		@borderWidth = 0
		@icon.visible = true
		@number.visible = false
		@backgroundColor = Colors.secondary

class exports.Progress extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		@_step
		@_steps
		
		options.size ?= 'medium'
		options.step ?= 1
		options.current ?= 1
		options.steps ?= 4

		super _.defaults options,
			width: Screen.width
			height: 70
			backgroundColor: Colors.navigation

		margin = if options.size is 'medium' then 10 else 20

		@stepLabel = new Type.H2
			parent: @
			x: margin
			y: Align.center
			fontWeight: 400
			text: 'Step'

		@stepper = new Layer
			parent: @
			height: 38
			x: 88
			y: Align.center
			backgroundColor: null

		@stepper.stepLayers = []

		@accountIcon = new Icon
			parent: @
			type: 'account'
			x: Align.right(-margin - 8)
			y: Align.center

		@createYourAccount = new Type.H2
			parent: @
			y: Align.center
			fontSize: 20
			fontWeight: 400
			text: 'Create Your Account'
			visible: options.size is 'large'

		@createYourAccount.maxX = @accountIcon.x - 20

		@on "change:steps", (steps) ->
			@makeSteps(steps)

		@on "change:step", (step) ->
			for layer in @stepper.stepLayers
				if layer.value is step then layer.showCurrent()
				else if layer.value < step then layer.showComplete()
				else layer.showIncomplete()

		delete @__constructor

		@steps = options.steps
		@step = options.step

	makeSteps: (steps) ->
		do _.bind( -> # @stepper

			step.destroy() for step in @stepLayers

			@stepLayers = []

			for step, i in _.range(steps)
				@stepLayers.push new StepperCircle
					parent: @
					x: 54 * i
					value: i + 1

			@width = _.last(@stepLayers).maxX

		, @stepper)

	@define "steps",
		get: -> return @_steps
		set: (value) ->
			return if @__constructor

			value = _.clamp(value, 1, Infinity)
			@_steps = value

			@emit "change:steps", value, @

	@define "step",
		get: -> return @_step
		set: (value) ->
			return if @__constructor
			value = _.clamp(value, 1, @steps + 1)

			@_step = value

			@emit "change:step", value, @