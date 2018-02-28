require 'cs'

app = new App 
	title: "Clearscore"

user =
	submittedSAR: false
	
# Setup
Canvas.backgroundColor = bg3

# 0.0.0 Account Page View

accountPageView = new View
	title: 'Framework'
	key: "0.0.0"
	padding: 
		left: 10
		right: 10

accountPageView.onLoad ->
	
	if user.submittedSAR
		@key = "0.0.1"
	else
		@key = "0.0.0"
	
	background = new Layer
		parent: @content, 
		y: -796
		x: 0
		height: 1417 * @width / 400
		image: myAccountImage.image
		
	
	blocker = new Layer
		parent: @content
		x: 0, y: 456
		height: 142
		backgroundColor: white
	
	background.width = @width
	blocker.width = @width
	
	
	# link
	
	title = new Body
		parent: @content
		y: blocker.y + 16
		text: "Subject Access Request"
		color: brand
	
	body = new Body
		parent: @content
		y: title.maxY
		fontWeight: 500
		text: "Request your data from ClearScore"
		color: brand
		
	link = new Body2Link
		parent: @content
		y: body.maxY - 16
		color: orange
		fontWeight: 600
		textDecoration: "underline"
		x: 10
		text: "Request my Data"
		select: -> app.showNext(sarView)	
	
	if user.submittedSAR
		noto = new Layer
			parent: @
			height: 100
			width: @width
			backgroundColor: blue
		
		notoText = new Body2
			parent: noto
			x: 15
			y: 15
			width: @width - 30
			color: white
			fontWeight: 500
			text: "Your subject access request has been sent. We'll email you soon with the data you requested."
			
		noto.height = notoText.maxY + 15
		
		noto.onTap -> noto.destroy()

# 1.0.0 SAR View

sarView = new View
	title: 'Framework'
	key: "1.0.0"
	padding: 
		left: 10
		right: 10

sarView.onLoad ->
	title = new H1
		parent: @content
		y: 64
		text: "Subject Access Request"
		fontWeight: 500
	
	title = new H2
		parent: @content
		y: title.maxY + 30
		text: "What is a Subject Access Request?"
		fontWeight: 500
		
	body = new Body
		parent: @content
		width: @width - 20
		text: "A subject access request refers to your right to see the information ClearScore holds on you. You will receive a short document which will tell you: \n\n- the copy of the information we hold about you, e.g. your personal information or any activity you’ve done on the site\n\n- where this information has come from\n\n- what the information is used for, how it’s processed and whether we will pass this information anywhere"
	
	Utils.offsetY([title, body], 15)
	
	title = new H2
		parent: @content
		y: body.maxY + 30
		text: "Will I get a copy of my report?"
		fontWeight: 500
	
	body = new Body
		parent: @content
		width: @width - 20
		text: "SAR relates only to the information which ClearScore holds on you. Your report is held with Equifax and we show you the information through our service. We will not be able to provide you with a PDF copy of your report."
	
	Utils.offsetY([title, body], 15)
	
	title = new H2
		parent: @content
		y: body.maxY + 30
		text: "How long will SAR take?"
		fontWeight: 500
	
	body = new Body
		parent: @content
		width: @width - 20
		text: "We aim to respond to all subject access request within 7 days, and it will never take longer than 40 days."
	
	Utils.offsetY([title, body], 15)
	
	title = new H2
		parent: @content
		y: body.maxY + 30
		text: "How do I make a SAR?"
		fontWeight: 500
	
	body = new Body
		parent: @content
		width: @width - 20
		text: "In order to make a SAR, you will need to get in touch with our customer operations team….\n\nIf you have any related questions, please get in touch with us on privacy@clearscore.com."
		
	Utils.offsetY([title, body], 15)
	@updateContent()
	
	@confirm = new Button
		parent: @content
		x: 10
		y: body.maxY + 45
		width: @width - 20
		text: "Submit a Subject Access Request"
		select: -> 
			user.submittedSAR = true
			app.showPrevious()
	
	@cancel = new Button
		parent: @content
		x: 10
		y: @confirm.maxY + 10
		width: @width - 20
		secondary: true
		text: "Go Back"
		select: -> app.showPrevious()
	
	
app.showNext accountPageView