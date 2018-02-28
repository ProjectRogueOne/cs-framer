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

view.build ->
	
	new cs.Icon
		parent: @
		icon: 'folder'
		
	new cs.Button
		parent: this
		x: Align.center()
		y: 32
	
	new cs.TextL


for view in app.views
	
	link =
		text: view.title
		view: view
	
	links.push link 
