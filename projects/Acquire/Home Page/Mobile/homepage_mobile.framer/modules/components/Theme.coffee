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
""")

# --------------------------
# Custom Fonts

# Utils.insertCSS("""
#
# 	@font-face {
# 		font-family: 'Aktiv Grotesk';
# 		font-weight: 200;
# 		src: url('modules/cs-components/fonts/AktivGrotesk_W_Hair.woff'); 
# 	}
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
			fontFamily: 'Georgia'
		Sans:
			color: '#000'
			fontFamily: 'Helvetica'
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
			fontWeight: 500
			letterSpacing: 0
			color: black
		Body2:
			name: 'Body2'
			style: 'Sans'
			fontSize:  13
			lineHeight: 1.5
			fontWeight: 500
			letterSpacing: 0
			color: black
		Body3:
			name: 'Body3'
			style: 'Sans'
			fontSize:  11
			lineHeight: 1.6
			fontWeight: 500
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
	
	# Text Input
	textInput:
		default:
			color: grey40
			borderColor: grey40
			backgroundColor: white
			shadowBlur: 0
			shadowColor: 'rgba(0,0,0,.16)'
			borderWidth: 1
			borderRadius: 2
		hovered:
			color: grey
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
	# toggle
	toggle:
		toggled:
			default:
				color: white
				borderColor: primary60
				backgroundColor: primary
				shadowColor: 'rgba(0,0,0,.16)'
			disabled:
				color: new Color(black).alpha(.15)
				borderColor: new Color(black).alpha(.15)
				backgroundColor: new Color(primary).alpha(0)
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: white70
				borderColor: primary70
				backgroundColor: primary60
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: white
				borderColor: primary
				backgroundColor: primary40
				shadowColor: 'rgba(0,0,0,.16)'
		default:
			default:
				color: black
				borderColor: grey40
				backgroundColor: white
				shadowColor: 'rgba(0,0,0,.16)'
			disabled:
				color: new Color(black).alpha(.15)
				borderColor: new Color(black).alpha(.15)
				backgroundColor: new Color(white).alpha(0)
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: black
				borderColor: grey40
				backgroundColor: white
				shadowColor: 'rgba(0,0,0,.16)'
			hovered:
				color: black30
				borderColor: grey40
				backgroundColor: grey30
				shadowColor: 'rgba(0,0,0,.16)'
	# Button
	button:
		light_primary:
				default:
					color: white
					borderColor: primary60
					backgroundColor: primary
					shadowColor: 'rgba(0,0,0,.16)'
				disabled:
					color: new Color(black).alpha(.15)
					borderColor: new Color(black).alpha(.15)
					backgroundColor: new Color(primary).alpha(0)
					shadowColor: 'rgba(0,0,0,0)'
				touched:
					color: white70
					borderColor: primary70
					backgroundColor: primary60
					shadowColor: 'rgba(0,0,0,0)'
				hovered:
					color: white
					borderColor: primary
					backgroundColor: primary40
					shadowColor: 'rgba(0,0,0,.16)'
		light_secondary:
				default:
					color: black
					borderColor: beige60
					backgroundColor: beige50
					shadowColor: 'rgba(0,0,0,0)'
				disabled:
					color: new Color(black).alpha(.15)
					borderColor: new Color(black).alpha(.15)
					backgroundColor: new Color(beige50).alpha(0)
					shadowColor: 'rgba(0,0,0,0)'
				touched:
					color: black
					borderColor: beige70
					backgroundColor: beige70
					shadowColor: 'rgba(0,0,0,0)'
				hovered:
					color: black
					borderColor: beige70
					backgroundColor: beige60
					shadowColor: 'rgba(0,0,0,0)'
		dark_primary:
				default:
					color: black
					borderColor: null
					backgroundColor: white
					opacity: 1
					shadowColor: 'rgba(0,0,0,.16)'
				disabled:
					color: grey40
					borderColor: null
					backgroundColor: grey30
					opacity: .5
					shadowColor: 'rgba(0,0,0,0)'
				touched:
					color: primary40
					borderColor: null
					backgroundColor: grey30
					opacity: 1
					shadowColor: 'rgba(0,0,0,.16)'
				hovered:
					color: black40
					borderColor: null
					backgroundColor: grey30
					opacity: 1
					shadowColor: 'rgba(0,0,0,.16)'
		dark_secondary:
				default:
					color: white
					borderColor: white
					backgroundColor: null
					opacity: 1
					shadowColor: 'rgba(0,0,0,0)'
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
		"clearscore-logo":"m128.80919,52c-34.17333,0 -61.80919,28.60368 -61.80919,63.56196c0,34.95828 27.63585,63.56196 61.80919,63.56196c34.17333,0 61.80919,-28.60368 61.80807,-63.72426c-0.48296,-34.99057 -27.78164,-63.39966 -61.80807,-63.39966zm307.4538,39.01923l-147.91012,0l0,49.90123l100.49313,0l0,244.18894l-236.7224,0l0,-103.60458l-47.417,0l0,153.50582l331.5564,0l0,-343.99141zm-260.62007,270.57084l0,-103.60459l-94.45566,0l0,200.54449l378.59506,0l0,-391.03008l-194.94878,0l0,96.93991l100.49313,0l0,197.15027l-189.68374,0z"
		"ios-back":"M213.089096,256.5 L357.982048,111.701564 C368.672651,101.017935 368.672651,83.6963505 357.982048,73.0127216 C347.291446,62.3290928 329.958554,62.3290928 319.267952,73.0127216 L155.017952,237.155579 C144.327349,247.839208 144.327349,265.160792 155.017952,275.844421 L319.267952,439.987278 C329.958554,450.670907 347.291446,450.670907 357.982048,439.987278 C368.672651,429.30365 368.672651,411.982065 357.982048,401.298436"