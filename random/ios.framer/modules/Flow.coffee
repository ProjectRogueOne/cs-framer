# Flow

{ colors } = require 'Colors'
{ NavigationBar } = require 'NavigationBar'
{ Toolbar } = require 'Toolbar'

class exports.Flow extends FlowComponent
	constructor: (options = {}) ->

		@activeInput = undefined

		super _.defaults options,
			name: 'Flow'
			backgroundColor: 'rgba(247, 247, 247, 1)'
			animationOptions: { time: .15 }
		
		@header = new NavigationBar

		@keyboard = new Layer
			name: 'Keyboard'
			y: @height
			width: @width
			height: @width * 450/750
			image: "images/ios9-iphone-disable-lower-case-keyboard-2.png"
			animationOptions: @animationOptions
				
		@keyboard.onTap @closeKeyboard

		@footer = new Toolbar
			visible: false

		@onTransitionStart (prev, next, direction) ->
			@header.fadeTo =>
				@header.setHeader
					side: 'left'
					icon: next.left?.icon
					text: next.left?.text
					action: next.left?.action
						
				@header.setHeader
					side: 'right'
					icon: next.right?.icon
					text: next.right?.text
					action: next.right?.action
				
				@header.setHeader
					title: next?.title
			
			if next.refresh? then next.refresh()

	showNextRight: (nav, layerA, layerB, overlay) ->
		options = {curve: "spring(300, 35, 0)"}

		transition =
			layerA:
				show: {options: options, x: 0, y: 0}
				hide: {options: options, x: 0 - layerA?.width / 2, y: 0}
			layerB:
				show: {options: options, x: 0, y: 0}
				hide: {options: options, x: layerB.width, y: 0}

	showNextLeft: (nav, layerA, layerB, overlay) ->
		options = {curve: "spring(300, 35, 0)"}

		transition =
			layerA:
				show: {options: options, x: 0, y: 0}
				hide: {options: options, x: 0 + layerA?.width / 2, y: 0}
			layerB:
				show: {options: options, x: 0, y: 0}
				hide: {options: options, x: -layerB.width, y: 0}

	openKeyboard: () => 
		@footer.visible = false
		return if Utils.isMobile()

		@keyboard.bringToFront()
		@animate { y: -@keyboard.height }
		@keyboard.animate { y: Screen.height - @keyboard.height }
			
	closeKeyboard: => 
		@footer.visible = true
		@animate { y: 0 }
		@keyboard.animate { y: Screen.height }

exports.flow = {}