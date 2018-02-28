cs = require 'cs'
cs.Context.setMobile()
Framer.Extras.Hints.disable()

app = new cs.App
	type: 'safari'
	navigation: 'login'

# Data

offers =
	carloans: {
		title: 'Auto Loans'
		image: 'images/offers/carloans.png',
		description: 'Knowing your credit score could net you a cheaper auto loan. Brill!'
		cta: 'Sign up and Learn More'},

	creditCards: {
		title: 'Credit Cards'
		image: 'images/offers/creditcards.png', 
		description: 'Guaranteed credit cards, without the risk of a credit check. Nuts!'
		cta: 'Sign up and Learn More'},
		
	energy: {
		title: 'Energy'
		image: 'images/offers/energy.png', 
		description: 'Get a better deal on electric and gas. Power overwhelming!'
		cta: 'Sign up and Learn More' },
	
	insurance: {
		title: 'Insurance'
		image: 'images/offers/insurance.png', 
		description: 'Balancing your risks and mine, united by knowledge and financial health. Epic!'
		cta: 'Sign up and Learn More' },
	
	loans: {
		title: 'Personal Loans'
		image: 'images/offers/loans.png', 
		description: 'I bet we could get you a better personal loan, too.'
		cta: 'Sign up and Learn More' },
		
	mortgages: {
		title: 'Mortgages'
		image: 'images/offers/mortgages.png'
		description: 'Sell the house, sell the wife, sell the kids – and get a better rate with our offers.'
		cta: 'Sign up and Learn More'}

# Financial Goals Module

class FinancialGoalsModule extends Layer
	constructor: (options = {}) ->

		_.defaults options,
			width: Screen.width
			backgroundColor: null

		super options
		
		# title
		
		
		
		
		# icon buttons
		
		count = _.entries(offers).length
		
		i = 0
		for offer, data of offers
			
			offerLayer = new Layer
				parent: @
				width: ((@width-32) / count) * 2
				y: 64 + (128 * Math.floor(i/(count/2)))
				x: 16 + i % (count / 2) * (@width-32) / (count/2)
				backgroundColor: null
			
			icon = new Layer
				parent: offerLayer
				x: Align.center()
				width: offerLayer.width
				height: offerLayer.width
				image: data.image
				backgroundColor: null
				
			i++
		
		
			
		@height = _.maxBy(@children, 'maxY')?.maxY

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
				
			@updateContent()
			@scrollToPoint(
				x: 0, y: 999999
				false
				)

app.showNext(new HomeView)