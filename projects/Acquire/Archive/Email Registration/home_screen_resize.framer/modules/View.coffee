# View
# Authors: Steve Ruiz
# Last Edited: 6 Oct 17

Type = require 'Mobile'
{ StackView } = require 'StackView'
{ Colors } = require 'Colors'
{ Icon } = require 'Icon'

class exports.View extends StackView
	constructor: (options = {}) ->
		@__constructor = true

		{ app } = require 'App'
		app?.views.push(@)

		@_startScroll = undefined
		
		# set header options

		@left = options.left
		@right = options.right
		@title = options.title
		
		@onLoad = options.onLoad ? -> null

		# set forced options

		_.assign options,
			size: Screen.size
			scrollHorizontal: false
			contentInset: app.contentInset ? { top: 16, bottom: 16 }
			shadowSpread: 1
			shadowColor: 'rgba(0,0,0,.16)'
		
		# set default options

		super _.defaults options,
			name: @title ? 'View'
			backgroundColor: Colors.background

		# events

		@onScrollStart => @_startScroll = @scrollPoint
		@onScroll @setDistance

		if not app?.current? then app.showNext(@)

		delete @__constructor
	
	setDistance: =>
		currentY = @scrollPoint.y
		startY = @_startScroll?.y ? @scrollPoint.y
		distance = currentY - startY

		@emit "change:distance", distance, @