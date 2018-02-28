cs = require 'cs'
cs.Context.setMobile()
Framer.Extras.Hints.disable()

app = new cs.App
	type: 'safari'
	navigation: 'registration'
	collapse: true

user = {}

# K
landingView = new cs.View
	name: 'Landing View'
	backgroundColor: cs.Colors.main

landingView.build ->
	@addToStack new cs.Text
		text: 'There are four steps you now need to complete to get your free credit score & report:'
		color: 'white'
			
	@padding.left = 64
	@padding.stack = 32
	
	@addToStack new cs.Text 
		type: 'body'
		text: 'Personal details'
		color: 'white'
		
	@addToStack new cs.Text 
		type: 'body'
		text: 'Residential history'
		color: 'white'
		
	@addToStack new cs.Text 
		type: 'body'
		text: 'Employment status'
		color: 'white'
		
	@addToStack new cs.Text 
		type: 'body'
		text: 'Security questions'
		color: 'white'
		
	@padding.left = 16
	
	@addToStack new cs.Text 
		text: 'Create your account and agree to our terms and conditions, securely validate your identity, and then retrieve your credit score and report.'
		color: 'white'
	
	@padding.stack = 16
		
	@addToStack new cs.Button
		text: "Let's go"
		color: 'black'
		fill: 'white'
		type: 'body'
		size: 'full'
	
	@addToStack new cs.Text
		type: 'link'
		text: "Tell me a bit more"
		x: Align.center