# Typography

Quicksand = Utils.loadWebFont("Quicksand")

Utils.insertCSS """

	@fontFace {
		font-family: Quicksand;
		src: url(fonts/Quicksand-Light.ttf);
		fontWeight: 300
	}
	
	@fontFace {
		font-family: Quicksand;
		src: url(fonts/Quicksand-Regular.ttf);
		fontWeight: 400
	}
	
	@fontFace {
		font-family: Quicksand;
		src: url(fonts/Quicksand-Medium.ttf);
		fontWeight: 500
	}
	
	@fontFace {
		font-family: Quicksand;
		src: url(fonts/Quicksand-Bold.ttf);
		fontWeight: 600
	}
	
"""
{ colors } = require 'Colors'

exports.fonts = fonts = 
	ui: 'Arial'
	header: 'Quicksand'
	body: 'Quicksand'

class exports.H1 extends TextLayer
	constructor: (options = {}) ->
		
		super _.defaults options,
			name: 'Heading 1'
			x: 16, y: 16
			fontSize: 40,
			fontWeight: 600, 
			fontFamily: fonts.header
			color: colors.bright
		
class exports.H2 extends TextLayer
	constructor: (options = {}) ->
		
		super _.defaults options,
			name: 'Heading 2'
			x: 16
			fontSize: 16, 
			fontFamily: fonts.header
			fontWeight: 400
			color: colors.med
		
class exports.H3 extends TextLayer
	constructor: (options = {}) ->
		
		super _.defaults options,
			name: 'Heading 3'
			x: 16
			fontSize: 24, 
			fontFamily: fonts.header
			fontWeight: 600
			color: colors.bright

class exports.Body extends TextLayer
	constructor: (options = {}) ->
		
		super _.defaults options,
			name: 'Body'
			x: 16
			fontSize: 15, 
			fontFamily: fonts.body
			fontWeight: 400
			color: colors.med

class exports.Regular extends TextLayer
	constructor: (options = {}) ->
		
		super _.defaults options,
			name: 'Regular'
			x: 16
			fontSize: 15, 
			fontFamily: fonts.ui
			fontWeight: 400
			color: colors.med

class exports.Caption extends TextLayer
	constructor: (options = {}) ->
		
		super _.defaults options,
			name: 'Caption'
			x: 16
			fontSize: 12, 
			fontFamily: fonts.ui
			fontWeight: 400
			color: colors.dim

class exports.Link extends TextLayer
	constructor: (options = {}) ->
		
		super _.defaults options,
			name: 'Link'
			parent: @
			x: 8
			y: Align.center
			fontSize: 16
			fontWeight: 600
			textTransform: "capitalize"
			color: colors.tint