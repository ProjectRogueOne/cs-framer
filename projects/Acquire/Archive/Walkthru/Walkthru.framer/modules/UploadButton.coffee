# UploadButton
# Authors: Steve Ruiz
# Last Edited: 6 Nov 17

# Does not work in-app.
# Having a bug with EXIF data from iPhones - they come out rotated 90deg
# so... here's the quick fix.

{ Icon } = require 'Icon'
{ Button } = require 'Button'

class exports.UploadButton extends Button
	constructor: (options = {}) ->

		_.defaults options,
			name: 'UploadButton'
			text: ' '
			icon: 'upload'
			borderRadius: 8
			backgroundColor: '#FFF'
			clip: true
			shadowY: 2
			shadowBlur: 6
			action: => @fakeInput()

		super options

		# HTML input

		@inputLayer = new Layer
			name: 'Input Layer'
			parent: @
			height: @height
			width: @widtg
			backgroundColor: null

		@input = document.createElement("input")

		_.assign @input,
			name: 'Camera Input'
			id: 'cameraInput'
			type: 'file'
			capture: 'camera'
			accept: 'image/*'

		_.assign @input.style,
			position: 'absolute'
			top: '-10px'
			left: '-20px'
			opacity: '0'
			height: '100px'
			width: '300px'
			zoom: '10'
			cursor: 'pointer'

		@inputLayer._element.appendChild(@input)
		@inputLayer.bringToFront()

		# Events


	fakeInput: =>
		if Utils.isChrome()
			return

		if Utils.isPhone()
			return

		@emit "change:file", Utils.randomImage(), null, @


	@define "file",
		get: -> return @input.files[0]

	@define "url",
		get: -> return window.URL.createObjectURL(@file)