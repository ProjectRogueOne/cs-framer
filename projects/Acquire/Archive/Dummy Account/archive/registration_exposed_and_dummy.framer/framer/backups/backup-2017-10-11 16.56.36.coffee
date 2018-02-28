cs = require 'cs'
cs.Context.setMobile()

# ---------------------------------
# app

static_edit.frame = Screen.frame
static_full.frame = Screen.frame
static_edit.bringToFront()

# change text

header = new TextLayer
	text: 'Take a look at your'
	fontSize: 32
	fontWeight: 300
	x: 887
	y: 375
	color: '#777'

changeText = new TextLayer
	text: '{value}'
	fontSize: 32
	fontWeight: 300
	x: header.maxX + 4
	y: 375
	fontWeight: 400
	color: '#d22d2e'

textEntries = ['credit score', 'credit report', 'best offers', 'next steps', 'credit history']

nextText = Utils.cycle(textEntries) 

setNextText = ->
	newText = _.split(nextText(), '')
	string = ""
	for letter, i in newText
		do (letter, i) ->
			Utils.delay i * .03, ->
				string += letter
				changeText.text = string + "|"

setNextText()

Utils.interval 5, setNextText

# email input

emailField = new cs.Field
	x: 930
	y: 468
	size: 'large'
	fill: 'white'
	placeholder: 'Enter your email address'
	pattern: (value) -> 
		_.includes(value, '.com') and
		_.includes(value, '@')

# password input

passwordField = new cs.Field
	x: emailField.x
	y: emailField.maxY + 16
	size: 'large'
	fill: 'white'
	placeholder: 'Enter your password'
	password: true

for layer in [emailField, passwordField]
	layer.input.style['text-align'] = 'center'

# terms

termsBox = new cs.Checkbox
	x: emailField.x
	y: passwordField.maxY + 16

termsText = new cs.Text
	x: termsBox.maxX + 16
	y: termsBox.y
	width: 300
	text: 'By clicking sign up you agree to our Terms and that you have read our Data Use Policy'

# sign up

signUpButton = new cs.Button
	x: emailField.x
	y: emailField.maxY + 32
	size: 'large'
	color: 'white'
	type: 'body'
	text: 'Sign Up'
	fill: '#0592bc'
	disabled: true

do _.bind( -> #signUpButton

	@states.register =
		y: 672
		
	emailField.on "change:matches", (matches) =>
		@disabled = !matches

, signUpButton)

passwordField.visible = false
termsBox.visible = false
termsText.visible = false

# functions

showRegistration: ->
	signUpButton.animate "registration"

show
# events

emailField.on "submit", ->
	if Math.random() > .5
		showRegistration()
	else
		showLogin()

# 
# static_full.bringToFront()
# static_full.opacity = .5