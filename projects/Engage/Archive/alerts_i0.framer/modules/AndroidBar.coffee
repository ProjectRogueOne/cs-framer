# Android Bar
# Authors: Steve Ruiz
# Last Edited: 29 Sep 17

{ Text } = require 'Text'
{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
{ MobileHeader } = require 'MobileHeader'

class exports.AndroidBar extends MobileHeader
	constructor: (options = {}) ->
		@__constructor = true
		showNames = true

		{ app } = require 'App'

		options.fill ?= 'primary'
		options.color ?= 'white'
		options.icon ?= ''
		options.text ?= ''
		options.action ?= -> null

		super _.defaults options,
			width: Screen.width, height: 80
			color: Colors.validate(options.color) ? Colors.white
			shadowY: 2, shadowBlur: 3, shadowColor: 'rgba(0,0,0,.24)'

		# status bar

		@statusBar = new Layer
			name: if showNames then 'StatusBar' else '.'
			parent: @
			width: @width
			height: 24
			backgroundColor: 'rgba(255,255,255,.32)'

		@statusBarItems = new Layer
			name: if showNames then 'StatusBar' else '.'
			parent: @statusBar
			height: 14
			width: 94
			x: Align.right(-8)
			y: Align.center
			backgroundColor: null
			style: { lineHeight: 0 }
		
		@statusBarItems.html = """
				<svg width="100%" height="100%" viewBox="0 0 #{@statusBarItems.width} #{@statusBarItems.height}" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
				   
				    <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
				        <g id="Group" transform="translate(-15.000000, -5.000000)">
				            <rect id="bounds" x="0" y="0" width="118" height="24"></rect>
				            <g id="time" opacity="0.9" transform="translate(74.000000, 4.000000)" font-size="14" font-family=".AppleSystemUIFont" fill-opacity="0.600000024" fill="#{@color}" font-weight="normal">
				                <text id="12:30">
				                    <tspan x="0.083984375" y="14">12:30</tspan>
				                </text>
				            </g>
				            <g id="battery" transform="translate(55.000000, 4.000000)">
				                <polygon id="bounds" points="0 0 16 0 16 16 0 16"></polygon>
				                <polygon id="Shape" fill-opacity="0.600000024" fill="#{@color}" points="9 1.875 9 1 6 1 6 1.875 3 1.875 3 15 12 15 12 1.875"></polygon>
				            </g>
				            <g id="cellular" transform="translate(35.000000, 4.000000)">
				                <polygon id="bounds" points="0 0 16 0 16 16 0 16"></polygon>
				                <polygon id="Shape" fill-opacity="0.600000024" fill="#{@color}" points="0 15 14 15 14 1"></polygon>
				            </g>
				            <g id="wifi" transform="translate(14.000000, 4.000000)">
				                <polygon id="bounds" points="2 0 18 0 18 16 2 16"></polygon>
				                <path d="M0.977372085,4.01593123 C3.48821908,2.12256382 6.61301513,1 10,1 C13.3869849,1 16.5117809,2.12256382 19.0226279,4.01593123 L10,15 L0.977372085,4.01593123 Z" id="Shape" fill-opacity="0.600000024" fill="#{@color}"></path>
				            </g>
				        </g>
				    </g>
				</svg>
				"""
		
		@_closedHeight = @statusBar.height

		# icon

		@iconLayer = new Icon
			name: if showNames then 'Icon' else '.'
			parent: @
			backgroundColor: null
			x: 12
			y: 40
			icon: options.icon
			color: options.color
			animationOptions: @animationOptions
			action: options.action
			opacity: 0
		
		# title

		@titleLayer = new Text
			name: if showNames then 'Title' else '.'
			parent: @
			type: 'body'
			x: 72
			y: 40
			color: options.color
			text: options.text
			textTransform: 'capitalize'
			opacity: 0
			width: @width - 72

		# bottom nav

		@bottomNav = new Layer
			name: if showNames then 'Bottom Nav' else '.'
			height: 48
			width: Screen.width
			backgroundColor: '#000'

		@controls = new Layer
			name: 'Controls SVG'
			parent: @bottomNav
			backgroundColor: null
			height: 17
			width: 217
			x: Align.center
			y: Align.center
			style:
				lineHeight: 0

		@controls.html = """
			<svg 
				xmlns='http://www.w3.org/2000/svg' 
				width='100%' 
				height='100%' 
				viewBox='0 0 #{@controls.width} #{@controls.height}'
				>
					<path 
						d="M202.987704,1.98931197 C202.439436,1.98931197 201.993644,2.4353736 201.993644,2.98337224 L201.993644,14.9952517 C201.993644,15.5435194 202.439706,15.989312 202.987704,15.989312 L214.999584,15.989312 C215.547851,15.989312 215.993644,15.5432503 215.993644,14.9952517 L215.993644,2.98337224 C215.993644,2.43510451 215.547582,1.98931197 214.999584,1.98931197 L202.987704,1.98931197 Z M107.993644,15.989312 C111.859637,15.989312 114.993644,12.8553052 114.993644,8.98931197 C114.993644,5.12331872 111.859637,1.98931197 107.993644,1.98931197 C104.127651,1.98931197 100.993644,5.12331872 100.993644,8.98931197 C100.993644,12.8553052 104.127651,15.989312 107.993644,15.989312 Z M13.7660756,1.10241733 L1.21690631,8.35702959 C0.927718066,8.52420787 0.927677959,8.45629197 1.21690637,8.62349348 L13.7660759,15.8781062 C14.0542153,16.0446782 13.9936439,16.079742 13.9936439,15.7448743 L13.9936436,1.23564932 C13.9936436,0.900828227 14.0542573,0.935820879 13.7660756,1.10241733 Z"
						stroke-width: '2'
						stroke='#FFFFFF'
						fill='rgba(0,0,0,0)'
						/>
			</svg>
			"""	

		@rippleTapArea = new Layer
			name: 'Back'
			width: 100
			parent: @bottomNav
			x: @controls.x - 40
			height: @bottomNav.height
			borderRadius: @bottomNav.height / 2
			backgroundColor: 'rgba(255, 255, 255, .28)'
			opacity: 0

		do _.bind( -> # backTapArea

			@sendToBack()

			rippleStart = =>
				@props =
					scale: .7
					opacity: 0

				@animate
					scale: 1
					opacity: 1
					options:
						time: .15

			rippleEnd = =>
				@animate
					opacity: 0
					options:
						time: .55

			@onTapStart -> 
				rippleStart()

			@onTapEnd -> 
				rippleEnd()
				app?.showPrevious()

		, @rippleTapArea)
	
		# set app footer as bottomNav

		app.footer = @bottomNav

		delete @__constructor

		@on "change:factor", (factor) ->
			for layer in [@iconLayer, @titleLayer]
				layer.opacity = factor
				layer.y = Utils.modulate(
					factor, 
					[0, 1], 
					[0, 40], 
					true
				)

		@on "change:status", (status) ->
			switch status
				when 'open'
					for layer in [@iconLayer, @titleLayer]
						layer.animate { opacity: 1, y: 40 }
				when 'closed'
					for layer in [@iconLayer, @titleLayer]
						layer.animate { opacity: 0, y: 0 }

	shrink: =>
		{ app } = require 'App'
		@statusBar.parent = null
		app.header = @statusBar

	setHeader: (title, left, right) ->
		for layer in [@iconLayer, @titleLayer]
			layer.animate { opacity: 0, options: { time: .15 } }

		Utils.delay .2, =>
			title = title ? ''
			icon = left?.icon ? 'menu'
			action = left?.action ? -> null
			
			@iconLayer.visible = icon?
			@titleLayer.visible = title?

			@iconLayer.icon = icon
			@iconLayer.action = action
			@titleLayer.text = title
		
			for layer in [@iconLayer, @titleLayer]
				layer.animate { opacity: 1, options: { time: .25 } }