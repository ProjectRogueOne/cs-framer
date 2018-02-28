# View
# Authors: Steve Ruiz
# Last Edited: 25 Sep 17

Type = require 'Mobile'
{ StackView } = require 'StackView'
{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
App = require 'App'

class exports.View extends StackView
	constructor: (options = {}) ->

		app = App.app

		@_startScroll = undefined
		
		# header
		@left = options.left
		@right = options.right
		@title = options.title
		
		@onLoad = options.onLoad ? -> null
		
		super _.defaults options,
			name: 'Stack View'
			size: Screen.size
			scrollHorizontal: false
			contentInset: app.contentInset ? { top: 16, bottom: 16 }
				
		@onScrollStart => @_startScroll = @scrollPoint
		@onScroll @setDistance
	
	setDistance: =>
		currentY = @scrollPoint.y
		startY = @_startScroll?.y ? @scrollPoint.y
		distance = currentY - startY

		@emit "change:distance", distance