# Card Content

{ database } = require 'Database'

class exports.CardContent
	constructor: (options = {}) ->
		@uid = _.uniqueId()
		@heading = options.title ? 'Untitled Card'
		@subheading = options.subheading ? 'Subheading for Card'
		@body = options.body ? 'Lorem ipsum...'
		@lastEdited = options.lastEdited ? new Date
		@author = options.author ? _.sample(database.users)
		@comments = options.comments ? []
		@type = options.type ? 'text'
		@score = options.score ? _.random(-5,15)
		@photo = options.photo 
		
		database.cardContents.push(@)

