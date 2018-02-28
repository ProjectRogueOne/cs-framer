cs = require 'cs'
cs.Context.setMobile()

# ---------------------------------
# data

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
	}
]

# ---------------------------------
# app

app = new cs.App
	type: 'safari'
	navigation: 'default'

view = new cs.View 
	showLayers: true

view.build ->
	
	@addToStack choice = new cs.SegmentControl
		width: 300
		x: Align.center
		segments: [
			{text: 'Choose a phone', action: -> null}
			{text: 'I know the price', action: -> null}
		]
	
	@addToStack choosePhone = new Layer
		width: @width
		backgroundColor: null
		
	do _.bind(-> # choosePhone
	
		@selectionTitle = new cs.Text
			name: 'selection title'
			parent: @
			y: 16
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
			shape: 'line'
			originY: 1
			opacityScale: 
			scaleScale: 1
		
		for phone, i in phones
			@carousel.addPage(
				new Layer
					height: 200
					width: 150
					backgroundColor: null
					hueRotate: i * 20
					image: phone.image
				)
			
		@carousel.on "change:currentPage", (currentPage) ->
			currentPage.animate
				scale: 1
			
			for sib in currentPage.siblings
				sib.animate
					scale: .5
			
		@height = @carousel.maxY

	
	, choosePhone)
app.showNext(view)