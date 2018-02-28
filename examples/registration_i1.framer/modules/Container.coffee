# Container
# Authors: Steve Ruiz
# Last Edited: 6 Oct 17

{ Colors } = require 'Colors'
{ Text } = require 'Text'


class exports.Container extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		# Size
		options.size ?= 'medium'
		@_size = options.size

		# Fill
		@_fill
		options.fill ?= 'primary'

		# Border
		@_border
		options.border ?= 'transparent'

		# set size

		sizes =
			icon:	{ width: 70,  height: 50 }
			small:	{ width: 200, height: 50 }
			medium:	{ width: 250, height: 50 }
			large:	{ width: 355, height: 50 }
			auto:	{ width: 999, height: 50 }
			full:	{ width: Screen.width - 24, height: 50 }

		size = sizes[options.size] ? sizes['medium']

		options.height ?= size.height
		options.width ?= size.width

		delete options.size
		
		super _.defaults options,
			name: 'Container'
			borderWidth: 2
			borderRadius: 4

		if @_size is 'full' and @parent?

			@x = @parent.padding.left
			@width = @parent.width - (@parent.padding.left + @parent.padding.right)

		delete @__constructor 

		@fill = options.fill
		@border = options.border

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