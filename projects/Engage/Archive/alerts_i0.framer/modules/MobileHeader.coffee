# MobileHeader
# Authors: Steve Ruiz
# Last Edited: 27 Sep 17

# A root template for other headers

Type = require 'Mobile'
{ Colors } = require 'Colors'
{ Icon } = require 'Icon'

class exports.MobileHeader extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		showNames = options.showNames ? false
		
		@_fill
		@_status
		@_closedFill
		@_collapse
		@factor = 1
		@status = undefined

		options.fill ?= 'white'
		options.closedFill ?= options.fill
		options.collapse ?= false

		super _.defaults options,
			width: Screen.width
			height: 64
			backgroundColor: Colors.validate(options.fill)
			shadowY: 2
			shadowColor: 'rgba(0,0,0,.16)'
			shadowBlur: 3
			clip: true
			animationOptions: { time: .17 }
		
		@_fullHeight = @height
		@_closedHeight = options.closedHeight ? 20

		delete @__constructor

		@fill = options.fill
		@closedFill = options.closedFill
	
	setHeader: (args) => @emit "load", args
	
	setFactorByDistance: (distance, direction, scrollY) ->

		@factor = undefined

		if scrollY <= 0
			@open()
			return

		if direction is 'up' and @status isnt "closed"
			@factor = Utils.modulate(
				distance, 
				[@_fullHeight, 0],
				[0, 1], 
				true
				)

		if direction is 'down' and @status isnt "open"
			@factor = Utils.modulate(
				scrollY, 
				[@_fullHeight, 0], 
				[0, 1], 
				true
				)

		if @factor?
			@setHeightByFactor()
			@setFillByFactor()
			@setStatusByFactor()

	setHeightByFactor: ->
		return if not @_collapse

		@height = Utils.modulate(
			@factor, 
			[0, 1], 
			[@_closedHeight, @_fullHeight], 
			true
		)

		@emit "change:factor", @factor

	setStatusByFactor: ->
		switch @factor
			when 1 then @status = 'open'
			when 0 then @status = 'closed'
			else @status = 'transitioning'

	setFillByFactor: ->
		return if not @_collapse

		@backgroundColor = Color.mix(
			@closedFill,
			@fill,
			@factor
			)
			
	setStatus: (scrollY) ->	
		return if not @_collapse
		
		@animateStop()

		if @height > (@_fullHeight / 2) or scrollY < 0
			@open()
		else if @height <= (@_fullHeight / 2)
			@close()

	open: =>
		return if @status is 'open'

		@animate 
			height: @_fullHeight
			backgroundColor: @_fill

		@status = 'open'
		
	close: ->
		return if @status is 'closed'

		@animate
			height: @_closedHeight
			backgroundColor: @closedFill

		@status = 'closed'

	
	fadeTo: (callback) -> null # delete

	@define "status",
		get: -> return @_status
		set: (string) ->
			@_status = string
			
			@emit "change:status", @status, @

	@define "collapse",
		get: -> return @_collapse
		set: (bool) ->
			@_collapse = bool

	@define "fill",
		get: -> return @_fill
		set: (value) ->
			return if @__constructor

			value = Colors.validate(value)
			@_fill = value

			@setFillByFactor()
			@emit "change:fill", @fill

	@define "closedFill",
		get: -> return @_closedFill
		set: (value) ->
			return if @__constructor

			value = Colors.validate(value)
			@_closedFill = value
			if @status is 'closed' then @setFillByFactor()
