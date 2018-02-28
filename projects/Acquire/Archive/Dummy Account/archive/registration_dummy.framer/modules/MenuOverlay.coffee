# Menu Overlay 
# Authors: Steve Ruiz
# Last Edited: 6 Oct 17

{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
{ Overlay } = require 'Overlay'
{ Text } = require 'Text'

# todo: make default menu buttons

# menu button function

MenuButton = (options = {}) ->

	_.defaults options,
		icon: 'account'
		text: 'Account'
		action: -> print 'Clicked!'

	frame = new Layer
		name: '.'
		backgroundColor: null
		width: 183
		height: 56
		x: options.x
		y: options.y

	iconLayer = new Layer
		parent: frame
		backgroundColor: null
		image: "modules/cs-ux-images/icons/#{options.icon}.png"
		width: 56
		height: 56
		invert: 100

	labelLayer = new Text
		parent: frame
		type: "subheader"
		x: iconLayer.maxX + 10
		y: Align.center
		text: options.text
		color: 'white'

	frame.onTap options.action

	return frame

# menu overlay class

class exports.MenuOverlay extends Overlay
	constructor: (options = {}) ->
		@__constructor = true
		@showLayers = options.showLayers ? false

		{ app } = require 'App'
		app.menuOverlay = @

		@buttons = []

		@_links
		options.links ?= [
			{icon: 'account', text: 'Account', action: -> null}
			{icon: 'coaching', text: 'Coaching', action: -> null}
		]

		# set forced properties

		_.assign options,
			name: 'Menu Overlay'
			parent: app
			size: Screen.size

		# set default properties

		super options
		
		delete @__constructor

		@on "change:links", @_makeButtons

		@links = options.links

	_makeButtons: ->
		button.destroy() for button in @buttons

		@buttons = []

		for link, i in @links
			button = new MenuButton link
			
			button.props =
				parent: @
				x: Align.center
				y: 127 + (85 * i)

			@buttons.push(button)

	show: ->
		@bringToFront()

		@height = Screen.height - @y

		Utils.distribute.vertical(@, @buttons, 29)

		@visible = true

		@animate
			opacity: 1
			options:
				curve: 'easeIn'

	hide: =>
		@animate
			opacity: 0
			options:
				curve: 'easeOut'

		Utils.delay .25, => @visible = false


	@define "links",
		get: -> return @_links
		set: (array) ->
			return if @__constructor

			if not _.isArray(array) then throw "Menu links must be an array."
			
			@_links = array

			@emit "change:links", array, @
