cs = require 'cs'
cs.Context.setMobile()

# ---------------------------------
# data

showMeLoans = undefined

phones = [
	{
		title: 'Apple'
		subtitle: 'iPhone 7 Plus'
		image: 'images/iphonex.png'
		price: 799
	}, {
		title: 'Samsung'
		subtitle: 'Galaxy 6'
		image: 'images/galaxy.png'
		price: 699
	}, {
		title: 'Essentials'
		subtitle: 'Essential Phone'
		image: 'images/essentials.png'
		price: 499
	}, {
		title: 'Apple'
		subtitle: 'iPhone 7 Plus'
		image: 'images/iphonex.png'
		price: 799
	}, {
		title: 'Samsung'
		subtitle: 'Galaxy 6'
		image: 'images/galaxy.png'
		price: 699
	}, {
		title: 'Essentials'
		subtitle: 'Essential Phone'
		image: 'images/essentials.png'
		price: 499
	}, {
		title: 'Essentials'
		subtitle: 'Essential Phone'
		image: 'images/essentials.png'
		price: 499
	}
]

# ---------------------------------
# helpers

hideAndShow = (layerA, layerB) ->
	layerA.onAnimationEnd _.once( -> 
		layerB.animate
			opacity: 1
			options:
				time: .2
				delay: .1
		)
	
	layerA.animate
		opacity: 0
		options:
			time: .175

	showMeLoans.animate
		y: layerB.maxY + 24
		options: 
			delay: .15

# ---------------------------------
# app

app = new cs.App
	type: 'safari'
	navigation: 'default'

view = new cs.View 
	showLayers: true

view.padding.top = 24

view.build ->
	
	@addToStack choice = new cs.SegmentControl
		width: 300
		x: Align.center
		segments: [
			{text: 'Choose a phone', action: -> hideAndShow(choosePrice, choosePhone)}
			{text: 'I know the price', action: -> hideAndShow(choosePhone, choosePrice)}
		]
		border: 'main'
	
	@addToStack choosePhone = new Layer
		width: @width
		backgroundColor: null
		
	do _.bind(-> # choosePhone
	
		@selectionTitle = new cs.Text
			name: 'selection title'
			parent: @
			y: 12
			width: @width
			textAlign: 'center'
			type: 'body'
			text: 'Apple'
			
		@selectionSubtitle = new cs.Text
			name: 'selection subtitle'
			parent: @
			y: @selectionTitle.maxY + 8
			width: @width
			textAlign: 'center'
			type: 'body1'
			text: 'iPhone 7'
			
			
		@carousel = new cs.Carousel
			name: 'Phones Carousel'
			parent: @
			x: Align.center
			y: @selectionSubtitle.maxY + 16
			width: @width
			height: 200
			shape: 'circle'
			originY: 1
			padding: 5
			opacityScale: 1.5
			scaleScale: .8
			
		@selectionPrice = new cs.Text
			name: 'selection price'
			parent: @
			y: @carousel.maxY + 16
			width: @width
			textAlign: 'center'
			type: 'body1'
			text: '£{value} RRP'
			
		@carousel.on "change:currentPage", (currentPage) =>
			@selectionTitle.text = currentPage.phone.title
			@selectionSubtitle.text = currentPage.phone.subtitle
			@selectionPrice.template = currentPage.phone.price
		
		for phone, i in phones
			newPage = new Layer
				name: phone.title + ' ' + phone.subtitle
				height: 200
				width: 150
				backgroundColor: null
				image: phone.image
				saturate: 0
				
			newPage.phone = phone
			
			@carousel.addPage(newPage)
			
		
		@height = @selectionPrice.maxY
		
	, choosePhone)
	
	choosePrice = new Layer
		parent: @content
		y: choosePhone.y
		width: @width
		backgroundColor: null
		opacity: 0
		
	do _.bind( -> # choosePrice
	
		@slider = new SliderComponent
			parent: @
			x: Align.center
			y: 32
			
		@height = @slider.maxY + 24
	
	, choosePrice)
	
	showMeLoans = new cs.Button
		parent: @content
		y: choosePhone.maxY + 24
		name: 'show me loans CTA'
		fill: 'tertiary'
		color: 'white'
		text: 'Show me the loans'
		type: 'body1'
		x: Align.center
	
	
app.showNext(view)