Framer.Extras.Hints.disable()

# Modules

Type = require 'Type'
{ Flow } = require 'Flow'
{ database } = require 'Database'
{ User } = require 'User'
{ View } = require 'View'
{ Icon } = require 'Icon'

# Colors

# set color overrides
{ colors } = require 'Colors'

_.assign colors,
	
	tint: '#FFF' 		# header link color
	bright: '#FFF'		# header title color
	medium: '#016a94'	# header background color
	
	# modal colors
	modalBackground:'#1a87c6'

	# chat colors
	chatBackground:'#FFF'
	chatFill: '#FAFAFA'
	choiceText: '#0183f3'
	choiceBackground: '#FFF'

	# modal colors
	cta: '#21aa99'
	chosen: '#000'
	suggested: 'rgba(0,0,0,.62)'
	
	# shared styles
	
	border: "#rgba(0,0,0,.2)"

# Helper Functions

Utils.timeUntil = (date) ->
	timeDifference = _.floor((date.getTime() - _.now()) / 60000)
	hours = _.floor(timeDifference / 60)
	minutes = timeDifference - (hours * 60)
	
	return {hours: hours, minutes: minutes}

# ----------------------------------------------
# Data Classes

# ----------------------------------------------

# Create Flow
flow = new Flow
flow.header.backgroundColor = colors.medium
flow.header.statusBar.invert = 100

# Create a User
user = database.user = new User

_.assign user,
	plans: []
	drafts: []


# Products View

productsView = new View
	title: 'Products'
	left: 
		icon: 'menu'


# Products View

productsView = new View
	title: 'Products'
	left: 
		icon: 'menu'



# ----------------------------------------------
# Start Flow

flow.bringToFront()
flow.showNext(productsView)