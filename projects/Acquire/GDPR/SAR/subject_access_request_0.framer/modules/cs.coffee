framework = require "framework"
theme = framework.theme.theme

# -----------------
# myTheme - A Custom Theme for Framework

# This is an example "theme" for Framework. With themes, you can
# add new components and set style over-rides without modifying
# the base files, so that you can update Framework without losing
# your changes.



# -----------------
# Components

# To bring in your own components, require each of them
# and place the component's name (as a string) into
# the componentNames array.

{ Donut } = require 'cs-components/Donut'
{ Card } = require 'cs-components/Card'
# { Square } = require 'myTheme-components/Square'

componentNames = [
	'Card'
	'Donut'
#	'Square'
	]

# -----------------
# Fonts

Utils.insertCSS("""
 	@font-face {
		font-family: 'Aktiv Grotesk';
		font-weight: 200;
		src: url('modules/cs-components/fonts/AktivGrotesk_W_Hair.woff'); 
	}

	@font-face {
		font-family: 'Aktiv Grotesk';
		font-weight: 300;
		src: url('modules/cs-components/fonts/AktivGrotesk_W_Lt.woff'); 
	}

	@font-face {
		font-family: 'Aktiv Grotesk';
		font-weight: 400;
		src: url('modules/cs-components/fonts/AktivGrotesk_W_Rg.woff'); 
	}

	@font-face {
		font-family: 'Aktiv Grotesk';
		font-weight: 500;
		src: url('modules/cs-components/fonts/AktivGrotesk_W_Md.woff'); 
	}
""")


# -----------------
# Colors

# You can make changes to the default colors here.
# The colors you make will each get the "shade" treatment,
# so you'll be able to use colorName10, colorName20, etc as
# global variables. You can (and should!) use these colors
# in your custom components.

# You can change the value of the default colors (commented out
# in the list below), but you can't remove them.

shadeColors =
	brand: "#263648"
	link: "#0492bd"
	# black: '#252729'
	# grey: '#c1c1c2'
	# yellow: '#ffd16d'
	# white: '#FFF'
	# red: '#d96161'
	# beige: '#eae5e0'
	# blue: '#5399c3'
	# green: '#599FA0'

# You can also add colors without giving them the full shade treatment.
# These colors will still be available as global variables in your project,
# but they won't have shade50, shade40, etc.

soloColors =
	orange: "#dcaa74"
	green: "#dcaa74"
	blue: "#547190"
	sand: "#f4efef"
	TVblue: "#7cd2fc"
	success: "#73b141"
	attention: "#e2ab5b"
	fail: "#c77d7d"
	incoming: "#89bcdb"
	confirmed: "#9eb062"
	active: "#6ba7f6"
	completed: "#87db9e"
	score1: "#ffcc9c"
	score2: "#f7df71"
	score3: "#c9de81"
	score4: "#76e8a9"
	score5: "#a4e1eb"
	timeline1: "#ffcc9c"
	timeline2: "#e0b7f0"
	timeline3: "#c9de81"
	timeline4: "#f7df71"
	timeline5: "#f16868"
	learn1: "#5d97ed"
	learn2: "#3cceab"
	learn3: "#f44d84"
	learn4: "#ff8833"
	learn5: "#7e57c2"
	learn6: "#e4c002"
	learn7: "#5d909f"


# don't change this line -----------------------------
framework.colors.updateColors(shadeColors, soloColors)

# -----------------
# Theme

# You can make changes to the default theme here.
# Check components/Theme for the defaults - but don't 
# change those defaults!

themeStyles = 
	# ----------
	# Typography
	#
	typography: 
		Serif:
			fontFamily: 'Aktiv Grotesk'
		Sans:
			fontFamily: 'Aktiv Grotesk'
		H1:
			fontSize: 20
			fontWeight: 300
			letterSpacing: 0
		H2:
			fontSize: 16
			fontWeight: 500
			letterSpacing: 0
		H3:
			fontSize: 16
			fontWeight: 500
			letterSpacing: 0
		H4:
			fontSize: 16
			fontWeight: 500
			letterSpacing: 0
		H5:
			fontSize: 16
			fontWeight: 300
			letterSpacing: 0
		Body:
			fontSize: 16
			fontWeight: 300
			letterSpacing: 0
		Body1:
			fontSize: 16
			fontWeight: 300
			letterSpacing: 0
		Body2:
			fontSize: 14
			fontWeight: 300
			letterSpacing: 0
		Body3:
			fontSize: 12
			fontWeight: 300
			letterSpacing: 0
		Body4:
			fontSize: 10
			fontWeight: 300
			letterSpacing: 0
		Body5:
			fontSize: 8
			fontWeight: 300
			letterSpacing: 0
	# --------
	# Select
	#
	select:
		default:
			color: brand
			borderColor: brand
			backgroundColor: white
			fontWeight: 200
			shadowBlur: 2
			shadowY: 2
			shadowColor: 'rgba(0,0,0,.16)'
			borderWidth: 1
			borderRadius: 4
			padding: 20
			height: 50
			icon: "chevron-down"
		hovered:
			color: grey
			borderColor: brand
			backgroundColor: white
			shadowBlur: 2
			shadowY: 2
			shadowColor: 'rgba(0,0,0,.16)'
			borderWidth: 1
			borderRadius: 4
			padding: 20
		focused:
			color: brand
			borderColor: black20
			backgroundColor: white
			shadowBlur: 2
			shadowY: 2
			shadowColor: 'rgba(0,0,0,.16)'
			borderWidth: 1
			borderRadius: 4
			padding: 20
		disabled:
			color: grey
			borderColor: grey
			backgroundColor: white
			shadowBlur: 0
			shadowY: 0
			shadowColor: 'rgba(0,0,0,0)'
			borderWidth: 1
			borderRadius: 4
			padding: 20
	# ----------
	# Text Input
	#
	textInput:
		default:
			color: grey
			borderColor: brand
			backgroundColor: white
			fontWeight: 200
			shadowBlur: 2
			shadowY: 2
			shadowColor: 'rgba(0,0,0,.16)'
			borderWidth: 1
			borderRadius: 4
			padding: 20
			height: 50
		hovered:
			color: grey
			borderColor: brand
			backgroundColor: white
			shadowBlur: 2
			shadowY: 2
			shadowColor: 'rgba(0,0,0,.16)'
			borderWidth: 1
			borderRadius: 4
			padding: 20
		focused:
			color: brand
			borderColor: black20
			backgroundColor: white
			shadowBlur: 2
			shadowY: 2
			shadowColor: 'rgba(0,0,0,.16)'
			borderWidth: 1
			borderRadius: 4
			padding: 20
		disabled:
			color: grey
			borderColor: grey
			backgroundColor: white
			shadowBlur: 0
			shadowY: 0
			shadowColor: 'rgba(0,0,0,0)'
			borderWidth: 1
			borderRadius: 4
			padding: 20
	# ----------
	# Button
	#
	button:
		light_primary:
			default:
				height: 50
				fontWeight: 500
				color: white
				borderColor: link
				backgroundColor: link
				shadowColor: 'rgba(0,0,0,.16)'
				borderRadius: 5
				borderWidth: 1
				shadowY: 2
				shadowBlur: 6
			disabled:
				color: white
				borderColor: grey
				backgroundColor: grey
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: white
				borderColor: link60
				backgroundColor: link60
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: white
				borderColor: link
				backgroundColor: link
				shadowColor: 'rgba(0,0,0,.16)'
		light_secondary:
			default:
				height: 50
				fontWeight: 500
				color: link
				borderColor: link
				backgroundColor: white
				shadowColor: 'rgba(0,0,0,0)'
				borderRadius: 5
				borderWidth: 1
				shadowY: 2
				shadowBlur: 6
			disabled:
				color: grey
				borderColor: grey
				backgroundColor: white.alpha(0)
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: link
				borderColor: link60
				backgroundColor: white60
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: link
				borderColor: link
				backgroundColor: white
				shadowColor: 'rgba(0,0,0,0)'
		dark_primary:
			default:
				height: 50
				fontWeight: 500
				color: brand
				borderColor: null
				backgroundColor: white
				shadowColor: 'rgba(0,0,0,.16)'
				borderRadius: 4
				borderWidth: 1
				shadowY: 2
				shadowBlur: 6
			disabled:
				color: white
				borderColor: grey
				backgroundColor: grey
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: brand
				borderColor: null
				backgroundColor: white70
				shadowColor: 'rgba(0,0,0,.16)'
			hovered:
				color: brand
				borderColor: null
				backgroundColor: white
				shadowColor: 'rgba(0,0,0,.16)'
		dark_secondary:
			default:
				height: 50
				fontWeight: 500
				color: white
				borderColor: white
				backgroundColor: null
				opacity: 1
				shadowColor: 'rgba(0,0,0,0)'
				borderRadius: 4
				borderWidth: 1
				shadowY: 2
				shadowBlur: 6
			disabled:
				color: grey
				borderColor: grey
				backgroundColor: null
				opacity: .5
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: grey60
				borderColor: grey60
				backgroundColor: null
				opacity: 1
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: grey
				borderColor: grey
				backgroundColor: null
				opacity: 1
				shadowColor: 'rgba(0,0,0,0)'
	# --------------------------
	# Segment
	segment:
		default:
			default:
				height: 50
				fontWeight: 500
				color: link
				borderColor: link
				backgroundColor: white
				shadowColor: 'rgba(0,0,0,0)'
				borderWidth: 1
				shadowY: 2
				shadowBlur: 6
			disabled:
				color: grey
				borderColor: grey
				backgroundColor: white.alpha(0)
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: link
				borderColor: link60
				backgroundColor: white60
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: link
				borderColor: link
				backgroundColor: white
				shadowColor: 'rgba(0,0,0,0)'
		active:
			default:
				height: 50
				fontWeight: 500
				color: white
				borderColor: link
				backgroundColor: link
				shadowColor: 'rgba(0,0,0,.16)'
				borderWidth: 1
				shadowY: 2
				shadowBlur: 6
			disabled:
				color: white
				borderColor: grey
				backgroundColor: grey
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: white
				borderColor: link60
				backgroundColor: link60
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: white
				borderColor: link
				backgroundColor: link
				shadowColor: 'rgba(0,0,0,.16)'


# -----------------
# Blood-slick machinery
#
# Here's where your components get processed.
# Don't change this part!

framework.theme.updateTheme(themeStyles)
framework.typography.updateTypography()


componentNames.forEach (componentName) =>
	window[componentName] = class FrameworkComponent extends eval(componentName)
		constructor: (options = {}) ->
			@app = framework.app
			super options

