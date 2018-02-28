# User

{ database } = require 'Database'
{ random } = require 'Helpers'

class exports.User
	constructor: (options = {}) ->
		@uid = _.uniqueId()
		@photo = Utils.randomImage()
		@firstName = options.firstName ? random.firstName()
		@lastName = options.lastName ? random.lastName()
		@location = options.location ? random.location()
		@joined = options.joined ? new Date

		@seen = [] # all content user has seen
		@actions = [] # actions taken by user, e.g. commenting

		@cases = [] # joined cases
		@following = [] # other users

	view: (uid) ->
		hasSeen = @getSeen(uid)

		if hasSeen?
			hasSeen.lastSeen = new Date
		else
			@seen.push {
				uid: uid
				firstSeen: new Date
				lastSeen: new Date
				lastAction: undefined
				comments: []
				vote: 0
			}

	getSeen: (uid) -> return _.find(@seen, {'uid': uid})

	# user data

	getFullName: -> return "#{@firstName} #{@lastName}"

	# votes

	getVote: (uid) -> 
		return @getSeen(uid).vote
	
	setVote: (uid, vote) -> 
		@getSeen(uid).vote = vote

	# comments

	getComments: (uid) -> 
		return @getSeen(uid).comments
	
	addComment: (uid, comment) -> 
		@getSeen(uid).comments.push(comment)
	
	editComment: (uid, comment, newContent) ->
		edited = _.find(@getSeen(uid).comments, {'uid': comment.uid})
		edited.content = newContent
		edited.editedDate = new Date


