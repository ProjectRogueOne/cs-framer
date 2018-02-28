# Navigation
# Authors: Steve Ruiz
# Last Edited: 4 Oct 17

{ Colors } = require 'Colors'
{ NavButton } = require 'NavButton'
{ Subnav } = require 'Subnav'
{ Icon } = require 'Icon'
{ Logo } = require 'Logo'
{ Button } = require 'Button'
{ Progress } = require 'Progress'
{ Text } = require 'Text'
{ MenuOverlay } = require 'MenuOverlay'

class exports.Navigation extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		@showLayers = options.showLayers ? false

		{ app } = require "App"

		@_links
		options.links ?= []

		@_menuLinks
		options.menuLinks ?= [
			{icon: 'score2', text: 'Dashboard', action: -> null}
			{icon: 'report', text: 'Report', action: -> null}
			{icon: 'offers', text: 'Offers', action: -> null}
			{icon: 'timeline', text: 'Timeline', action: -> null}
			{icon: 'coaching', text: 'Coaching', action: -> null}
		]

		@_type
		options.type ?= 'default'

		options.toggleLinks ?= []

		# set forced options

		_.assign options,
			name: 'Navigation'
			width: Screen.width
			height: 70
			backgroundColor: Colors.navigation
			clip: true

		super options

		@_baseHeight = @height

		# layers

		@menuOverlay = new MenuOverlay
			links: options.menuLinks 

		# menu icon

		@menuIcon = new Icon
			name: if @showLayers then 'Menu Icon' else '.'
			parent: @
			x: 17, y: Align.center
			icon: 'cs-menu-s'
			color: 'white'
			visible: false

		# logomark

		@logomark = new Logo
			name: if @showLayers then 'Logomark' else '.'
			parent: @
			x: Align.center
			y: 26
			type: 'logomark'
			color: 'white'
			visible: false

		# account icon

		@accountIcon = new Icon
			name: if @showLayers then 'Account Icon' else '.'
			parent: @
			x: Align.right(-25)
			y: Align.center
			type: 'account'
			color: 'white'
			visible: false

		# login button

		@loginButton = new Text
			name: if @showLayers then 'Login Button' else '.'
			parent: @
			x: Align.right(-17)
			y: Align.center
			type: 'body'
			color: 'black'
			text: 'LOGIN'
			visible: false

		# progress stepper

		@progress = new Progress
			name: if @showLayers then 'Progress Stepper' else '.'
			parent: @
			size: @size
			visible: false

		# paged navigation

		@subnav = new Subnav
			name: if @showLayers then 'Sub-Navigation' else '.'
			parent: @
			y: @height
			visible: false

		# toggle buttons

		@toggleButtons = new Layer
			name: if @showLayers then "Toggle Buttons" else '.'
			parent: @
			width: @width
			height: 55
			y: Align.center
			backgroundColor: null
			visible: false

		do _.bind( -> # @toggleButtons

			@linkButtons = []

			for link in options.toggleLinks
				linkButton = new NavButton
					parent: @
					x: Align.center
					y: Align.center
					text: link.text
					type: 'caption'
					height: 34
					group: @linkButtons
					action: -> 
						app?.showNext(@view)

				linkButton.view = link.view

				linkButton.showToggled = ->
					if @isOn then @fill = 'white'
					else @fill = 'transparent'

				linkButton.showPressed = (isPressed) -> null

				Utils.delay 1, ->
					if app?.current is link.view
						linkButton.isOn = true
			
			Utils.distribute.horizontal(@, @linkButtons)

		, @toggleButtons)

		# events

		@menuIcon.onTap => @menuOverlay.show()

		@on "change:type", @setType
		@on "change:y", => @menuOverlay.y = @y

		# set properties that require the above layers

		delete @__constructor

		@links = options.links
		@type = options.type

	setType: ->
		layers = [
			@toggleButtons, @menuIcon, 
			@logomark, @loginButton, 
			@accountIcon, @progress
		]

		for layer in layers
			layer.visible = false

		switch @type
			when 'default'
				@menuIcon.visible = true
				@logomark.visible = true
				@logomark.color = 'white'
				@accountIcon.visible = true
			when 'login'
				@menuIcon.visible = true
				@logomark.visible = true
				@logomark.color = 'black'
				@loginButton.visible = true
			when 'registration'
				@progress.visible = true
			when 'toggle'
				@toggleButtons.visible = true

	@define "links",
		get: -> return @subnav.links
		set: (array) ->
			return if @__constructor

			if array.length > 0
				@subnav.visible = true
				@height = @_baseHeight + @subnav.height
			else
				@subnav.visible = false
				@height = @_baseHeight

			@subnav.links = array

	@define "type",
		get: -> return @_type
		set: (type) ->
			return if @__constructor

			validTypes = ['login', 'registration', 'default', 'toggle']
			if not _.includes(validTypes, type)
				throw "Navigation.type must be login', 'registration', 'toggle' or 'default'."

			@_type = type
			@emit "change:type", type, @

	@define "steps",
		get: -> return @progress.steps
		set: (value) ->
			@progress.steps = value

	@define "step",
		get: -> return @progress.step
		set: (value) ->
			@progress.step = value