# Accordian
# Authors: Steve Ruiz
# Last Edited: 6 Oct 17

{ Icon } = require 'Icon'
{ Text } = require 'Text'
{ Divider } = require 'Divider'
{ Container } = require 'Container'

class exports.Comment extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		_.defaults options,
			name: 'Comment'
			backgroundColor: '#ff54b2'
			height: 32, width: 32, borderRadius: 32
			opacity: .7
			visible: false
			animationOptions:
				time: .15
			title: 'Comment Title'
			body: "This is the comment's body."
			setup: false

		# set default properties

		super options

		# in setup mode, drag and announce point
		if options.setup 
			@draggable.enabled = true
			@visible = true
			@onMove -> print @point

		@base =
			x: @x
			y: @y
			height: @height
			width: @width
			borderRadius: @borderRadius
			opacity: @opacity

		# layers

		@titleLayer = new Text
			parent: @
			y: @height / 2 - 10
			type: 'body'
			color: '#FFF'
			text: "1"
			textAlign: "center"
			width: @width
			opacity: 1
			animationOptions: @animationOptions


		@bodyLayer = new Text
			parent: @
			x: 16
			y: 16
			type: 'body1'
			color: '#000'
			text: "This is the comment's body content."
			width: Screen.width - 48
			animationOptions: @animationOptions
			visible: false

		@closeButton = new Icon
			parent: @
			y: 4
			icon: 'close'
			color: 'white'
			opacity: 0
			visible: false
			animationOptions: @animationOptions

		delete @__constructor

		# events

		document.addEventListener "keydown", (event) => 
			if event.key is "`"
				@bringToFront()
				@visible = true

		document.addEventListener "keyup", (event) => 
			if event.key is "`"
				@sendToBack()
				@visible = false

		@closeButton.onTap (event) -> event.stopPropagation()
		@closeButton.onTap @close
		@onTap @open
	
	open: =>
		@animate
			x: 16
			height: @bodyLayer.maxY + 16
			width: Screen.width - 32
			borderRadius: 4
			opacity: 1

		@titleLayer.animate
			opacity: 0

		Utils.delay .25, => 
			@closeButton.visible = true
			@closeButton.x = Align.right(-4)
			@closeButton.animate
				opacity: 1

			@bodyLayer.visible = true
			@bodyLayer.animate
				opacity: 1

	close: =>

		@bodyLayer.animate
			opacity: 0
		
		@closeButton.animate
			opacity: 0

		Utils.delay .15, => 
			@animate @base

			@titleLayer.animate
				opacity: 1

			@closeButton.visible = false
			@bodyLayer.visible = false