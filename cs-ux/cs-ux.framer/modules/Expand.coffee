# Expand Component

{ Colors } = require 'Colors'

class exports.Expand extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		@_fill
		options.fill ?= "white"

		@_border
		options.border ?= "grey"

		options.expanded ?= false
		@_expanded = options.expanded

		@_headerHeight = options.headerHeight ? 50
		@_contentHeight = 0

		@_paddingBottom
		options.paddingBottom ?= 16

		super _.defaults options,
			name: "Expand"
			height: @_headerHeight
			borderWidth: 2
			borderRadius: 4
			clip: true
			animationOptions:
				time: .25

		# layers

		@header = new Layer
			name: "header"
			parent: @
			width: @width
			height: @_headerHeight
			backgroundColor: null
			animationOptions:
				@animationOptions

		@content = new Layer
			name: "content"
			parent: @
			y: @_headerHeight
			width: @width
			height: 0
			backgroundColor: null
			animationOptions:
				@animationOptions

		delete @__constructor

		# events

		@on "change:expanded", (bool) ->
			if bool then @open() else @close()

		@content.on "change:children", @_setContentHeight

		# start
		@fill = options.fill
		@border = options.border
		@paddingBottom = options.paddingBottom

		@_setContentHeight()

		

	_setContentHeight: =>
		Utils.delay 0, =>
			lowest = _.maxBy(@content.children, 'maxY')

			@_contentHeight = (lowest?.maxY ? 0) + @paddingBottom
			@content.height = @_contentHeight

			@maxHeight = @headerHeight + @contentHeight

			@height = if @expanded then @maxHeight else @headerHeight

	open: ->
		@animateStop()
		@animate
			height: @maxHeight

	close: ->
		@animateStop()
		@animate
			height: @headerHeight

	@define "headerHeight",
		get: -> return @_headerHeight

	@define "contentHeight",
		get: -> return @_contentHeight

	@define "paddingBottom",
		get: -> return @_paddingBottom
		set: (num) ->
			return if @__constructor
			return if @_paddingBottom is num

			@_paddingBottom = num ? 0

	@define "expanded",
		get: -> return @_expanded
		set: (bool) ->
			return if @__constructor
			return if @_expanded is bool

			@_expanded = bool

			@emit "change:expanded", bool, @

	@define "fill",
		get: -> return @_fill
		set: (string) ->
			return if @__constructor
			@_fill = Colors.validate(string) ? Colors.primary
			@backgroundColor = @_fill

	@define "border",
		get: -> return @_border
		set: (string) ->
			return if @__constructor
			if typeof string isnt 'string'
				throw 'Border must be a string, like "primary".'
			
			color = Colors.validate(string) ? Colors.transparent

			@_border = color
			@borderColor = color

			@emit "change:border", string, @




