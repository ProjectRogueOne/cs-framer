require "gotcha/gotcha"
moreutils = require 'moreutils'
cs = require 'cs'


cs.Context.setMobile()
Framer.Extras.Hints.disable()

app = new cs.App
	type: 'safari'

homeView = new cs.View

app.showNext(homeView)