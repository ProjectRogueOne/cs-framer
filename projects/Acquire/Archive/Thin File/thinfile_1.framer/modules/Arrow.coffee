# Arrow
# Authors: Steve Ruiz
# Last Edited: 27 Sep 17

{ Icon } = require 'Icon'

class exports.Progress extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		options.direction ?= 'right'
		options.icon ?= 'chevron-right'

		super options