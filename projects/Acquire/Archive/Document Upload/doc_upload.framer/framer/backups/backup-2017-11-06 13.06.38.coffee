cs = require 'cs'
cs.Context.setMobile()

app = new cs.App
	type: 'safari'
	navigation: 'registration'
	collapse: true

app.navigation.step = 4

view = new cs.View
	showLayers: true
	backgroundColor: '#FFF'

view.padding.top = 120

view.build ->
	
	puller = new cs.Puller
		parent: @content
		
	@addToStack @idTitle = new cs.Text
		type: 'body'
		text: 'ID Verification'
		
	# continue button
	
	continueContainer = new Layer
		parent: @
		y: Align.bottom(-app.footer.height)
		width: @width
		height: 64
		backgroundColor: '#FFF'
		shadowY: -1
	
	continueButton = new cs.Button
		parent: continueContainer
		x: 16
		width: @width - 32
		y: Align.center
		type: 'bod'
		
	

uploadFrontSide = undefined
uploadBackSide = undefined

	

# Front Side Upload

view.build ->
	@addToStack uploadFrontSide = new cs.UploadButton
		width: 355
		height: 177
		fill: 'white'
		shadowY: 0
		shadowBlur: 0
		style:
			border: '3px dashed #777'
	
	do _.bind( ->
		
		@icon = new cs.Icon
			parent: @
			icon: 'camera'
			border: 1
			scale: 2
			x: Align.center
			y: Align.center(4)
		
		@detail = new cs.Text
			parent: @
			type: 'body'
			text: 'Driving License (front side)'
			x: Align.center
			y: 15
		
		@detail1 = new cs.Text
			parent: @
			type: 'body'
			text: 'Take a picture or select a file'
			x: Align.center
			y: @icon.maxY + 38
		
		@display = new Layer
			parent: @
			size: @size
			backgroundColor: null
		
		# iphone bug exception
		
		if Utils.isMobile()
			_.assign @display,
				originX: 0
				originY: 0
				rotation: 90
				width: @height
				height: @width
				x: @width
		
	, uploadFrontSide)
	
	uploadingFrontState = new Layer
		parent: @content
		y: @idTitle.maxY + 16
		x: 12
		width: @width - 24
		opacity: 0
		visible: false
		backgroundColor: null
	
	do _.bind( ->
	
		@box = new cs.Container
			parent: @
			width: @width
			border: 'black'
			fill: 'white'
		
		@iconLayer = new cs.Icon
			parent: @
			icon: 'file-outline'
			scale: 1.4
			x: 8
			y: 12
			color: '#4a90e2'
			visible: false
			
		@progress = new Layer
			parent: @box
			height: @box.height
			width: 1
			backgroundColor: 'b8e986'
		
		@labelLayer = new cs.Text 
			parent: @box
			type: 'body'
			width: @width
			y: Align.center
			textAlign: 'center'
			text: 'Uploading'
			color: 'black'
			
		@uploadImage = (url, callback = -> null) ->
			
			@visible = true
			
			@animate
				opacity: 1
				options:
					time: .15
					delay: .15
			
			@progress.onAnimationEnd _.once(callback)
			
			@progress.animate
				width: @box.width
				options:
					delay: .75
					time: 2
					curve: 'linear'
					
			uploadFrontSide.animate 
				height: @box.height
		
		@confirmUpload = =>
			@progress.width = 0
			@box.fill = 'dbe9f9'
			@box.border = '4a90e2'
			@labelLayer.color = '#4a90e2'
			@labelLayer.text = 'Driving license - front side'
			@iconLayer.visible = true
			uploadBackSide.open()
		
	, uploadingFrontState)
	
	uploadFrontSide.on "change:file", (url) ->
		
		@onAnimationEnd _.once(-> 
			@visible = false
			uploadingFrontState.uploadImage(url, uploadingFrontState.confirmUpload)
			)
		
		@animate
			opacity: 0
			options:
				time: .15

# Back Side Upload

view.build ->
	@addToStack uploadBackSide = new cs.UploadButton
		width: 355
		height: 177
		fill: 'white'
		shadowY: 0
		shadowBlur: 0
		style:
			border: '3px dashed #777'
	
	do _.bind( ->
		
		@open = ->
			@animate
				height: 177
			@style.border = '3px dashed #777'
			
			@animate
				opacity: 1
				options:
					time: .15
					delay: .15
		
		@icon = new cs.Icon
			parent: @
			icon: 'camera'
			border: 1
			scale: 2
			x: Align.center
			y: Align.center(4)
		
		@detail = new cs.Text
			parent: @
			type: 'body'
			text: 'Driving License (back side)'
			x: Align.center
			y: 15
		
		@detail1 = new cs.Text
			parent: @
			type: 'body'
			text: 'Take a picture or select a file'
			x: Align.center
			y: @icon.maxY + 38
		
		@display = new Layer
			parent: @
			size: @size
			backgroundColor: null
		
		# iphone bug exception
		
		if Utils.isMobile()
			_.assign @display,
				originX: 0
				originY: 0
				rotation: 90
				width: @height
				height: @width
				x: @width
		
		@height = 1
		@opacity = 0
		
	, uploadBackSide)
	
	uploadingBackState = new Layer
		parent: @content
		y: uploadBackSide.y
		x: 12
		width: @width - 24
		opacity: 0
		visible: false
		backgroundColor: null
	
	do _.bind( ->
	
		@box = new cs.Container
			parent: @
			width: @width
			border: 'black'
			fill: 'white'
		
		@iconLayer = new cs.Icon
			parent: @
			icon: 'file-outline'
			scale: 1.4
			x: 8
			y: 12
			color: '#4a90e2'
			visible: false
			
		@progress = new Layer
			parent: @box
			height: @box.height
			width: 1
			backgroundColor: 'b8e986'
		
		@labelLayer = new cs.Text 
			parent: @box
			type: 'body'
			width: @width
			y: Align.center
			textAlign: 'center'
			text: 'Uploading'
			color: 'black'
			
		@uploadImage = (url, callback = -> null) ->
			
			@visible = true
			
			@animate
				opacity: 1
				options:
					time: .15
					delay: .15
			
			@progress.onAnimationEnd _.once(callback)
			
			@progress.animate
				width: @box.width
				options:
					delay: .75
					time: 2
					curve: 'linear'
					
			uploadBackSide.animate 
				height: @progress.height
		
		@confirmUpload = =>
			@progress.width = 0
			@box.fill = 'dbe9f9'
			@box.border = '4a90e2'
			@labelLayer.color = '#4a90e2'
			@labelLayer.text = 'Driving license - back side'
			@iconLayer.visible = true
			
			continueButton.open()
		
	, uploadingBackState)
	
	uploadBackSide.on "change:file", (url) ->
		
		uploadingBackState.y = @y
		
		@onAnimationEnd _.once(-> 
			@visible = false
			uploadingBackState.uploadImage(url, uploadingBackState.confirmUpload)
			)
		
		@animate
			opacity: 0
			options:
				time: .15

view.build ->
	
	@addToStack new cs.Accordian
		title: 'What documents can I use?'
		color: '#000'
		
	@addToStack new cs.Divider
	
	@addToStack new cs.Text
		x: 20
		type: 'caption'
		width: @width - 32
		text: 'Files must be smaller than 4MB. We keep your ID confidential and its use is for internal use only.'
	
# 	@addToStack cameraLayer = new cs.CameraLayer
# 		backgroundColor: '#FFF'
# 	
# 	cameraLayer.start()