# Card
# Authors: Steve Ruiz
# Last Edited: 30 Oct 17

{ Colors } = require 'Colors'
{ Container } = require 'Container'
{ Text } = require 'Text'
{ Button } = require 'Button'
{ Donut } = require 'Donut'

class exports.Card extends Container
	constructor: (options = {}) ->
		@__constructor = true

		@_type
		options.type ?= "recommended" # recommended, active, complete, coming soon

		@_title
		options.title ?= "build"

		@_subtitle
		options.subtitle ?= "Build a great credit score and report from scratch."

		@_steps
		options.steps ?= [
			{text: "review coaching chat"}, 
			{text: "review task list"}, 
			{text: "products suitable for me"}
		]

		@leftLink
		options.leftLink ?= 'Stop plan'

		@centerLink
		options.centerLink ?= 'Notify me'

		@rightLink
		options.rightLink ?= 'Restart plan'

		@centerDetail
		options.centerDetail ?= 'When this plan is ready'

		@_step
		options.step ?= 1

		super _.defaults options,
			name: "Expand"
			width:  278
			height: 390  
			fill: "white"
			clip: true
			animationOptions:
				time: .25

		@flag = new Layer
			parent: @
			x: Align.right
			height: 78
			width: 78
			backgroundColor: null
			style:
				lineHeight: '0px'
				padding: '0px'
		
		@flag.html = """
			<svg viewport='0 0 #{@flag.width} #{@flag.height}'>
				<polyline points="0,0 84,84, 84,0 z" fill="#CCC">
			</svg>
		"""

		# recommended layers

		@coverIcon = new Layer
			parent: @
			y: 25, x: Align.center
			width: 150
			height: 150
			borderRadius: 75

		@coverTitle = new Text
			parent: @
			y: @coverIcon.maxY + 25
			type: 'button'
			width: @width
			textAlign: "center"

		@coverSubtitle = new Text
			parent: @
			y: @coverTitle.maxY + 10
			type: 'subheader'
			width: @width
			textAlign: "center"

		# active layers

		@progress = new Donut
			parent: @
			size: "icon"
			x: 32, y: 25
			fill: "white"
			min: 1
			max: options.steps.length
			value: options.step

		@button = new Button
			parent: @
			x: Align.center
			y: Align.bottom(-30)
			type: 'body1'
			fill: 'tertiary'
			color: 'white'
			text: 'Start Plan'


		delete @__constructor