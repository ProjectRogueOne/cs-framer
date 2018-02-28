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

styles =
	serif:
		color: '#000'
		fontFamily: 'Aktiv Grotesk'
		lineHeight: 1.2
	sans:
		color: '#000'
		fontFamily: 'Aktiv Grotesk'
		lineHeight: 1.2
	mono:
		color: '#333'
		fontFamily: 'Menlo'
		lineHeight: 1.2
	H1:
		name: 'H1'
		style: 'sans'
		fontSize: 30
		fontWeight: 300
		color: midnightBlue
	H2:
		name: 'H2'
		style: 'sans'
		fontSize:  20
		fontWeight: 500
		color: midnightBlue
	Body:
		name: 'Body1'
		style: 'sans'
		fontSize:  16
		fontWeight: 500
		color: seaBlue
	Body1:
		name: 'Body1'
		style: 'sans'
		fontSize:  16
		fontWeight: 500
		color: seaBlue
	Body2:
		name: 'Body2'
		style: 'sans'
		fontSize:  14
		fontWeight: 500
		color: seaBlue
	Body3:
		name: 'Body3'
		style: 'sans'
		fontSize:  12
		fontWeight: 500
		color: seaBlue
	Body4:
		name: 'Body4'
		style: 'sans'
		fontSize:  10
		fontWeight: 500
		color: osloGrey
	Body5:
		name: 'Body4'
		style: 'sans'
		fontSize:  8
		fontWeight: 500
		color: osloGrey
	Donut:
		name: 'Donut1'
		style: 'sans'
		fontSize:  90
		fontWeight: 200
	Donut1:
		name: 'Donut1'
		style: 'sans'
		fontSize:  90
		fontWeight: 200
	Donut2:
		name: 'Donut2'
		style: 'sans'
		fontSize:  60
		fontWeight: 200
	Code:
		name: 'Code'
		style: 'mono'
		fontSize:  7.5

if Screen.width <= 768
	_.assign styles,
		H1:
			name: 'H1'
			style: 'sans'
			fontSize:  20
			fontWeight: 500
			color: midnightBlue
		H2:
			name: 'H2'
			style: 'sans'
			fontSize:  16
			fontWeight: 500
			color: midnightBlue
		Donut:
			name: 'Donut1'
			style: 'sans'
			fontSize:  60
			fontWeight: 200
			color: midnightBlue
		Donut1:
			name: 'Donut1'
			style: 'sans'
			fontSize:  60
			fontWeight: 200
			color: midnightBlue
		Donut2:
			name: 'Donut2'
			style: 'sans'
			fontSize:  45
			fontWeight: 300
			color: midnightBlue

for className, style of styles
	do (className, style) =>
		window[className] = (options = {}) =>
			_.defaults options, _.assign(styles[style.style], style)
			return new TextLayer(options)

exports.styles = styles