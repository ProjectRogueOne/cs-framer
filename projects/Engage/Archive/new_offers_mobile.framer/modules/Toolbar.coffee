# Toolbar
# Authors: Steve Ruiz
# Last Edited: 25 Sep 17

{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
Type = require 'Mobile'
App = require 'App'
app = App.app

class exports.Toolbar extends Layer
	constructor: (options = {}) ->
		
		# tab = {text: Str, icon: Str, view: Obj}
		@_tabs = []
		@_activeIndex = 0

		@showNames = options.showNames ? false

		super _.defaults options,
			name: 'Toolbar'
			width: Screen.width
			height: 48
			backgroundColor: 'rgba(255, 255, 255, .97)'
			shadowY: -1
			shadowColor: Colors.pale

		@onTap (event) -> event.stopPropagation()

	setTabs: (tabs = []) ->

		gap = ( @width - (tabs.length * 50) ) / tabs.length

		startX = gap / 2

		for tab, i in tabs
			
			showNames = @showNames ? true

			newTab = new Layer
				name: tab.text
				parent: @
				x: startX
				width: @height
				height: @height
				backgroundColor: null
				animationOptions: { time: .15 }

			newTab.view = tab.view

			newTab.icon = new Icon
				name: if @showNames then 'Icon' else '.'
				parent: newTab
				x: Align.center
				y: 5
				icon: tab.icon
				color: Colors.tint
				animationOptions: newTab.animationOptions

			newTab.text = new Type.Caption
				name: if @showNames then 'Text' else '.'
				parent: newTab
				x: 0, y: newTab.icon.maxY
				width: newTab.width
				textAlign: 'center'
				textTransform: 'capitalize'
				text: tab.text
				color: Colors.tint
				animationOptions: newTab.animationOptions

			newTab.onTap (event, layer) => 
				@active = layer.name

			@_tabs.push(newTab)

			startX += (50 + gap)

		@active ?= @_tabs[0].name

	showActiveTab: (direction) ->

		app = @parent

		if direction > 0
			app.transition(@_activeTab.view, app.showNextRight)
		else
			app.transition(@_activeTab.view, app.showNextLeft)

		@_activeTab.icon.animate { color: Colors.tint }
		@_activeTab.text.animate { color: Colors.tint }

		for tab in _.without(@_tabs, @_activeTab)
			tab.icon.animate { color: Colors.dim }
			tab.text.animate { color: Colors.dim }

	@define 'active',
		get: -> return @_activeTab
		set: (name) -> Utils.delay .05, =>
			tab = _.find(@_tabs, { 'name': name })

			return if not tab? or tab is @_activeTab

			@_activeTab = tab

			oldActiveIndex = @_activeIndex
			@_activeIndex = _.indexOf(@_tabs, tab)

			direction = @_activeIndex - oldActiveIndex
			@showActiveTab(direction)


	@define 'tabs',
		get: -> return @_tabs
		set: (tabs) ->
			layer.destroy() for layer in @_tabs
			@setTabs(tabs)
			@visible = @_tabs?.length > 0