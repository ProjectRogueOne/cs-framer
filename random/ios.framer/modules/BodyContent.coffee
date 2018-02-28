# Body Content

Type = require 'Type'
{ colors } = require 'Colors'

class exports.BodyContent extends Layer
	constructor: (options = {}) ->
		
		@content = options.content
		
		super _.defaults options,
			name: 'Body Content'
			backgroundColor: null
			width: options.parent?.width
			
		@body = new Type.Body
			name: 'Body'
			parent: @
			y: 32
			width: @width
			text: '{body}'
			
		@refresh()
		
	refresh: -> 
		@body.template = @content.body
		@height = @body.maxY + 32
