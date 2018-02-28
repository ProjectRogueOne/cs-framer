# Body Content

Type = require 'Type'
{ colors } = require 'Colors'
{ database } = require 'Database'

class exports.Photo
	constructor: (options = {}) ->
		@uid = _.uniqueId()
		@author = options.author ? _.sample(database.users)
		@caption = options.caption ? "This is the photo's caption."
		@date = options.date ? new Date
		@image = options.image ? Utils.randomImage()