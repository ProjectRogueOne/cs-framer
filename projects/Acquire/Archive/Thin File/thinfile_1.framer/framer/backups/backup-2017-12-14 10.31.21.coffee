require "gotcha/gotcha"
cs = require 'cs'
cs.Context.setMobile()
Framer.Extras.Hints.disable()
Canvas.backgroundColor = '#FFF'

app = new cs.App
	type: 'safari'
	navigation: 'registration'

app.header.backgroundColor = '#79765e'
app.navigation.step = 3

DOC_RESUBMIT = true

# Helpers

Utils.define = (layer, property) ->
	
	Object.defineProperty layer,
		property,
		get: -> return layer["_#{property}"]
		set: (value) ->
			return if layer.__constructor
			
			layer["_#{property}"] = value
			layer.emit "change:#{property}", value, layer

# -----------------------
# Components

# RegistrationView

class RegistrationView extends cs.View
	constructor: (options = {}) ->
		
		_.assign options,
			name: 'Registration View'
			showLayers: true
			padding:
				top: 0
				stack: 0
				left: 0
				right: 0
				bottom: 0
		
		super options
		
		@backgroundColor = '#f1f1f1'

# Upload Component

class UploadComponent extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		# ----------------
		# options
		
		_.defaults options,
			name: 'Upload Block'
			title: ''
			document: 'selfie'
			errorText: ''
			failfirst: false
			backgroundColor: null
			height: 195
		
		super options
		
		# ----------------
		# layers
		
		@bodyLayer = new cs.Text
			name: 'Advice'
			parent: @
			width: 999
			text: options.body
			
		@bodyLayer.lineHeight = 1.3
		
		@illoLayer = new Layer
			name: 'Illustration'
			parent: @
			x: Align.right()
			height: 108
			width: 96

		@uploadButton = new cs.Button
			name: 'Upload Button'
			parent: @
			x: 0
			text: 'Upload a photo of your ID'
			type: 'body1'
			width: @width
			backgroundColor: '#dcaa74'
			shadowY: 3
			shadowColor: '#8b939c'
			color: 'white'
			clip: true
			animationOptions:
				time: .15
		
		@uploadLayer = new Layer
			name: 'Uploaded Photo'
			parent: @
			x: Align.right(6)
			y: 6
			width: 108
			height: 96
			rotation: 90
			borderRadius: 2
			visible: true
			backgroundColor: null
			image: null
			borderWidth: 3
			borderColor: '#8b929b'
			clip: true
			
		@iconLayer = new cs.Icon
			name: 'Icon'
			parent: @uploadButton
			point: Align.center()
			color: 'white'
			
		@errorTextLayer = new cs.Text
			name: 'Error Text'
			type: 'small'
			parent: @
			x: 0
			y: @uploadButton.maxY + 4
			color: '#dcaa74'
			textAlign: 'right'
			
		@input = document.createElement("input")
		@uploadButton._element.appendChild(@input)
		
		_.assign @input,
			name: 'Camera Input'
			id: 'cameraInput'
			type: 'file'
			capture: 'camera'
			accept: 'image/*'
			
		_.assign @input.style,
			position: 'absolute'
			left: "-10px"
			top: "-10px"
			opacity: '0'
			zoom: '100'
			'z-index': '999'
			'background-color': 'red'
			
		@input1 = document.createElement("input")
		@uploadLayer._element.appendChild(@input1)
		
		_.assign @input1,
			name: 'Camera Input 1'
			id: 'cameraInput1'
			type: 'file'
			capture: 'camera'
			accept: 'image/*'
			
		_.assign @input1.style,
			position: 'absolute'
			left: "-10px"
			top: "-10px"
			opacity: '0'
			zoom: '100'
			'z-index': '999'
		
		# Events
		
		delete @__constructor
		
		# ----------------
		# definitions 
		
		Utils.define(@, "title")
		Utils.define(@, "illo")
		Utils.define(@, "file")
		Utils.define(@, "baseIllo")
		Utils.define(@, "icon")
		Utils.define(@, "body")
		Utils.define(@, "errorText")
		Utils.define(@, "upload")
		Utils.define(@, "photo")
		Utils.define(@, "failfirst")
		Utils.define(@, "document")
		
		# ----------------
		# events
		
		@on "change:document", @showDocType
		
		@on "change:title", (value) => 
			@setHeight()
# 			@titleLayer.text = value
		
		@on "change:body", (value) =>
			@bodyLayer.text = value
			@bodyLayer._element.childNodes[1].innerHTML = value
			@setHeight()
			
		@on "change:illo", (value) =>
			@illoLayer.image = value?.image
			@setHeight()
		
		@on "change:icon", (value) => 
			@iconLayer.icon = value
			@setHeight()
		
		@on "change:errorText", (value = '') => 
			@errorTextLayer.text = value
			@setHeight()
		
		@on "change:file", (value) =>
			if not value? or value is ''
				_.assign @uploadLayer,
					image: null
				return
			
			_.assign @uploadLayer,
				visible: true
				image: value
		
		@uploadButton.onTapStart => @uploadButton.animate 'pressed'
		@uploadButton.onTapEnd => @uploadButton.animate 'normal'
		
		@tryUpload = Utils.throttle .25, @tryUpload
		
		# actual upload for devices with upload
		if Utils.isMobile()
			@input.onchange = =>
				image = @input.files[0]
				if not image?
					@tryUpload(undefined, "That didn't work. Try again?")
					return
				
				url = window.URL.createObjectURL(image)
				
				@tryUpload(url)
				
			# actual upload for devices with upload
			@input1.onchange = =>
				image = @input1.files[0]
				if not image?
					@tryUpload(undefined, "That didn't work. Try again?")
					return
				
				url = window.URL.createObjectURL(image)
				
				@tryUpload(url)
		
		# skip the actual upload for desktop
		else
			@uploadButton.onTapEnd => @tryUpload('')
			@uploadButton.onLongPressEnd => @tryUpload(undefined, "That didn't work. Try again?")
			
			@uploadLayer.onTap => @tryUpload('')
		
		# ----------------
		# kickoff 
		
		_.assign @,
			title: options.title
			errorText: options.errorText
			baseIllo: options.illo
			photo: options.photo
			document: options.document
			
		
		
		@setUpload()
		
	# ----------------
	# methods
	
	showDocType: (value) =>
		switch value
			when 'passport'
				_.assign @,
					illo: illos_passport
					baseIllo: illos_passport
					photo: photo_passport
					body: 'For this to work, we\'ll need to see everything on your passport\'s <b>photo page</b>.<br><div style="font-size: 14px; margin: 0; padding: 8px 0 0 0;">✅ Can we see the <b>entire page</b>?</div><div style="font-size: 14px; margin: 0; padding: 8px 0 0 0;"><span style="font-size: 14px;">✅ Is anything <b>covered</b>?</div>'
				
				_.assign @uploadButton,
					text: 'Upload a photo of your ID'
					
			when 'licence'
				_.assign @,
					illo: illos_licence
					baseIllo: illos_licence
					photo: photo_id
					body: 'For this to work, we\'ll need to see everything on the <b>front side</b> of your licence.<br><div style="font-size: 14px; margin: 0; padding: 8px 0 0 0;">✅ Is the <b>whole ID</b> in the photo?</div><div style="font-size: 14px; margin: 0; padding: 8px 0 0 0;"><span style="font-size: 14px;">✅ Is anything <b>covered</b>?</div>'
				
				_.assign @uploadButton,
					text: 'Upload a photo of your ID'
					
			when 'selfie'
				_.assign @,
					illo: illos_selfie
					baseIllo: illos_selfie
					photo: selfie_id
					body: 'For your selfie, we\'ll need to see <b>your face</b> and <b>your whole ID</b> in the same photo.<br><div style="font-size: 14px; margin: 0; padding: 8px 0 0 0;">✅ Is the <b>whole ID</b> in the photo?</div><div style="font-size: 14px; margin: 0; padding: 8px 0 0 0;"><span style="font-size: 14px;">✅ Is your <b>face</b> in the photo?</div>'
				
				_.assign @uploadButton,
					text: 'Upload a selfie with your ID'
					
		@_baseuploadbuttontext = @uploadButton.text
	
	
	# try to upload (fail if error)
	tryUpload: (url, errorText) =>
		uploadDuration = _.random(.75, 1.5)
		
		@showLoading(uploadDuration)
			
		Utils.delay uploadDuration, =>
			@setUpload(url, errorText)
	
	# show loading state
	showLoading: (uploadDuration) =>
		
		@iconLayer.animateStop()
		
		_.assign @iconLayer,
			color: cs.Colors.dark
			icon: 'cs-load'
			rotation: 0
		
		@iconLayer.animate
			rotation: 360
			options:
				looping: true
				curve: 'linear'
				time: 1.5
		
		_.assign @uploadButton,
			backgroundColor: '#dca974'
			text: ''
		
		@errorText = ""
		
		Utils.delay uploadDuration, =>
			@iconLayer.animateStop()
			@iconLayer.rotation = 0
	
	# show that the upload failed
	showUploadFailed: (errorText) =>
		_.assign @iconLayer,
			color: 'white'
			icon: ''
		
		_.assign @uploadButton,
			text: @_baseuploadbuttontext
			fill: 'white'
		
		@illo = @baseIllo
		@errorText = errorText
		
		@uploadButton.backgroundColor = '#dca974'
	
	# show that the upload succeeded
	showUploadSuccess: (url) =>
		_.assign @iconLayer,
			color: 'secondary'
			icon: 'cs-check'
		
		@illo = @photo
		@errorText = ''
		
		_.assign @uploadButton,
			text: ''
			fill: 'white'
			
		@errorText = ""
	
	# set an upload value
	setUpload: (url, errorText) =>
	
		@file = url
	
		if not url? or @failFirst
			@showUploadFailed(errorText)
			return
		
		@showUploadSuccess(url)
	
	# correct layer positions when content changes
	setHeight: =>
		
		_.assign @bodyLayer,
			width: @illoLayer.x - 16
			height: @illoLayer.height
		
		_.assign @uploadButton,
			y: @illoLayer.maxY + 16
			states:
				pressed:
					y: @illoLayer.maxY + 19
					shadowY: 1
				normal:
					y: @illoLayer.maxY + 16
					shadowY: 3
					
		@errorTextLayer.y = @uploadButton.maxY + 8
		
		Utils.delay 0, => @height = @uploadButton.maxY



# -----------------------
# Views

# Blank View

class BlankView extends cs.View
	constructor: (options = {}) ->
		@__constructor = true
		
		_.defaults options,
			showLayers: true
		
		super options
		
		new UploadComponent
			parent: @content
			width: @width - 32
			x: 16
		
		delete @__constructor

# 0.0.0 Prior View

class PriorView extends RegistrationView
	constructor: (options = {}) ->
		
		_.assign options,
			name: 'Doc Upload View'
			showLayers: true
			padding:
				top: 0
				stack: 0
				left: 0
				right: 0
				bottom: 0
		
		super options
		
		@scrollVertical = false
		
		pullerFlexrow = new cs.FlexRow
			name: 'pullerFlexrow'
			fullWidth: true
				
		@puller = new cs.Puller
			parent: pullerFlexrow.content
			text: "We'll also need some details about where you live."
			
		bodyFlexrow = new cs.FlexRow
			name: 'bodyflexrow'
			maxWidth: 580
			
		@title = new cs.Text
			parent: bodyFlexrow.content
			x: 16
			text: 'What kind of residence do you have?' 
			type: 'body'
		
		# document select
		
		@documentSelectField = new cs.Select
			parent: bodyFlexrow.content
			y: @title.maxY + 20
			action: @setDocType
			options: [
				'Choose your residence type',
				'Dormitory', 
				'Apartment', 
				"House",
				"Collective Farm",
				"I live on the road, man"
				]
				
		@documentSelectField.textLayer.textAlign = 'left'
		@documentSelectField.textLayer.padding = {left: 15}
		
		@nextButton = new cs.Button
			parent: bodyFlexrow.content
			y: @documentSelectField.maxY + 32
			x: 16
			text: 'Next'
			fill: 'dcaa74'
			type: 'body'
			color: 'white'
			disabled: true
			action: @goToNext
		
		# stack
		
		Utils.delay .15, =>
			@contentInset = 
				top: 0, 
				bottom: 16, 
				left: 0, 
				right: 0
				
			@addToStack pullerFlexrow,
				x: 0
				y: 0
				
			@addToStack bodyFlexrow,
				x: 0
				y: 50
				
			@updateContent()
			
		# kickoff
		
	setDocType: =>
			
		@nextButton.disabled = @documentSelectField.text is @documentSelectField.options[0]
		
	onLoad:  =>
		app.navigation = 'registration'
		app.navigation.step = 3
		app.header.backgroundColor = '#79765e'
		
	goToNext: =>
		app.showNext(priorView1)

# 0.0.1 Prior View 1

class PriorView1 extends RegistrationView
	constructor: (options = {}) ->
		
		_.assign options,
			name: 'Doc Upload View'
			showLayers: true
			padding:
				top: 0
				stack: 0
				left: 0
				right: 0
				bottom: 0
		
		super options
		
		@scrollVertical = false
		
		pullerFlexrow = new cs.FlexRow
			name: 'pullerFlexrow'
			fullWidth: true
				
		@puller = new cs.Puller
			parent: pullerFlexrow.content
			text: "We'll also need some details about where you live."
			
		bodyFlexrow = new cs.FlexRow
			name: 'bodyflexrow'
			maxWidth: 580
			
		@title = new cs.Text
			parent: bodyFlexrow.content
			x: 16
			text: 'Do you have any pets?' 
			type: 'body'
		
		# document select
		
		@documentSelectField = new cs.Select
			parent: bodyFlexrow.content
			y: @title.maxY + 20
			action: @setDocType
			options: [
				'Choose your pet type',
				'Cat', 
				'Dog', 
				"Turtle",
				"Bengal Tiger",
				"A couple billion bedbugs"
				"None"
				]
				
		@documentSelectField.textLayer.textAlign = 'left'
		@documentSelectField.textLayer.padding = {left: 15}
		
		@nextButton = new cs.Button
			parent: bodyFlexrow.content
			y: @documentSelectField.maxY + 32
			x: 16
			text: 'Next'
			fill: 'dcaa74'
			type: 'body'
			color: 'white'
			disabled: true
			action: @goToNext
		
		# stack
		
		Utils.delay .15, =>
			@contentInset = 
				top: 0, 
				bottom: 16, 
				left: 0, 
				right: 0
				
			@addToStack pullerFlexrow,
				x: 0
				y: 0
				
			@addToStack bodyFlexrow,
				x: 0
				y: 50
				
			@updateContent()
			
		# kickoff
		
	setDocType: =>
			
		@nextButton.disabled = @documentSelectField.text is @documentSelectField.options[0]
		
	onLoad:  =>
		app.navigation = 'registration'
		app.navigation.step = 3
		app.header.backgroundColor = '#79765e'
		
	goToNext: =>
		app.showNext(docUploadView)

# --

# 1.0.0 ID Photo Upload

class DocUploadView extends RegistrationView
	constructor: (options = {}) ->
		
		_.assign options,
			name: 'Doc Upload View'
			showLayers: true
			padding:
				top: 0
				stack: 0
				left: 0
				right: 0
				bottom: 0
		
		super options
		
		@onLoad = ->
			app.navigation = 'registration'
			app.navigation.step = 4
			app.header.backgroundColor = '#79765e'
		
		@scrollVertical = false
		
		pullerFlexrow = new cs.FlexRow
			name: 'pullerFlexrow'
			fullWidth: true
		
		# puller
		
		if DOC_RESUBMIT
			noto = new cs.Container
				parent: pullerFlexrow.content
				text: "Sorry, but we couldn’t validate your identity from the photos you sent last time. You’ll need to upload your photos again."
				fill: "#daad67"
				
			_.assign @puller.textLayer,
				x: 48
				width: @width - 64
				
			smallIcon = new cs.Icon	
				parent: @
				scale: .6
				icon: 'close'
				color: 'white'
				x: 8, y: 16
		
		@puller = new cs.Puller
			parent: pullerFlexrow.content
			text: "Next we'll need a photo of your ID and a selfie with your ID to verify that it’s yours."
		
		# title
		
		bodyFlexrow = new cs.FlexRow
			name: 'bodyflexrow'
			maxWidth: 580
			
		@title = new cs.Text
			parent: bodyFlexrow.content
			x: 16
			text: 'What kind of ID do you have?' 
			type: 'body'
		
		# document select
		
		@documentSelectField = new cs.Select
			parent: bodyFlexrow.content
			y: @title.maxY + 20
			action: @setDocType
			options: [
				'Choose your ID type',
				'Passport', 
				"UK driving licence",
				"Other"
				]
		
		@documentSelectField.textLayer.textAlign = 'left'
		@documentSelectField.textLayer.padding = {left: 15}
		
		# why?
		
# 		@whyShouldITitle = new cs.Text
# 			parent: bodyFlexrow.content
# 			y: @documentSelectField.maxY + 32
# 			text: "Why do you need this?"
# 			type: 'body1'
# 			visible: true
# 		
# 		@whyShouldITitle.fontWeight = 600
# 			
# 		@whyShouldIBody = new cs.Text
# 			parent: bodyFlexrow.content
# 			y: @whyShouldITitle.maxY + 8
# 			type: 'body1'
# 			visible: true
# 			text: "Thanks to identity theives and internet jerks, we need to be sure that you're really you before we can get your credit report. We'd usually just ask about your financial history, but we haven't found info enough to safely do that. These photos are our plan B."
		
		# other selected
		
		@otherSelected = new cs.Text
			parent: bodyFlexrow.content
			y: @documentSelectField.maxY + 20
			text: "If you don’t have a passport or UK driving licence and wish to upload another type of ID, please contact us and we’ll do our best to help you."
			visible: false
		
		# load spinner
		
		@loadSpinner = new cs.Icon
			parent: @content
			x: Align.center()
			y: @documentSelectField.maxY + 160
			icon: 'cs-load'
			visible: false
		
		@loadSpinner.animate
			rotation: 360
			options:
				looping: true
				time: 1.25
				curve: 'linear'
		
		
		# id upload
		
		@iDUploadBlock = new UploadComponent
			parent: bodyFlexrow.content
			y: @documentSelectField.maxY + 44
			failfirst: true
			
		# photo upload
			
		@selfieUploadBlock = new UploadComponent
			parent: bodyFlexrow.content
			y: @iDUploadBlock.maxY + 44
			document: 'selfie'
			
		@nextButton = new cs.Button
			parent: bodyFlexrow.content
			y: @selfieUploadBlock.maxY + 44
			x: 16
			text: 'Next'
			fill: 'dcaa74'
			type: 'body'
			color: 'white'
			disabled: true
			action: @goToNext
		
		# stack
		
		Utils.delay .15, =>
			@contentInset = 
				top: 0, 
				bottom: 16, 
				left: 0, 
				right: 0
				
			@addToStack pullerFlexrow,
				x: 0
				y: 0
				
			@addToStack bodyFlexrow,
				x: 0
				y: 50
				
			@updateContent()
		
		@content.onMove =>
			if @content.maxY <= Screen.height - 170
				@content.maxY = Screen.height - 170
		
		# events
		
		@iDUploadBlock.on "change:file", (success) =>
			user.hasDocPhoto = success
			@checkForReady()
		
		@selfieUploadBlock.on "change:file", (success) =>
			user.hasSelfiePhoto = success
			@checkForReady()
			
		# kickoff
		
		
		@iDUploadBlock.visible = false
		@selfieUploadBlock.visible = false
		@nextButton.visible = false
		@otherSelected.visible = false
		
	setDocType: =>
	
		hideLayers = (bool = false, other = false) =>
			@iDUploadBlock.visible = bool
			@selfieUploadBlock.visible = bool
			@nextButton.visible = bool
			@otherSelected.visible = other
			
# 			@whyShouldITitle.visible = !bool and !other
# 			@whyShouldIBody.visible = !bool and !other
# 			
			@scrollToTop()
			@scrollVertical = bool
		
		return if not @documentSelectField.text?
		
		hideLayers(false, false)
		Utils.delay .05, => @loadSpinner.visible = true
		Utils.delay 1.25, => @loadSpinner.visible = false
	
		Utils.delay 1.35, => switch @documentSelectField.text
					
			when @documentSelectField.options[0]
				hideLayers(false, false)
				
				_.assign @documentSelectField,
					backgroundColor: 'null'
				
			when @documentSelectField.options[1]
				hideLayers(true, false)
				
				_.assign @documentSelectField,
					backgroundColor: '#FFF'
			
				_.assign @iDUploadBlock,
					document: 'passport'
					photo: photo_passport
					
				_.assign @selfieUploadBlock,
					photo: selfie_passport
					
			when @documentSelectField.options[2]
				hideLayers(true, false)
				
				_.assign @documentSelectField,
					backgroundColor: '#FFF'
			
				_.assign @iDUploadBlock,
					document: 'licence'
					photo: photo_id
					
				_.assign @selfieUploadBlock,
					photo: selfie_id
			
			when @documentSelectField.options[3]
				hideLayers(false, true)
				
				_.assign @documentSelectField,
					backgroundColor: '#FFF'
					
		Utils.delay 0, => 
			@iDUploadBlock.setHeight()
			@selfieUploadBlock.y = @iDUploadBlock.maxY + 44
			@nextButton.y = @selfieUploadBlock.maxY + 44
	
	checkForReady: =>
	
		if not _.every(_.map([@iDUploadBlock, @selfieUploadBlock], (d) => d.file?))
			@nextButton.disabled = true
			return
			
		@nextButton.disabled = false
		
	goToNext: =>
		app.showNext(thinFileAccountView)

# 2.0.0 Thin File Account View

class ThinFileAccountView extends RegistrationView
	constructor: (options = {}) ->
		
		options.showLayers = true
		
		super options
		
		@onLoad = ->
			app.navigation = 'registration'
			app.navigation.step = 5
			app.header.backgroundColor = '#79765e'
		
		@backgroundColor = '#FFF'
		@content.backgroundColor = '#FFF'
		
		@onLoad = =>
			app.navigation = null
			app.header.backgroundColor = '#2a3544'
			@restart.bringToFront()
		
		_.assign my_account_doc_submit,
			parent: @content
			x: 0, y: 0
			
		@restart = new cs.Text
			type: 'link'
			x: Align.center
			y: 88
			text: 'Restart'
			action: => window.location.reload()
		
		@restart.sendToBack()
		
	goToNext: =>
		user.docPhoto = @docField.image
		user.selfiePhoto = @selfieField.image
		app.showNext(deadEndView, 'right')
		
		
	


# ----------------------
# Implementation

user =
	docPhoto: undefined
	selfiePhoto: undefined
	hasDocPhoto: false
	hasSelfiePhoto: false

blankView = new BlankView # for testing

priorView = new PriorView
priorView1 = new PriorView1
docUploadView = new DocUploadView
thinFileAccountView = new ThinFileAccountView

app.showNext(docUploadView)

