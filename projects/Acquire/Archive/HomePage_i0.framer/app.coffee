require "gotcha/gotcha"
require 'cs'

# Setup

Canvas.backgroundColor = '#000'

# ----------------
# custom stuff

# ----------------
# data

# User

user =
	name: 'Charlie Rogers'
	age: 28
	sex: Utils.randomChoice(['female', 'male', 'nonbinary'])
	date: new Date


# ----------------
# implementation

app = new App

# View 
view = new View

pageTransitionComponent = new PageTransitionComponent
	parent: view
	y: app.header.height
	height: Screen.height - app.header?.height - app.footer?.height
	width: Screen.width
	scrollHorizontal: false

page1 = pageTransitionComponent.newPage({name: 'page1', backgroundColor: '#ef8a7d'})
page2 = pageTransitionComponent.newPage({name: 'page2', backgroundColor: '##e4e391'})
page3 = pageTransitionComponent.newPage({name: 'page3', backgroundColor: '#9abd8a'})

app.showNext(view)



app.showNext(view)