class exports.Container extends Layer
	constructor: (options = {}) ->

		@_size = options.size
		options.size = undefined

		size = {}
		switch @_size
			when "large"
				size = {width: 355, height: 50}
			when "medium"
				size = {width: 250, height: 50}
			when "small"
				size = {width: 200, height: 50}

		super _.defaults options,
			borderRadius: 4
			size: size