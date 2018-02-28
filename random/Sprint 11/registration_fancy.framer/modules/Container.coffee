# Container
# Authors: Steve Ruiz
# Last Edited: 27 Sep 17

{ Colors } = require 'Colors'
{ Text } = require 'Text'


class exports.Container extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		# Size
		options.size ?= 'medium'
		@_size = options.size
		@_x = options.x

		switch options.size
			when "icon"
				options.size = {width: 70, height: 50}
			when "small"
				options.size = {width: 200, height: 50}
			when "medium"
				options.size = {width: 250, height: 50}
			when "large"
				options.size = {width: 355, height: 50}
			when "auto"
				options.size = {width: 999, height: 50}

		# Fill
		options.fill ?= 'primary'

		# Border
		options.border ?= 'transparent'

		
		super _.defaults options,
			name: 'Button'
			borderWidth: 2
			borderRadius: 4

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