# Tabbed View

Type = require 'Type'
colors = require "Colors"

class TabbedView extends PageComponent
	constructor: (options = {}) ->

		# tab = {text: Str, icon: Str, view: Obj}
		@_tabs = []
		@_activeIndex = 0

		@showNames = options.showNames ? false

		super _.defaults options,
			size: Screen.size

		@tabContainer = new Layer
			name: if @showNames then 'Tabs' else '.'
			parent: @
			width: @width
			height: 128

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

			newTab.text = new Type.Link
				name: if @showNames then 'Text' else '.'
				parent: newTab
				x: 0, y: Align.center
				width: newTab.width
				textAlign: 'center'
				textTransform: 'capitalize'
				text: tab.text
				color: colors.tint
				animationOptions: newTab.animationOptions

			newTab.onTap (event, layer) => 
				@active = layer.name

			@_tabs.push(newTab)

			startX += (50 + gap)

		@active ?= @_tabs[0].name