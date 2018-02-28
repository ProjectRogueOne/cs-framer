# colors
colors =
	tint: 'blue'
	secondary: 'green'
	secondaryText: '#FFF'
	borders: 'teal'

{ TextField } = require 'TextField'

# Button
class Button extends TextLayer
	constructor: (options = {}) ->
		
		@_backgroundColor = options.backgroundColor ? colors.tint
		
		super _.defaults options,
			fontSize: 14
			height: 48,
			width: 200,
			textAlign: 'center'
			borderRadius: 4
			color: colors.secondaryText
			backgroundColor: colors.tint
			padding: {top: 14, bottom: 8, left: 16, right: 16}
			animationOptions: {time: .15}
			
		@onTouchStart -> @showPressed(true)
		@onTouchEnd -> @showPressed(false)
	
	showPressed: (isPressed) =>
		if isPressed
			@animate
				backgroundColor: new Color(@_backgroundColor).darken(15)
		else
			@animate
				backgroundColor: @_backgroundColor

email = new TextField
	x: Align.center(-96)
	y: Align.center
	placeholder: 'E-mail address'
	helperText: 'tesd'
	
submit = new Button
	x: email.maxX + 8
	y: email.y
	text: 'Get My Free Score'

Utils.delay 2, => email.warn = true
Utils.delay 5, => email.warn = false