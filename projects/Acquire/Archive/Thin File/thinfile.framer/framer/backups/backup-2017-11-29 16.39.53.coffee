require "gotcha/gotcha"
cs = require 'cs'
cs.Context.setMobile()
Framer.Extras.Hints.disable()

app = new cs.App
	navigation: 'registration'

app.header.backgroundColor = '#79765e'
app.navigation.step = 4

# Upload Container
class UploadContainer extends cs.Button
	constructor: (options = {}) ->
		
		_.defaults options, 
			size: 'medium'
			border: cs.Colors.main
			borderWidth: 1
			shadowY: 0
			shadowBlur: 0
			fill: 'none'
			clip: false
			action: @showUploading
			text: ''
			type: 'body1'
				
		super options
		
		@textLayer.textAlign = 'left'
		@textLayer.padding = {left: 16}
		
		@progressFill = new Layer
			parent: @
			width: 0
			height: @height
			backgroundColor: '#FFF'
			shadowX: 1
			shadowColor: '#7ed321';
			
		@progressFill.sendToBack()
		
		@messageLayer = new cs.Text
			name: 'Message Layer'
			parent: @
			y: @height + 5
			width: @width
			type: 'caption'
			text: ''
			color: cs.Colors.dark
			padding: {left: 15}
		
		@uploadIcon = new cs.Icon
			parent: @
			y: Align.center()
			x: Align.right(16)
			scale: .7
			icon: ''
			
		@setIcon()
		
		@on "change:width", =>
			@messageLayer.width = @width
			@uploadIcon.maxX = @maxX - 32
	
	showUploading: (loadingTime = 1.5)->
		@fill = 'none'
		
		@messageLayer.text = ''
		@icon = 'cs-load'
		
		@iconLayer.animate
			rotation: 360
			options:
				curve: 'linear'
				repeat: 4
				time: .5
				
		
# 		@uploadIcon.icon = 'none'
		
		_.assign @progressFill,
			width: 1
			opacity: 1
		
		@progressFill.animate
			width: @width
			options:
				curve: 'linear'
				time: loadingTime
		
		Utils.delay loadingTime, =>
			@iconLayer.animateStop()
			@iconLayer.rotation = 0
			
			_.assign @progressFill,
				width: 1
				opacity: 0
			
			if Math.random() < .5
			
				roll = Math.random()
				
				if roll < .25
					response = 'filesize'
				else if roll < .5
					response = 'filetype'
				else if roll < .75
					response = 'timeout'
				else
					response = 'notsure'
				
				@showUploadFail(response)
				
				return
			
			@showUploadSuccess()
	
	setIcon: =>
		
		type = Framer.DeviceComponent.Devices[Framer.Device.deviceType].deviceType
	
		if type is 'phone' or type is 'tablet'
			@icon = 'cs-camera'
			return
		
		@icon = 'cs-upload'
	
	resetUploadStatus: ->
		@messageLayer.text = ''
		@messageLayer.color = 'cs.Colors.dark'
		
		@color = cs.Colors.dark
		@setIcon()
		
		@border =  cs.Colors.dark
		@iconLayer.color = cs.Colors.dark
		
# 		@uploadIcon.color = cs.Colors.dark
# 		@uploadIcon.icon = 'cs-upload'
	
	showUploadSuccess: ->
		
		@icon = 'cs-check'
		
		@color = '#80ad52'
		@border = '#80ad52'
		
		@fill = 'white'
		@messageLayer.color = '#80ad52'
		@messageLayer.text = 'Upload successful'
		
# 		@uploadIcon.color = '#80ad52'
# 		@uploadIcon.icon = 'check'
		
		@emit "change:upload", true
				
	showUploadFail: (response) =>
		@resetUploadStatus()
		
		@messageLayer.color = '#dcaa74'		
		@emit "change:upload", false

		switch response 
			when 'filesize'
				@messageLayer.text = 'The file was over the 5mb limit – try uploading a smaller photo'
			when 'filetype'
				@messageLayer.text = "That file wasn't a photo – try uploading a .jpeg or .png file"
			when 'timeout'
				@messageLayer.text = "Our connection timed out – please try uploading again"
			else
				@messageLayer.text = "Sorry, the upload didn't work – please try again"
				

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

# Advice

class Advice extends Layer
	constructor: (options = {}) ->
		@__constructor = true
	
		_.assign options,
			backgroundColor: null
			
		_.defaults options,
			text: null
			image: illos_selfie.image
		
		super options
		
		@illo = new Layer
			parent: @
			name: 'Illustration'
			width: 96
			height: 108
			
		@textLayer = new cs.Text 
			parent: @
			name: 'Body'
			type: 'body1'
			x: @illo.maxX + 16
			width: @width - 16 - @illo.width
		
		delete @__constructor
		
		_.assign @,
			image: options.image
			text: options.text
		
		@setHeight()
		
	setHeight: =>
		_.assign @,
			height: _.max(@textLayer.maxY, @illo.maxY)
		
	@define "image",
		get: -> return @_image
		set: (string) ->
			return if @__constructor
			@_image = string
			@illo.image = string
			@setHeight()
			
	@define "text",
		get: -> return @_text
		set: (string) ->
			return if @__constructor
			@_text = string
			@textLayer.text = string
			@setHeight()




# -----------------------
# Views

# Dead End View

class DeadEndView extends cs.View
	constructor: (options = {}) ->
		@__constructor = true
		
		super
		
		@addToStack new cs.Text 
			type: 'body'
			text: 'Dead End'
		
		@addToStack new cs.Text 
			type: 'body1'
			text: "We haven't got here yet."
		
		delete @__constructor


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
		
		@contentInset = { top: 0, bottom: 120, left: 0, right: 0 }
		
		pullerFlexrow = new cs.FlexRow
			name: 'pullerFlexrow'
			fullWidth: true
				
		@puller = new cs.Puller
			parent: pullerFlexrow.content
			text: "We need to take two easy steps to verify your identity. First, you’ll need to upload a photo of your ID. Then, you’ll need to take a selfie with your ID to verify that it’s yours."
			
		bodyFlexrow = new cs.FlexRow
			name: 'bodyflexrow'
			maxWidth: 580
			
		@title = new cs.Text
			parent: bodyFlexrow.content
			x: 16
			text: 'Upload a photo of your ID' 
			type: 'body'
		
		# document select
		
		@documentSelectField = new cs.Select
			parent: bodyFlexrow.content
			y: @title.maxY + 20
			action: @showDocumentUpload
			options: [
				'Choose your ID type',
				'Passport', 
				"UK Driver's License",
				"Other"
				]
		
		@documentSelectField.textLayer.textAlign = 'left'
		@documentSelectField.textLayer.padding = {left: 15}
		
		
		# photo upload field
		
		@photoUploadField = new UploadContainer
			parent: bodyFlexrow.content
			y: @documentSelectField.maxY + 16
			x: 16
		
		@photoUploadField.opacity = 0
		
		# Advice
		
		@advice = new Advice
			parent: bodyFlexrow.content
			y: @photoUploadField.maxY + 40
			image: illos_passport.image
			text: 'For a passport, upload a picture of the photo page, with all four corners visible. Your document needs to be in-date with all details visible (nothing covered).'
			opacity: 0
		
		@nextButton = new cs.Button
			parent: bodyFlexrow.content
			y: @advice.maxY + 32
			x: 16
			text: 'Next'
			fill: 'dcaa74'
			type: 'body'
			color: 'white'
			disabled: true
			visible: false
			action: @goToNext
		
		# stack
		Utils.delay .15, =>
			@addToStack pullerFlexrow,
				x: 0
				y: 0
				
			@addToStack bodyFlexrow,
				x: 0
				y: 50
		
			# other selected field
			
			@otherSelected = new cs.Text
				parent: @content
				width: @width - 30
				x: 15
				y: @photoUploadField.screenFrame.y
				text: "Sorry, at the moment we are only able to accept a valid passport or a UK Driver’s License. If you don’t have these documents, contact our customer support to find another solution."
				visible: false
		
		# events
		
		@photoUploadField.on "change:upload", (success) =>
			user.hasDocPhoto = success
			
			if not success
				@nextButton.disabled = true
				return 
			
			@nextButton.disabled = false
	
	showDocumentUpload: =>
		if @documentSelectField.text is @documentSelectField.options[0]
			@photoUploadField.opacity = 0
			@documentSelectField.fill = 'none'
			@advice.opacity = 0
			@advice.image = illos_passport.image
			@nextButton.visible = false
			@otherSelected.visible = false
			return
		
		if @documentSelectField.text is _.last(@documentSelectField.options)
			@photoUploadField.opacity = 0
			@documentSelectField.fill = 'none'
			@advice.opacity = 0
			@nextButton.visible = false
			@otherSelected.visible = true
			return
		
		switch @documentSelectField.text
			when @documentSelectField.options[1]
				@advice.image = illos_passport.image
				@advice.text = 'For a passport, upload a picture of the photo page, with all four corners visible. Your document needs to be in-date with all details visible (nothing covered).'
			when @documentSelectField.options[2]
				@advice.image = illos_license.image
				@advice.text = 'Upload a clear picture of the front of your driving license with all four corners showing. Your licence needs to be in-date with all details visible (nothing covered). '
			
		
		@photoUploadField.opacity = 1
		@documentSelectField.fill = 'white'
		@advice.opacity = 1
		@nextButton.visible = true
		@otherSelected.visible = false
		
	goToNext: =>
		if user.hasSelfiePhoto
			app.showNext(confirmUploadsView)
			return
		
		app.showNext(selfieUploadView)

# 2.0.0 Selfie Photo Upload View

class SelfieUploadView extends RegistrationView
	constructor: (options = {}) ->
		
		_.assign options,
			name: 'Selfie Upload View'
			showLayers: true
			padding:
				top: 0
				stack: 0
				left: 0
				right: 0
				bottom: 0
		
		super options
		
		@contentInset = { top: 0, bottom: 120, left: 0, right: 0 }
		
		pullerFlexrow = new cs.FlexRow
			name: 'pullerFlexrow'
			fullWidth: true
		
		@puller = new cs.Puller
			parent: pullerFlexrow.content
			text: "For security reasons, we need additional proof of your identity. You'll need to upload a photo of your ID and a photo of you holding the ID."
		
		bodyFlexrow = new cs.FlexRow
			name: 'bodyflexrow'
			maxWidth: 580
		
		@title = new cs.Text
			parent: bodyFlexrow.content
			x: 16
			text: 'Upload a selfie with your ID'
			type: 'body'
		
		# document select
		
		@photoUploadField = new UploadContainer
			parent: bodyFlexrow.content
			y: @title.maxY + 20
			x: 16
		
		# Advice
		
		@advice = new Advice
			parent: bodyFlexrow.content
			y: @photoUploadField.maxY + 40
			image: illos_passport.image
			text: 'Make sure that both your face and the photo page of the ID are clearly visible in this photo, as we need to make sure you’re the owner of the ID you’ve uploaded. Don’t worry, it’s private and secure. '
		
		@nextButton = new cs.Button
			parent: bodyFlexrow.content
			y: @advice.maxY + 32
			x: 16
			text: 'Next'
			fill: 'dcaa74'
			type: 'body'
			color: 'white'
			action: @goToNext
		
		# stack
		
		Utils.delay .15, =>
			@addToStack pullerFlexrow,
				x: 0
				y: 0
				
			@addToStack bodyFlexrow,
				x: 0
				y: 64
		
		# events
		
		@photoUploadField.on "change:upload", (success) =>
			user.hasSelfiePhoto = success
			
			if not success
				@nextButton.disabled = true
				return 
			
			@nextButton.disabled = false
			
		@advice.on "change:height", =>
			@nextButton.y = bodyFlexrow.content

		
	
	goToNext: =>
		app.showNext(confirmUploadsView, 'right')

# 3.0.0 Confirm Your Uploads View

class ConfirmUploadsView extends RegistrationView
	constructor: (options = {}) ->
		
		_.assign options,
			name: 'Confirm Uploads View'
			showLayers: true
			padding:
				top: 0
				stack: 0
				left: 0
				right: 0
		
		super options
				
		@contentInset = { top: 0, bottom: 120, left: 0, right: 0 }
		
		pullerFlexrow = new cs.FlexRow
			name: 'pullerFlexrow'
			parent: @content
			fullWidth: true
		
		@puller = new cs.Puller
			parent: pullerFlexrow
			width: @width
			text: "Please check your photos again before sending them to us. If we have trouble seeing you or your ID, we may have to ask for you to send them again."
			
		docFlexrow = new cs.FlexRow
			name: 'doc flex row'
			maxWidth: 580
			
		# doc title
		
		@docTitle = new cs.Text
			parent: docFlexrow.content
			x: 16
			text: 'Your Passport'
			type: 'body'
		
		# document photo
		
		@docField = new cs.Container
			parent: docFlexrow.content
			y: @docTitle.maxY + 20
			x: 16
			height: 200
			image: Utils.randomImage()
		
		# doc notes
		
		@docNotes = new cs.Text
			parent: docFlexrow.content
			y: @docField.maxY + 16
			x: 16
			width: @width - 32
			text: 'For a passport, you should provide a picture of the photo page with all four corners visible. Your document needs to be in-date with all details visible (nothing covered).'
			
		# doc update link
			
		docLinkFlexrow = new cs.FlexRow
			name: 'doc link flex row'
			maxWidth: 580
			
		@docUpdate = new cs.Text
			parent: docLinkFlexrow.content
			type: 'link'
			x: 16
			width: @width - 32
			text: 'Update'
			action: -> app.showNext(docUploadView)
			
		# selfie title
			
		selfieFlexrow = new cs.FlexRow
			name: 'selfie flex row'
			maxWidth: 580
		
		@selfieTitle = new cs.Text
			parent: selfieFlexrow.content
			x: 16
			text: 'Your Selfie'
			type: 'body'
		
		# selfie photo
		
		@selfieField = new cs.Container
			parent: selfieFlexrow.content
			y: @selfieTitle.maxY + 20
			x: 16
			height: 200
			image: Utils.randomImage()
		
		# selfie notes
		
		@selfieNotes = new cs.Text
			parent: selfieFlexrow.content
			y: @selfieField.maxY + 16
			x: 16
			width: @width - 32
			text: 'For your selfie, be sure that your face and your ID are both in the picture.'
			
		# selfie update link
		
		selfieLinkFlexrow = new cs.FlexRow
			name: 'selfie flex row'
			maxWidth: 580
			
		@selfieUpdate = new cs.Text
			parent: selfieLinkFlexrow.content
			type: 'link'
			x: 16
			width: @width - 32
			text: 'Update'
			action: -> app.showNext(selfieUploadView)
	
		# next button
		
		nextFlexRow = new cs.FlexRow
			name: 'selfie flex row'
			maxWidth: 580
	
		@nextButton = new cs.Button
			parent: nextFlexRow.content
			x: 16
			text: 'Submit My Photos'
			fill: 'dcaa74'
			type: 'body'
			color: 'white'
			action: @goToNext
		
		# stack
		
		Utils.delay .15, =>
			@addToStack(pullerFlexrow,
				x: 0
				y: 0
			)
			
			@addToStack(docFlexrow,
				x: 0
				y: 64
			)
			
			@addToStack(docLinkFlexrow,
				x: 0
				y: 8
			)
			
			@addToStack(selfieFlexrow,
				x: 0
				y: 32
			)
			
			@addToStack(selfieLinkFlexrow,
				x: 0
				y: 8
			)
			
			@addToStack(nextFlexRow,
				x: 0
				y: 32
			)
		

		Utils.delay 1, =>
			@stackView()
			
	goToNext: =>
		app.showNext(deadEndView, 'right')

# 4.0.0 Thin File Account View

class ThinFileAccountView extends RegistrationView
	constructor: (options = {}) ->
		
		options.showLayers = true
		
		super options
		
		@content.backgroundColor = 'fff'
		
		@heading = new TextLayer
			parent: @content
			width: @width
			fontSize: 24
			text: 'My Account'
			color: cs.Colors.main
			backgroundColor: 'f1f1f1'
			padding:
				left: 16
				top: 10
				bottom: 35
		
		@heading = @
			
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

deadEndView = new DeadEndView
docUploadView = new DocUploadView
selfieUploadView = new SelfieUploadView
confirmUploadsView = new ConfirmUploadsView
thinFileAccountView = new ThinFileAccountView

app.showNext(docUploadView)
