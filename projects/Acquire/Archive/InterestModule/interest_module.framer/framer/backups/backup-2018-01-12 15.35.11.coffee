cs = require 'cs'
cs.Context.setMobile()
Framer.Extras.Hints.disable()

app = new cs.App
	type: 'safari'
	navigation: 'login'

# Data

carloans =
	image: 'images/offers/carloans.png',
	description: 'Knowing your credit score could net you a cheaper auto loan. Brill!'
	cta: 'Sign up and Learn More'

creditCards = 
	image: 'images/offers/creditcards.png', 
	description: 'Guaranteed credit . Brill!'
	cta: 'Sign up and Learn More'
	
energy = 
	image: 'images/offers/energy.png', 
	description: 'Knowing your credit score could net you a cheaper auto loan. Brill!'
	cta: 'Sign up and Learn More'

insurance = 
	image: 'images/offers/insurance.png', 
	description: 'Knowing your credit score could net you a cheaper auto loan. Brill!'
	cta: 'Sign up and Learn More'

loans = 
	image: 'images/offers/loans.png', 
	description: 'I bet we could get you a better personal loan, too.'
	cta: 'Sign up and Learn More'
	
mortgages = 
	image: 'images/offers/mortgages.png'
	description: 'Knowing your credit score could net you a cheaper auto loan. Brill!'
	cta: 'Sign up and Learn More'

# Financial Goals Module

class FinancialGoalsModule extends Layer
	constructor: (options = {}) ->

		_.defaults options,
			width: Screen.width

		super options
		
		offerOptions = _.shuffle(['carloans', 'creditcards', 'energy', 'insurance', 'loans', 'mortgages'])
		
		for offer in _.shuffle(['carloans', 'creditcards', 'energy', 'insurance', 'loans', 'mortgages'])
			
			offerLayer = new Layer
				parent: @
				

# Home View

class HomeView extends cs.View 
	constructor: (options={}) ->
		
		options.showLayers = true
		
		super options
		
		@contentInset = {top: 0}
		@padding.top = 0
		@backgroundColor = "#FFF"
		@content.backgroundColor = "#FFF"
		
		headerImage = new Layer 
			parent: @content
			width: @width
			height: @width * 839/545
			image: "images/dba4b6641193e9dcbcf5d1b906fa3cb1.jpg"
			
		headerCopy = new cs.H4
			parent: @content
			width: @width
			textAlign: 'center'
			text: "Your credit score and report. \nFor free, forever."
			y: 32
			
		@mainCTA = new cs.Button
			parent: @content
			y: headerCopy.maxY + 16
			x: Align.center()
			color: '#FFF'
			type: 'body'
			text: 'Sign up for free'
			size: 'small'
			
		module = new FinancialGoalsModule
			parent: @content
			y: headerImage.maxY
		
		Utils.delay .15, =>
			@scrollToPoint(
				x: 0, y: 999999
				false
				)

app.showNext(new HomeView)