# Mobile
# Authors: Steve Ruiz
# Last Edited: 27 Sep 17

font = 'Aktiv Grotesk'
color = '#2C364C'

class exports.H1 extends TextLayer
	constructor: (options = {}) ->
		super _.defaults options,
			name: 'Page Main Title'
			fontWeight: 100
			fontSize: 40
			lineHeight: 1.3
			fontFamily: font
			color: color

class exports.H2 extends TextLayer
	constructor: (options = {}) ->
		super _.defaults options,
			name: 'Mobile Small Title'
			fontWeight: 500
			fontSize: 24
			lineHeight: 1.3
			fontFamily: font
			color: color

class exports.H3 extends TextLayer
	constructor: (options = {}) ->
		super _.defaults options,
			name: 'Mobile Section Title'
			fontWeight: 500
			fontSize: 18
			lineHeight: 1.3
			fontFamily: font
			color: color

class exports.H4 extends TextLayer
	constructor: (options = {}) ->
		super _.defaults options,
			name: 'Inside Section Title'
			fontWeight: 300
			fontSize: 18
			lineHeight: 1.11
			fontFamily: font
			color: color

class exports.Small extends TextLayer
	constructor: (options = {}) ->
		super _.defaults options,
			name: 'Body Small'
			fontWeight: 300
			fontSize: 14
			lineHeight: 1.286
			fontFamily: font
			color: color

class exports.SmallBold extends TextLayer
	constructor: (options = {}) ->
		super _.defaults options,
			name: 'Body Small Bold'
			fontWeight: 500
			fontSize: 14
			lineHeight: 1.286
			fontFamily: font
			color: color

class exports.Medium extends TextLayer
	constructor: (options = {}) ->
		super _.defaults options,
			name: 'Body Medium'
			fontWeight: 300
			fontSize: 16
			lineHeight: 1.25
			fontFamily: font
			color: color

class exports.MediumBold extends TextLayer
	constructor: (options = {}) ->
		super _.defaults options,
			name: 'Body Medium Bold'
			fontWeight: 500
			fontSize: 16
			lineHeight: 1.25
			fontFamily: font
			color: color

class exports.Large extends TextLayer
	constructor: (options = {}) ->
		super _.defaults options,
			name: 'Body Large'
			fontWeight: 300
			fontSize: 18
			lineHeight: 1.11
			fontFamily: font
			color: color

class exports.LargeBold extends TextLayer
	constructor: (options = {}) ->
		super _.defaults options,
			name: 'Body Large Bold'
			fontWeight: 500
			fontSize: 18
			lineHeight: 1.11
			fontFamily: font
			color: color

class exports.Button extends TextLayer
	constructor: (options = {}) ->
		super _.defaults options,
			name: 'Buttons Text'
			fontWeight: 500
			fontSize: 18
			lineHeight: 1.11
			fontFamily: font
			color: color

class exports.DonutNumber extends TextLayer
	constructor: (options = {}) ->
		super _.defaults options,
			name: 'Report Page Donut Numbers'
			fontWeight: 300
			fontSize: 75
			lineHeight: .96
			fontFamily: font
			color: color

class exports.PageNumber extends TextLayer
	constructor: (options = {}) ->
		super _.defaults options,
			name: 'Report Page Numbers'
			fontWeight: 300
			fontSize: 34
			lineHeight: 1.06
			fontFamily: font
			color: color

class exports.DashboardScore extends TextLayer
	constructor: (options = {}) ->
		super _.defaults options,
			name: 'Dashboard Score & Text'
			fontWeight: 300
			fontSize: 90
			lineHeight: 1.11
			fontFamily: font
			color: color

class exports.DashboardNumber extends TextLayer
	constructor: (options = {}) ->
		super _.defaults options,
			name: 'Dashboard Number'
			fontWeight: 300
			fontSize: 135
			lineHeight: 1
			fontFamily: font
			color: color
