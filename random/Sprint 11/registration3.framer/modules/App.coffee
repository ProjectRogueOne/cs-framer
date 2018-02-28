# App
# Authors: Steve Ruiz
# Last Edited: 27 Sep 17

Type = require 'Mobile'
{ Colors } = require 'Colors'
{ SafariBar } = require 'SafariBar'
{ IOSBar } = require 'IOSBar'
{ MobileHeader } = require 'MobileHeader'
{ AndroidBar } = require 'AndroidBar'
{ Toolbar } = require 'Toolbar'

exports.app = {}

class exports.App extends FlowComponent
	constructor: (options = {}) ->
		@__constructor = true

		@_type
		@activeInput 
		@subnav

		@collapse = options.collapse
		@onChange = options.onChange ? (view) -> null
		@contentInset = options.contentInset ? {
			top: 0, bottom: 0, right: 0, left: 0
		}

		options.type ?= 'mobile'

		super _.defaults options,
			name: 'app'
			backgroundColor: 'rgba(247, 247, 247, 1)'
			animationOptions: { time: .15 }
		
		exports.app = @

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

		@onTransitionStart @changePages
		@onTransitionEnd -> @_subnav?.bringToFront()

		delete @__constructor

		@type = options.type

	changePages: (prev, next, direction) ->

		@contentInset =
			top: @subnav?.maxY ? @header?.maxY ? 16
			bottom: 16

		next.contentInset = @contentInset

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

		@onChange(next)

		next.on "change:distance", (distance) =>
			if @collapse and next is @current
				@header.setFactorByDistance(distance)

		next.onScrollEnd => 
			if @collapse and next is @current
				@header.setStatus(next.scrollPoint.y)

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

	browserBottomOverlay: (nav, layerA, layerB, overlay) =>
		layerB.height = Screen.height - @header.height
		layerB.footer?.y = Align.bottom

		options = {curve: "spring(300, 35, 0)"}

		transition =
			layerB:
				show: {
					options: {curve: "spring(300, 35, 0)"}, 
					x: Align.center, y: nav?.height - layerB?.height
				}
				hide: {
					options: {curve: "spring(300, 35, 0)"}, 
					x: Align.center, y: nav?.height
				}

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

	@define "type",
		get: -> return @_type
		set: (string) ->
			return if @__constructor

			if not _.includes(['mobile', 'safari', 'ios', 'android'], string) 
				throw 'Type must be either "mobile", "safari", "android" or "ios".'
			
			@footer?.destroy()
			@header?.destroy()

			switch string
				when 'mobile'  then @header = new MobileHeader
				when 'safari'  then @header = new SafariBar
				when 'ios'     then @header = new IOSBar
				when 'android' then @header = new AndroidBar

			@_subnav?.y = @header.maxY

			@header.on "change:height", =>
				@_subnav?.y = @header.maxY

			Utils.delay .15, => @changePages(null, @current)

			@emit "change:type", string

	@define "subnav",
		get: -> return @_subnav
		set: (layer) ->
			return if @__constructor
			@_subnav?.destroy()
			@_subnav = layer
			
			if layer?
				layer.props = 
					parent: @
					y: @header?.maxY ? 0
					shadowY: @header?.shadowY
					shadowColor: @header?.shadowColor
					shadowBlur: @header?.shadowBlur

				layer.bringToFront()

				@header?.shadowY = 0

			Utils.delay .15, => @changePages(null, @current)

