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
		if not app.empty then app.views.push(@)
		else app = undefined

		@_startScroll = undefined
		
		# set header options

		@left = options.left
		@right = options.right
		@title = options.title
		

		# set forced options

		_.assign options,
			scrollHorizontal: false
			contentInset: { top: 16, bottom: 32, left: 0, right: 0}
			shadowSpread: 1
			shadowColor: 'rgba(0,0,0,.16)'
		
		# set default options
		_.defaults options,
			name: @title ? 'View'
			backgroundColor: Colors.background
			onLoad: -> null
			showLayers: true

		super options

		@sendToBack()
		
		_.assign @,
			onLoad: options.onLoad
			rawInset: options.contentInset

		# events

		if app? and not app.current? then app.showNext(@)

		delete @__constructor
	
	enableScroll: ->
		return if @scrollVertical is true
		@scrollVertical = true

	disableScroll: ->
		return if @scrollVertical is false
		@scrollVertical = false

	_emitDistance: (event) =>
		currentY = @scrollPoint.y
		startY = @_startScroll?.y ? @scrollPoint.y
		distance = currentY - startY
		direction = if currentY < startY then 'down' else 'up'
		scrollY = @scrollY

		@emit "change:distance", distance, direction, scrollY, event, @