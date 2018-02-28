cs = require 'cs'
cs.Context.setStandard()

# ---------------------------------
# app

# furniture

background = new Layer
	backgroundColor: '#FFF'
	width: Screen.width
	height: Screen.height

header = new Layer
	height: 100
	backgroundColor: '#FFF'
	width: Screen.width
	shadowY: 1
	shadowColor: '#CCC'
	
do _.bind(-> # header

	@logo = new cs.Logo
		parent: @
		type: 'logomark'
		x: 72
		y: Align.center

, header)

window.addEventListener "resize", Utils.debounce(.1, ->
	header.width = Screen.width
)