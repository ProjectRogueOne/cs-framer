Framer.Extras.Hints.disable()
require 'fraplin'

# Data

{ database } = require 'Database'
{ User } = require 'User'

database.user = new User
user = database.user

{ Case } = require 'Case'
{ Photo } = require 'Photo'
{ CardContent } = require 'CardContent'
{ NewsFeedContent } = require 'NewsFeedContent'

# Flow & Views

Flow = require 'Flow'
Flow.flow = new Flow.Flow

{ View } = require 'View'

# Cards and Content

Type = require 'Type'
{ Card } = require 'Card'
{ NewsFeedCard } = require 'NewsFeedCard'


# ----------------------------------------------
# Generate Data

database.users.push(new User) for i in [0..20]

database.cases.push(new Case) for i in [0..3]



# ----------------------------------------------
# Create Card Content

textCardContent0 = new CardContent

photoCardContent = new CardContent
	photo: new Photo

textCardContent1 = new CardContent

# ----------------------------------------------
# Create News Feed Content

newsFeedContent0 = new NewsFeedContent

# ----------------------------------------------

# Create Views & Cards

# news feed

newsFeed = new View
	title: 'News Feed'
	right: 
		icon: 'filter-variant'
		action: -> flow.showNext(filter)

for cardContent in database.newsFeedContents
	newsFeed.addCard new NewsFeedCard
		view: newsFeed
		content: cardContent
		
# filter

filter = new View
	title: 'Filter News Feed'
	left: 
		icon: 'chevron-left'
		text: 'back'
		action: -> flow.showPrevious()

filter.build ->
	@heading = new Type.H1
		parent: @content
		y: 0
		text: 'Filter'
	
	@body = new Type.Regular
		parent: @content
		width: @width - 32
		y: @heading.maxY + 16
		text: 'This is where the user would set a filter for their news feed. For now it will just demonstrate how the paging system works.'
		
		

# discover

discover = new View
	title: 'Discover'
	right: 
		icon: 'earth'
		action: -> flow.showNext(locationSelection)

for cardContent in database.cardContents
	discover.addCard new Card
		view: discover
		content: cardContent

# filter

locationSelection = new View
	title: 'Choose Location'
	left: 
		icon: 'chevron-left'
		text: 'back'
		action: -> flow.showPrevious()

locationSelection.build ->
	@heading = new Type.H1
		parent: @content
		y: 0
		text: 'Choose Location'
	
	@body = new Type.Regular
		parent: @content
		width: @width - 32
		y: @heading.maxY + 16
		text: 'This is where the user would choose a location for their discovery search. For now it will just demonstrate how the paging system works.'


# my cases

myCases = new View
	title: 'My Cases'
	right: 
		text: 'Edit'
		action: -> flow.showNext(editMyCases)
	
myCases.addCard new Card
	view: myCases
	content: database.cardContents[1]
	
# editMyCases

editMyCases = new View
	title: 'Choose Location'
	left: 
		icon: 'chevron-left'
		text: 'back'
		action: -> flow.showPrevious()

editMyCases.build ->
	@heading = new Type.H1
		parent: @content
		y: 0
		text: 'Edit My Cases'
	
	@body = new Type.Regular
		parent: @content
		width: @width - 32
		y: @heading.maxY + 16
		text: 'This is where the user would edit which cases they are subscribed to, and which they are receiving notifications for. For now it will just demonstrate how the paging system works.'


# profile

profile = new View
	title: 'Profile'
	right: 
		text: 'settings'
		action: -> flow.showNext(settings)

profile.build ->
	@heading = new Type.H1
		parent: @content
		y: 0
		text: 'Profile'
	
	@body = new Type.Regular
		parent: @content
		width: @width - 32
		y: @heading.maxY + 16
		text: 'This is where profile details would go, if there were any. No problem though: for now it will just demonstrate how the paging system works.'
		
# settings

settings = new View
	title: 'Settings'
	left: 
		icon: 'chevron-left'
		text: 'back'
		action: -> flow.showPrevious()

settings.build ->
	@heading = new Type.H1
		parent: @content
		y: 0
		text: 'Settings'
	
	@body = new Type.Regular
		parent: @content
		width: @width - 32
		y: @heading.maxY + 16
		text: 'This is where settings would go, if there were any. No problem though: for now it will just demonstrate how the paging system works.'



# ----------------------------------------------
# Start Flow

flow = Flow.flow

flow.footer.tabs = [
	{ 
		text: "feed" 
		icon: 'file-document-box'
		view: newsFeed 
	}, { 
		text: 'discover', 
		icon: 'compass-outline'
		view: discover 
	}, { 
		text: 'my cases', 
		icon: 'folder-outline'
		view: myCases 
	}, { 
		text: 'profile'
		icon: 'account' 
		view: profile 
	}
]


flow.bringToFront()
flow.showNext(newsFeed)
