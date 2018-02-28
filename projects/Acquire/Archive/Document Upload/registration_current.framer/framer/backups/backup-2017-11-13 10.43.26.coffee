cs = require 'cs'
cs.Context.setMobile()
Framer.Extras.Hints.disable()

{ idealPostcodes } = require 'npm'

app = new cs.App
	type: 'safari'
	navigation: 'default'
	collapse: true

ALWAYS_RECOGNISE_USER = false

user = {}
