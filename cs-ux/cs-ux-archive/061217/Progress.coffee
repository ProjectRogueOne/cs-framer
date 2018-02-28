# Progress
# Authors: Steve Ruiz
# Last Edited: 1 Nov 17

Type = require 'Mobile'
{ Colors } = require 'Colors'
{ Text } = require 'Text'
{ Icon } = require 'Icon'

class StepperCircle extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		@_value
		@value = options.value ? 1

		_.defaults options,
			name: 'Step'
			height: 38, width: 38
			borderRadius: 19
			backgroundColor: Colors.white
			borderColor: Colors.grey

		super options

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

		_.assign @,
			_step: undefined
			_steps: []
			stepLaters = []

		@stepLayers = []
		
		_.defaults options,
			width: Screen.width
			height: 70
			backgroundColor: Colors.navigation
			size: 'medium'
			step: 1
			steps: 4

		super options

		margin = if options.size is 'medium' then 10 else 20

		@stepLabel = new Type.H2
			parent: @
			x: margin
			y: Align.center
			fontWeight: 400
			text: 'Step'

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
			@_makeSteps(steps)

		@on "change:step", (step) ->
			for layer in @stepLayers
				if layer.value is step then layer.showCurrent()
				else if layer.value < step then layer.showComplete()
				else layer.showIncomplete()

		delete @__constructor

		_.assign @,
			step: options.step
			steps: options.steps

	_makeSteps: (steps) ->
		step.destroy() for step in @stepLayers

		@stepLayers = []

		for step, i in _.range(steps)
			@stepLayers.push new StepperCircle
				parent: @
				value: i + 1
				y: Align.center

		Utils.distribute.horizontal(@, @stepLayers, 16)

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