# View
# Authors: Steve Ruiz
# Last Edited: 25 Sep 17

Type = require 'Mobile'
{ StackView } = require 'StackView'
{ Colors } = require 'Colors'
{ Icon } = require 'Icon'

class exports.View extends StackView
	constructor: (options = {}) ->

		{ app } = require 'App'
		app.views.push(@)

		@_startScroll = undefined
		
		# header
		@left = options.left
		@right = options.right
		@title = options.title
		
		@onLoad = options.onLoad ? -> null

		_.assign options,
			size: Screen.size
			scrollHorizontal: false
			contentInset: app.contentInset ? { top: 16, bottom: 16 }
			shadowSpread: 1
			shadowColor: 'rgba(0,0,0,.16)'
		
		super _.defaults options,
			name: @title ? 'View'
				
		@onScrollStart => @_startScroll = @scrollPoint
		@onScroll @setDistance
	
	setDistance: =>
		currentY = @scrollPoint.y
		startY = @_startScroll?.y ? @scrollPoint.y
		distance = currentY - startY

		@emit "change:distance", distance