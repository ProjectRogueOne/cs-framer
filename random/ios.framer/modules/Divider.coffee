# Divider

{ colors } = require 'Colors'

class exports.Divider extends Layer
	constructor: (options = {}) ->
		super _.defaults options,
			name: '.'
			x: 0
			width: Screen.width - 64
			height: 1
			color: colors.dim