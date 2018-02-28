class exports.Divider extends Layer
	constructor: (options = {}) ->

		_.defaults options,
			name: 'Divider'
			width: 200
			height: 1,
			backgroundColor: black30

		super options