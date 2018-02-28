require 'framework'

SHOW_ALL = true
SHOW_LAYER_TREE = false

# Setup
{ theme } = require 'components/Theme' # not usually needed

Canvas.backgroundColor = bg3
Framer.Extras.Hints.disable()

# dumb thing that blocks events in the upper left-hand corner
dumbthing = document.getElementById("FramerContextRoot-TouchEmulator")?.childNodes[0]
dumbthing?.style.width = "0px"

app = new App
	chrome: "safari"
	title: 'clearscore.com'

# Home View

homeView = new View
	title: 'Framework'
	padding: null

homeView.onLoad ->
	alerts.props =
		parent: @content
		x: 0
		y: 0
	
	alerts_small.props =
		parent: @content
		x: 0
		y: 0


app.showNext homeView