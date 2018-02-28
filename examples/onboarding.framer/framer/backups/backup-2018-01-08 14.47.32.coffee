cs = require 'cs'
cs.Context.setMobile()

# ---------------------------------
# app

app = new cs.App
	collapse: true
	type: 'safari'
	navigation: 'default'

# Setup

Screen.backgroundColor = cs.Colors.background
Framer.Extras.Hints.disable()

links = []

view = new cs.View

for view in app.views
	
	link =
		text: view.title
		view: view
	
	links.push link 
