# Comment

{ database } = require 'Database'

class exports.Comment
	constructor: (options = {}) ->
		@uid = _.uniqueId()
		@author = options.author ? _.sample(database.users)
		@date = options.date ? new Date
		@editedDate = undefined
		@content = options.content ? 'This is another comment.'
		@replies = []
		@score = 0