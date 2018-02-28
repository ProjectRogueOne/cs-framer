cs = require 'cs'
cs.Context.setMobile()
Framer.Extras.Hints.disable()

puller = undefined
uploadFrontSide = undefined
uploadBackSide = undefined

app = new cs.App
	type: 'safari'
	collapse: true
	navigation: 'default'
	links: [
		{text: 'overview', view: reportView}
		{text: 'personal', view: reportView}
		{text: 'accounting', view: reportView}
	]

app.navigation.subnav.buttons[0].isOn = true

# report view

reportView = new cs.View
	showLayers: true
	backgroundColor: '#FFF'

reportView.build ->
	report.parent = @content
	
	tap_area.onTap ->
		app.showNext detailsView

reportView.onLoad = ->
	
	subnav2.animate
		opacity: 0
		options: 
			time: .1
			delay: .25
	
	content.animate
		opacity: 0
		options:
			time: .15
	
	subnav2.ignoreEvents = true


		
# details view

detailsView = new cs.View
	showLayers: true
	backgroundColor: '#FFF'

detailsView.build ->
	learning.parent = @content
	learning.point = {x: 0, y: 0}
	
	regButton = new cs.Button
		parent: @content
		x: Align.center
		y: learning.maxY
		width: @width - 32
		type: 'body'
		color: 'white'
		fill: 'rgba(5, 146, 188, 1.000)'
		text: 'Register for the Electoral Roll'
		action: -> null
	
	regLink = new cs.Text
		parent: @content
		x: Align.center
		y: regButton.maxY + 16
		type: 'link'
		color: 'rgba(5, 146, 188, 1.000)'
		text: "I'm already on the Electoral Roll"
		action: -> null

detailsView.onLoad = ->
	subnav2.bringToFront()
	subnav2.animate
		opacity: 1
		options:
			time: .15
	
	content.animate
		opacity: 1
		options:
			time: .1
			delay: .25
			
	subnav2.ignoreEvents = false

app.showNext reportView 

# subnav 2

subnav2 = app.navigation.subnav.copySingle()
child.destroy() for child in subnav2.children

subnav2.props =
	opacity: 0
	ignoreEvents: true
	shadowY: 3
	shadowColor: 'rgba(211, 123, 126, 1.000)'
	animationOptions:
		curve: "spring(300, 35, 0)"

content = new Layer
	parent: subnav2
	size: subnav2.size
	backgroundColor: null
	opacity: 0
	
backIcon = new cs.Icon
	parent: content
	x: 4
	y: Align.center
	icon: 'chevron-left'
	color: 'white'

backText = new cs.Text
	parent: content
	x: backIcon.maxX + 4
	y: Align.center
	type: 'body1'
	text: 'Back to report overview'
	color: 'white'

subnav2.y = app.navigation.subnav.screenFrame.y

app.header.on "change:height", ->
	subnav2.y = app.navigation.subnav.screenFrame.y

subnav2.onTap ->
	app.showPrevious()