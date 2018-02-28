# lots of material icons:

{ colors } = require 'components/Colors'

# --------------------------
# Input Styling

Utils.insertCSS("""
	*:focus { outline: 0; }
	textarea { resize: none; }

 	input::-webkit-input-placeholder { /* Chrome/Opera/Safari */
 	  -webkit-text-fill-color: rgba(0,0,0,.5);
 	}
 	
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

# --------------------------
# Custom Fonts

# Utils.insertCSS("""
#

# """)

exports.theme = 
	# --------------------------
	# Colors
	colors: colors
	# --------------------------
	# Typography
	typography:
		Serif:
			color: '#000'
			fontFamily: 'Aktiv Grotesk'
		Sans:
			color: '#000'
			fontFamily: 'Aktiv Grotesk'
		Mono:
			color: '#333'
			fontFamily: 'Menlo'
		H1:
			name: 'H1'
			style: 'Sans'
			fontSize: 80
			letterSpacing: -3
			lineHeight: 1
			fontWeight: 600
			color: black
		H2:
			name: 'H2'
			style: 'Sans'
			fontSize: 40
			letterSpacing: -1
			lineHeight: 1.1
			fontWeight: 600
			color: black
		H3:
			name: 'H3'
			style: 'sans'
			fontSize: 30
			letterSpacing: -0.01
			lineHeight: 1
			fontWeight: 600
			color: black
		H4:
			name: 'H4'
			style: 'Sans'
			fontSize: 30
			letterSpacing: -0.01
			lineHeight: 1
			fontWeight: 600
			color: black
		H4:
			name: 'H4'
			style: 'Sans'
			fontSize: 16
			lineHeight: 1.25
			letterSpacing: 0
			fontWeight: 600
			color: black
		H5:
			name: 'H5'
			style: 'Sans'
			fontSize: 13
			lineHeight: 1.5
			letterSpacing: 0
			fontWeight: 600
			color: black
		H6:
			name: 'H5'
			style: 'Sans'
			fontSize: 11
			lineHeight: 1.6
			fontWeight: 600
			letterSpacing: 0
			color: black
		Body:
			name: 'Body1'
			style: 'Sans'
			fontSize:  16
			fontWeight: 500
			letterSpacing: 0
			color: black
		Body1:
			name: 'Body1'
			style: 'Sans'
			fontSize:  16
			lineHeight: 1.25
			fontWeight: 400
			letterSpacing: 0
			color: black
		Body2:
			name: 'Body2'
			style: 'Sans'
			fontSize:  13
			lineHeight: 1.5
			fontWeight: 400
			letterSpacing: 0
			color: black
		Body3:
			name: 'Body3'
			style: 'Sans'
			fontSize:  11
			lineHeight: 1.6
			fontWeight: 400
			letterSpacing: 0
			color: black
		Code:
			name: 'Code'
			style: 'Mono'
			fontSize:  12
			lineHeight: 1.3
			fontWeight: 500
			letterSpacing: 0
			color: black
			fontFamily: 'Menlo'
			style:
				'tab-size': '4'
		Label:
			name: 'Label'
			style: 'Sans'
			fontSize:  13
			lineHeight: 2.5
			fontWeight: 600
			letterSpacing: 0
			color: black40
		Micro:
			name: 'Micro'
			style: 'Sans'
			fontSize:  11
			lineHeight: 1.6
			fontWeight: 500
			letterSpacing: 0
			padding: {top: 4}
			color: grey
	# --------------------------
	# Link
	link:
		default:
			color: black
		hovered:
			color: grey80
		touched:
			color: grey60
		disabled:
			color: grey30
	# --------------------------
	# Text Input
	textInput:
		default:
			color: black
			borderColor: grey40
			backgroundColor: white
			shadowBlur: 0
			shadowColor: 'rgba(0,0,0,.16)'
			borderWidth: 1
			borderRadius: 2
		hovered:
			color: black30
			borderColor: grey
			backgroundColor: white
			shadowBlur: 0
			shadowColor: 'rgba(0,0,0,.16)'
		focused:
			color: black
			borderColor: black20
			backgroundColor: white
			shadowBlur: 6
			shadowColor: 'rgba(0,0,0,.16)'
		disabled:
			color: grey20
			borderColor: grey30
			backgroundColor: white
			shadowBlur: 0
			shadowColor: 'rgba(0,0,0,0)'
			borderWidth: 1
			borderRadius: 2
	# --------------------------
	# Select
	select:
		default:
			color: black
			borderColor: grey40
			backgroundColor: white
			shadowBlur: 0
			shadowColor: 'rgba(0,0,0,.16)'
			borderWidth: 1
			borderRadius: 2
		hovered:
			color: black30
			borderColor: grey
			backgroundColor: white
			shadowBlur: 0
			shadowColor: 'rgba(0,0,0,.16)'
		focused:
			color: black
			borderColor: black20
			backgroundColor: white
			shadowBlur: 6
			shadowColor: 'rgba(0,0,0,.16)'
		disabled:
			color: grey30
			borderColor: grey30
			backgroundColor: white
			shadowBlur: 0
			shadowColor: 'rgba(0,0,0,0)'
			borderWidth: 1
			borderRadius: 2
	# --------------------------
	# Option
	option:
		default:
			color: grey40
			borderColor: grey40
			backgroundColor: white
			shadowBlur: 0
		hovered:
			color: grey
			borderColor: grey
			backgroundColor: grey30
	# --------------------------
	# Tooltip
	tooltip:
		default:
			backgroundColor: black
			borderRadius: 3
	# --------------------------
	# Radiobox
	radiobox:
		default:
			color: black
			opacity: 1
		disabled:
			color: black
			opacity: .1
		hovered:
			color: grey
			opacity: 1
		error:
			color: red
			opacity: 1
	# --------------------------
	# Checkbox
	checkbox:
		default:
			color: black
			opacity: 1
		disabled:
			color: black
			opacity: .1
		hovered:
			color: grey
			opacity: 1
		error:
			color: red
			opacity: 1
	# --------------------------
	# Segment
	segment:
		active:
			default:
				color: black
				borderColor: yellow60
				backgroundColor: yellow50
				shadowColor: 'rgba(0,0,0,0)'
				borderRadius: 4
				borderWidth: 1
				shadowY: 2
				shadowBlur: 6
			disabled:
				color: grey
				borderColor: grey40
				backgroundColor: grey30
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: black
				borderColor: yellow70
				backgroundColor: yellow70
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: black
				borderColor: yellow70
				backgroundColor: yellow60
				shadowColor: 'rgba(0,0,0,0)'
		default:
			default:
				color: black
				borderColor: grey40
				backgroundColor: white
				shadowColor: 'rgba(0,0,0,0)'
				borderRadius: 4
				borderWidth: 1
				shadowY: 2
				shadowBlur: 6
			disabled:
				color: grey
				borderColor: grey40
				backgroundColor: grey30
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: black
				borderColor: grey40
				backgroundColor: white
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: black30
				borderColor: grey40
				backgroundColor: grey30
				shadowColor: 'rgba(0,0,0,0)'
	# --------------------------
	# Button
	button:
		light_primary:
			default:
				color: white
				borderColor: tumbleWeed60
				backgroundColor: tumbleWeed50
				shadowColor: 'rgba(0,0,0,0)'
				borderRadius: 999
				borderWidth: 1
				shadowY: 2
				shadowBlur: 6
			disabled:
				color: new Color(black).alpha(.15)
				borderColor: new Color(black).alpha(.15)
				backgroundColor: new Color(yellow50).alpha(0)
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: white
				borderColor: tumbleWeed70
				backgroundColor: tumbleWeed70
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: white
				borderColor: tumbleWeed70
				backgroundColor: tumbleWeed60
				shadowColor: 'rgba(0,0,0,0)'
		light_secondary:
			default:
				color: black
				borderColor: grey
				backgroundColor: white
				shadowColor: 'rgba(0,0,0,0)'
				borderRadius: 999
				borderWidth: 1
				shadowY: 2
				shadowBlur: 6
			disabled:
				color: new Color(black).alpha(.15)
				borderColor: new Color(black).alpha(.15)
				backgroundColor: new Color(beige50).alpha(0)
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: black
				borderColor: grey
				backgroundColor: grey40
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: black
				borderColor: grey
				backgroundColor: grey30
				shadowColor: 'rgba(0,0,0,0)'
		dark_primary:
			default:
				color: black
				borderColor: null
				backgroundColor: white
				opacity: 1
				shadowColor: 'rgba(0,0,0,0)'
				borderRadius: 4
				borderWidth: 1
				shadowY: 2
				shadowBlur: 6
			disabled:
				color: grey40
				borderColor: null
				backgroundColor: grey30
				opacity: .5
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: black40
				borderColor: null
				backgroundColor: grey30
				opacity: 1
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: black40
				borderColor: null
				backgroundColor: grey30
				opacity: 1
				shadowColor: 'rgba(0,0,0,0)'
		dark_secondary:
			default:
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
				color: grey40
				borderColor: grey40
				backgroundColor: null
				opacity: 1
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: grey40
				borderColor: grey40
				backgroundColor: null
				opacity: 1
				shadowColor: 'rgba(0,0,0,0)'
	
	# --------------------------
	# Icons
	icons:
		"ios-back":"M213.089096,256.5 L357.982048,111.701564 C368.672651,101.017935 368.672651,83.6963505 357.982048,73.0127216 C347.291446,62.3290928 329.958554,62.3290928 319.267952,73.0127216 L155.017952,237.155579 C144.327349,247.839208 144.327349,265.160792 155.017952,275.844421 L319.267952,439.987278 C329.958554,450.670907 347.291446,450.670907 357.982048,439.987278 C368.672651,429.30365 368.672651,411.982065 357.982048,401.298436"