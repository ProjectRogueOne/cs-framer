cs = require 'cs'
cs.Context.setMobile()
Framer.Extras.Hints.disable()

app = new cs.App
	type: 'safari'
	navigation: 'registration'
	collapse: true

user = {}

landingView = new cs.View
	name: 'Landing View'

landingView.build ->
	@addToStack new cs.Text
		text: 'There are four steps you now need to complete to get your free credit score & report:'
		
	@addToStack new cs.Text 
		text: 'Create your account and agree to our terms and conditions, securely validate your identity, and then retrieve your credit score and report.'