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

# View 

view = new cs.View

view.build ->
	
	new cs.Icon
		parent: @
		icon: 'folder'
		
	button = new cs.Button
		parent: this
		x: Align.center()
		y: 32
	
	new cs.Text
		parent: this
		y: button.maxY + 32
		x: Align.center()

# View 2

view2 = new cs.View

view2.build ->
	
	new cs.Text
		parent: this
		y: 32
		x: Align.center()


for view in app.views
	
	link =
		text: view.title
		view: view
	
	links.push link 

app.showNext(view)