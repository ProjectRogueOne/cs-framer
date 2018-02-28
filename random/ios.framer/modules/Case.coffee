# Case

{ database } = require 'Database'
{ random } = require 'Helpers'

class exports.Case
	constructor: (options = {}) ->
		@name = options.name ? 'Untitled Case'
		@author = options.author ? database.users[4]
		@location = options.location ? random.location()
		@date = options.date ? new Date
		@photo = options.photo ? if Math.random() > .5 then Utils.randomImage()
		@facts = options.facts ? []
		@leads = options.leads ? []
		@comments = options.comments ? []
		@subscribers = options.subscribers ? []
		@uid = _.uniqueId()

		database.cases.push(@)