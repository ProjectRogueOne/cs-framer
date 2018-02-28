# Divider
# Authors: Steve Ruiz
# Last Edited: 20 Sep 17

class exports.Divider extends Layer
	constructor: (options = {}) ->

		super _.defaults options,
			name: 'Divider'
			width: options.parent?.width ? 200, height: 1,
			backgroundColor: '#EBE9E9'