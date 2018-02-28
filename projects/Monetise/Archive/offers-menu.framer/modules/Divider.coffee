# Divider
# Authors: Steve Ruiz
# Last Edited: 25 Sep 17

{ Colors } = require 'Colors'

class exports.Divider extends Layer
	constructor: (options = {}) ->

		super _.defaults options,
			name: 'Divider'
			width: 200, height: 1,
			backgroundColor: Colors.divider