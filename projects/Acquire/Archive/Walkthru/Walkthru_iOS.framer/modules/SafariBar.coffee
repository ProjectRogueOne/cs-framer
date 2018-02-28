# Safari Bar
# Authors: Steve Ruiz
# Last Edited: 25 Sep 17

# Todo: 
# Replace the status bar image with three SVG layers, so that it works on all device sizes.
# Set size of URL to adjust for different sizes.

Type = require 'Mobile'
{ Colors } = require 'Colors'
{ Icon } = require 'Icon'
{ MobileHeader } = require 'MobileHeader'

class exports.SafariBar extends MobileHeader
	constructor: (options = {}) ->
		@__constructor = true
		showNames = options.showNames ? false

		{ app } = require 'App'

		options.url ?= 'clearscore.com'

		# always collapse
		_.assign options,
			collapse: true

		super options

		# status bar

		@statusBar = new Layer
			name: if showNames then 'Status Bar' else '.'
			parent: @
			width: @width
			height: Screen.width * (40/750)
			image: "modules/cs-ux-images/ios_status_bar.png"
		
		@_closedHeight = @statusBar.height

		# url field
		
		@urlField = new TextLayer
			name: if showNames then 'URL Field' else '.'
			parent: @
			backgroundColor: Colors.field1
			x: Align.center
			y: @statusBar.maxY + 4
			width: @width - 20
			height: 30
			fontSize: 16
			color: '#000'
			textAlign: 'center'
			padding: {top: 6}
			animationOptions: @animationOptions
			borderRadius: 8
			text: '{url}'

		# refresh icon
		
		@refreshIcon = new Icon
			name: if showNames then 'Refresh Icon' else '.'
			parent: @urlField
			x: Align.right(-8)
			y: Align.center
			color: '#000'
			icon: 'refresh'
			animationOptions: @animationOptions

		# bottom nav

		@bottomNav = new Layer
			name: if showNames then 'Bottom Nav' else '.'
			height: 46
			width: Screen.width
			backgroundColor: 'rgba(248, 248, 248, 1.000)'
			shadowY: -1
			shadowColor: 'rgba(0,0,0,.16)'
			clip: true
			animationOptions: @animationOptions

		@bottomNav.onTap (event) -> event.stopPropagation()

		@controls = new Layer
			name: if showNames then 'Controls SVG' else '.'
			parent: @bottomNav
			backgroundColor: null
			height: 27
			width: 343
			x: Align.center
			y: Align.center
			style:
				lineHeight: 0

		@controls.html = """
			<svg 
				xmlns='http://www.w3.org/2000/svg' 
				width='100%' 
				height='100%' 
				viewBox='0 0 #{@controls.width} #{@controls.height}'
				>
					<g id="Icons">
			            <path d="M170.5,1.99887027 L167.4735,5.0628993 C167.384,5.1558993 167.237,5.1538993 167.145,5.0578993 L166.768,4.6558993 C166.676,4.5603993 166.673,4.4073993 166.7625,4.3143993 L170.9565,0.0683993048 C171.0455,-0.0246006952 171.1925,-0.0226006952 171.285,0.0733993048 L171.662,0.475399305 C171.700372,0.515439278 171.723174,0.565307893 171.730226,0.616625043 L175.497,4.3833993 C175.586,4.4753993 175.584,4.6268993 175.4925,4.7213993 L175.079,5.1168993 C174.9875,5.2118993 174.842,5.2138993 174.7535,5.1223993 L171.5005,1.86897363 L171.5005,17.0043993 L170.5,17.0043993 L170.5,1.99887027 Z M162.5,8.5043993 L162.5,25.5043993 L179.5,25.5043993 L179.5,8.5043993 L173.5,8.5043993 L173.5,7.5043993 L180.5,7.5043993 L180.5,26.5043993 L161.5,26.5043993 L161.5,7.5043993 L168.5,7.5043993 L168.5,8.5043993 L162.5,8.5043993 Z" id="Share" fill="#007AFF"></path>
			            <path d="M318.5,25.9995 L337.5,25.9995 L337.5,7.5 L318.5,7.5 L318.5,25.9995 Z M336.5,25 L319.5,25 L319.5,8.4995 L336.5,8.4995 L336.5,25 Z M325.0005,6.5 L324.0005,6.5 L324.0005,2 L343.0005,2 L343.0005,21 L338.5005,21 L338.5005,20.0201416 L342.0005,20.0201416 L342.0005,3 L325.0005,3 L325.0005,6.5 Z" id="Tabs" fill="#007AFF"></path>
			            <path d="M257.656,2.5 C255.0275,2.5 252.833,3.6065 251.5,5.5635 C250.1675,3.6065 247.9725,2.5 245.344,2.5 C242.28,2.5 239,4.1395 239,6.58 L239,24.923 C239,25.116 239.105,25.293 239.274,25.3845 C239.4435,25.475 239.6495,25.466 239.808,25.36 C239.8485,25.333 243.8935,22.664 247.1555,22.664 C249.269,22.664 250.5225,23.7795 250.9895,26.0755 C250.9925,26.091 251.002,26.104 251.0065,26.119 C251.015,26.1475 251.0255,26.174 251.0385,26.2005 C251.0535,26.2305 251.07,26.2575 251.09,26.2835 C251.1065,26.3055 251.124,26.326 251.144,26.345 C251.168,26.3685 251.194,26.388 251.2225,26.406 C251.245,26.4205 251.267,26.435 251.2925,26.4455 C251.325,26.46 251.3585,26.468 251.394,26.476 C251.4125,26.48 251.4285,26.49 251.448,26.492 C251.465,26.4935 251.482,26.4945 251.4995,26.4945 L251.4995,26.4945 L251.5,26.4945 L251.5005,26.4945 L251.501,26.4945 C251.518,26.4945 251.535,26.493 251.5525,26.492 C251.5715,26.49 251.5875,26.4805 251.606,26.476 C251.641,26.468 251.675,26.4605 251.7075,26.4455 C251.7325,26.4345 251.7545,26.4205 251.7775,26.406 C251.806,26.388 251.832,26.3685 251.856,26.345 C251.876,26.326 251.893,26.3055 251.9095,26.2835 C251.9295,26.2575 251.946,26.2305 251.9605,26.2005 C251.9735,26.174 251.984,26.1475 251.9925,26.119 C251.997,26.104 252.0065,26.091 252.0095,26.0755 C252.4765,23.7795 253.7305,22.664 255.8435,22.664 C259.106,22.664 263.1505,25.3325 263.191,25.36 C263.35,25.4655 263.5555,25.475 263.725,25.3845 C263.894,25.293 263.999,25.116 263.999,24.923 L263.999,6.58 C264,4.1395 260.7205,2.5 257.656,2.5 L257.656,2.5 Z M247.156,21.6165 C244.472,21.6165 241.456,23.1655 240.042,23.9885 L240.042,6.58 C240.042,4.9935 242.5695,3.5485 245.3445,3.5485 C247.8545,3.5485 249.901,4.6985 250.9795,6.7095 L250.9795,23.386 C250.1195,22.22 248.8295,21.6165 247.156,21.6165 L247.156,21.6165 Z M262.9585,23.9885 C261.5445,23.1655 258.5285,21.6165 255.8445,21.6165 C254.171,21.6165 252.881,22.22 252.021,23.386 L252.021,6.71 C253.0995,4.699 255.1465,3.549 257.656,3.549 C260.431,3.549 262.958,4.994 262.958,6.5805 L262.958,23.9885 L262.9585,23.9885 Z" id="Shape-2" fill="#007AFF"></path>
			            <path d="M0.180705638,14.7187499 L0.1775,14.722 L1.2905,15.85 L1.29352556,15.8469325 L9.051,23.7115 L10.16,22.587 L2.40279804,14.7222716 L10.193,6.824 L9.08,5.696 L1.29000903,13.5940577 L1.2865,13.5905 L0.1775,14.7155 L0.180705638,14.7187499 Z" id="row" fill="#007AFF"></path>
			            <path d="M84.6807056,14.7187499 L84.6775,14.722 L85.7905,15.85 L85.7935256,15.8469325 L93.551,23.7115 L94.66,22.587 L86.902798,14.7222716 L94.693,6.824 L93.58,5.696 L85.790009,13.5940577 L85.7865,13.5905 L84.6775,14.7155 L84.6807056,14.7187499 Z" id="row-2" fill="#C4C4C4" transform="translate(89.685250, 14.703750) scale(-1, 1) translate(-89.685250, -14.703750) "></path>
			        </g>
			</svg>
			"""	

		@tapArea = new Layer
			name: if showNames then 'Back' else '.'
			width: 100
			parent: @bottomNav
			x: @controls.x - 40
			height: @bottomNav.height
			borderRadius: @bottomNav.height / 2
			backgroundColor: null

		@tapArea.onTap -> app?.showPrevious()
	
		# set app footer as bottomNav

		app.footer = @bottomNav

		delete @__constructor

		@url = options.url 
			
		@on "change:factor", (factor) ->
			for layer in [@urlField]
				layer.y = Utils.modulate(
					factor, 
					[0, 1], 
					[10, @statusBar.maxY + 4], 
					true
					)

				layer.opacity = factor

				layer.backgroundColor = new Color(Colors.field1).alpha(factor)

				layer.scale = Utils.modulate(
					factor, 
					[0, 1], 
					[.7, 1], 
					true
					)

			@bottomNav.y = Utils.modulate(
				factor, 
				[0, 1], 
				[Screen.height, Screen.height - 46], 
				true
				)

			@refreshIcon.opacity = factor
				
		@on "change:status", (status) ->
			switch status
				when 'open'
					for layer in [@urlField]
						layer.animate 
							y: @statusBar.maxY + 4, 
							backgroundColor: Colors.field1
							scale: 1
							opacity: 1

					@refreshIcon.animate { opacity: 1 }
					@bottomNav.animate { y: Screen.height - 46 }
			
				when 'close'
					for layer in [@urlField]
						layer.animate 
							y: 10, 
							backgroundColor: new Color(Colors.field1).alpha(0)
							scale: .7
							opacity: 0
				
					@refreshIcon.animate { opacity: 0 }
					@bottomNav.animate { y: Screen.height }

	@define "url",
		get: -> return @_url
		set: (url) ->
			return if @__constructor 

			@_url = url
			@urlField.template = url