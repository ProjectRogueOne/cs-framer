cs = require 'cs'
cs.Context.setMobile()
Framer.Extras.Hints.disable()

app = new cs.App
	type: 'safari'
	navigation: 'registration'
	collapse: true

user = {}

# Landing View

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

# Instructions View

instructionsView = new cs.View
	name: 'Instructions View'
	backgroundColor: cs.Colors.main

instructionsView.build ->
	
	@addToStack new cs.Text 
		text: 'There are four steps you now need to complete to get your free creadit score & report: create your account and agree to our terms and conditions, securely validate your identity, and then retrieve your credit score and report.'
		color: 'white'
		
	@addToStack new cs.Text 
		text: 'Accessing your credit report and credit score requires you to give us personal details and you must correctly answer some questions about your financial history.'
		color: 'white'
		
	@addToStack p3 = new cs.Text 
		text: 'You’ll need at least 2 years of UK address history and to have had accounts such as a credit card, loan, mortgage or utilities account linked to your current address.'
		color: 'white'
	
	p3.fontWeight= 600
	
	@addToStack new cs.Text 
		text: 'It’s a good idea to sign up somewhere you have easy access to your financial records. Please enter your details carefully and check them to ensure that they are accurate.'
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
		text: "I'd rather do it late"
		x: Align.center
		
app.showNext(instructionsView)