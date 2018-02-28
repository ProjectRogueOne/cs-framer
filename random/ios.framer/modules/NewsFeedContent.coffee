# News Feed Content

{ database } = require 'Database'

class exports.NewsFeedContent
	constructor: (options = {}) ->
		@type = options.type ? _.sample(['comment'])
		@author = options.author ? database.users[0]
		@date = options.date ? new Date

		@case = options.case ? database.cases[0]
		@card = options.card ? database.cardContents[0]
		@comment = options.comment
		
		@photo = options.photo

		database.newsFeedContents.push(@)

# News feed content can be:

# General Notifications
# * new cases in your area

# New content on user's cases:
# * new cards for cases
# * new content for cards (image, text)

# Interactions with users's cards:
# * suggested edits
# * new comments
# * suggested content 

# Followed users' activity:
# * users you follow joining a case
# * users you follow joining a case
# * user you follow commenting on card