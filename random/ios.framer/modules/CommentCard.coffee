# CommentCard

Type = require 'Type'
Helpers = require 'Helpers'
{ colors } = require 'Colors'

class exports.CommentCard extends Layer
	constructor: (options = {}) ->
		
		@content = options.content
		
		super _.defaults options,
			name: 'Comment'
			color: '#000'
			backgroundColor: null
		
		@authorName = new Type.Caption
			parent: @
			x: 0, y: 0
			color: colors.med
			text: @content.author.getFullName() + ', ' +
				Helpers.formatShortDate(@content.date)
		
		@body = new Type.Regular
			parent: @
			color: colors.bright
			x: 0, y: @authorName.maxY + 4
			text: @content.content
		
		@height = @body.maxY