require "gotcha/gotcha"
cs = require "cs"

Utils.loadWebFont('Roboto')

# Status Bar

statusBar = new Layer
	name: 'StatusBar'
	width: Screen.width
	height: 24
	backgroundColor: '#121d27'

statusBarItems = new Layer
	name: 'StatusBarItems'
	parent: statusBar
	height: 14
	width: 94
	x: Align.right(-8)
	y: Align.center
	backgroundColor: null
	style: { lineHeight: 0 }
	
statusBarItems.html = """
			<svg width="100%" height="100%" viewBox="0 0 #{statusBarItems.width} #{statusBarItems.height}" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
			   
			    <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
			        <g id="Group" transform="translate(-15.000000, -5.000000)">
			            <rect id="bounds" x="0" y="0" width="118" height="24"></rect>
			            <g id="time" opacity="0.9" transform="translate(74.000000, 4.000000)" font-size="14" font-family=".AppleSystemUIFont" fill-opacity="0.600000024" fill="#FFF" font-weight="normal">
			                <text id="12:30">
			                    <tspan x="0.083984375" y="14">12:30</tspan>
			                </text>
			            </g>
			            <g id="battery" transform="translate(55.000000, 4.000000)">
			                <polygon id="bounds" points="0 0 16 0 16 16 0 16"></polygon>
			                <polygon id="Shape" fill-opacity="0.600000024" fill="#FFF" points="9 1.875 9 1 6 1 6 1.875 3 1.875 3 15 12 15 12 1.875"></polygon>
			            </g>
			            <g id="cellular" transform="translate(35.000000, 4.000000)">
			                <polygon id="bounds" points="0 0 16 0 16 16 0 16"></polygon>
			                <polygon id="Shape" fill-opacity="0.600000024" fill="#FFF" points="0 15 14 15 14 1"></polygon>
			            </g>
			            <g id="wifi" transform="translate(14.000000, 4.000000)">
			                <polygon id="bounds" points="2 0 18 0 18 16 2 16"></polygon>
			                <path d="M0.977372085,4.01593123 C3.48821908,2.12256382 6.61301513,1 10,1 C13.3869849,1 16.5117809,2.12256382 19.0226279,4.01593123 L10,15 L0.977372085,4.01593123 Z" id="Shape" fill-opacity="0.600000024" fill="#FFF"></path>
			            </g>
			        </g>
			    </g>
			</svg>
			"""

# Bottom Nav

bottomNav = new Layer
	name: 'Bottom Nav'
	height: 48
	width: Screen.width
	backgroundColor: '#000'

controls = new Layer
	name: 'Controls SVG'
	parent: bottomNav
	backgroundColor: null
	height: 17
	width: 217
	x: Align.center
	y: Align.center
	style:
		lineHeight: 0

controls.html = """
	<svg 
		xmlns='http://www.w3.org/2000/svg' 
		width='100%' 
		height='100%' 
		viewBox='0 0 #{controls.width} #{controls.height}'
		>
			<path 
				d="M202.987704,1.98931197 C202.439436,1.98931197 201.993644,2.4353736 201.993644,2.98337224 L201.993644,14.9952517 C201.993644,15.5435194 202.439706,15.989312 202.987704,15.989312 L214.999584,15.989312 C215.547851,15.989312 215.993644,15.5432503 215.993644,14.9952517 L215.993644,2.98337224 C215.993644,2.43510451 215.547582,1.98931197 214.999584,1.98931197 L202.987704,1.98931197 Z M107.993644,15.989312 C111.859637,15.989312 114.993644,12.8553052 114.993644,8.98931197 C114.993644,5.12331872 111.859637,1.98931197 107.993644,1.98931197 C104.127651,1.98931197 100.993644,5.12331872 100.993644,8.98931197 C100.993644,12.8553052 104.127651,15.989312 107.993644,15.989312 Z M13.7660756,1.10241733 L1.21690631,8.35702959 C0.927718066,8.52420787 0.927677959,8.45629197 1.21690637,8.62349348 L13.7660759,15.8781062 C14.0542153,16.0446782 13.9936439,16.079742 13.9936439,15.7448743 L13.9936436,1.23564932 C13.9936436,0.900828227 14.0542573,0.935820879 13.7660756,1.10241733 Z"
				stroke-width: '2'
				stroke='#FFFFFF'
				fill='rgba(0,0,0,0)'
				/>
	</svg>
	"""	

rippleTapArea = new Layer
	name: 'Back'
	width: 100
	parent: @bottomNav
	x: controls.x - 40
	height: bottomNav.height
	borderRadius: bottomNav.height / 2
	backgroundColor: 'rgba(255, 255, 255, .28)'
	opacity: 0

do _.bind( -> # backTapArea

	@sendToBack()

	rippleStart = =>
		@props =
			scale: .7
			opacity: 0

		@animate
			scale: 1
			opacity: 1
			options:
				time: .15

	rippleEnd = =>
		@animate
			opacity: 0
			options:
				time: .55

	@onTapStart -> 
		rippleStart()

	@onTapEnd -> 
		rippleEnd()
		app?.showPrevious()

, rippleTapArea)

app = new cs.App
	type: 'ios'
	
# app.header = statusBar
# app.footer = bottomNav

# Walkthru View
class WalkthruView extends cs.View
	constructor: (options = {}) ->
		
		_.defaults options,
			backgroundColor: '#23364b'
			ctas: ['Okay', 'No Thanks']
			text: 'Testing'
			height: Screen.height
			width: Screen.width
			title: ''
		
		_.assign options,
			icon: false
# 			title: 
# 				text: ''
		
		super options
	
		@ctas = []
		
		
		@scrimBody = new Layer
			name: 'scrim body'
			parent: @
			y: Align.bottom()
			width: @width
			height: 128
			backgroundColor: '#23364b'
		
		@scrimFade = new Layer
			name: 'scrim fade'
			parent: @
			maxY: @scrimBody.y
			width: @width
			height: 64
			gradient: 
				start: '#23364b'
				end: new Color('#23364b').alpha(0)
		
# 		@scrimBodyTop = new Layer
# 			name: 'scrim body top'
# 			parent: @
# 			y: 0
# 			width: @width
# 			height: 64
# 			backgroundColor: '#23364b'
# 		
# 		@scrimFadeTop = new Layer
# 			name: 'scrim fade top'
# 			parent: @
# 			y: @scrimBodyTop.maxY
# 			width: @width
# 			height: 64
# 			gradient: 
# 				start: new Color('#23364b').alpha(0)
# 				end: '#23364b'

		
		if options.icon
		
			@icon = new Layer
				name: 'icon'
				parent: @
				height: 96
				width: 96
				x: Align.center
				y: @height * .09
				borderRadius: 999
				borderWidth: 2
				borderColor: '#FFF'
				backgroundColor: null
				
			@iconicon = new cs.Icon 
				icon: 'help'
				parent: @icon
				x: Align.center(4)
				y: Align.center(4)
				color: 'white'
			
		if options.header?
			@titleLayer = new cs.Text 
				name: 'header'
				parent: @content
				y: (@icon?.maxY ? 6) + 38
				width: @width - 32
				x: Align.center
				fontSize: 25
				textAlign: 'center'
				text: options.header
				fontFamily: 'AktivGrotesk-Medium'
				color: cs.Colors.white
				
			@titleLayer.fontSize = 24
			
			@titleLayer.name = 'Title'
		
		@text = new TextLayer
			name: 'text'
			parent: @content
			y: (@titleLayer?.maxY ? @icon?.maxY ? 73) + 30
			width: @width - 32
			x: Align.center
			fontSize: 16
			lineHeight: 1.375
			textAlign: 'center'
			text: options.text
			fontFamily: 'AktivGrotesk-Light'
			color: cs.Colors.white
				
		@scrimBody.placeBefore(@text)
# 		@scrimBodyTop.placeBefore(@text)
		@scrimFade.placeBefore(@text)
# 		@scrimFadeTop.placeBefore(@text)
		@titleLayer?.bringToFront()
		
		if options.icon
			iconStartY = @icon.y
			@content.on "change:y", =>
				factor = Utils.modulate(@scrollY, [0, @icon.height], [1, 0])
					
				_.assign @icon,
					y: iconStartY - (@scrollY * .73)
					opacity: Utils.modulate(@scrollY, [0, iconStartY + @icon.height], [1, 0])
	# 				scale: Utils.modulate(@scrollY, [0, @icon.height], [1, .7])
				
		@setCTAs(options.ctas)
		
		@updateContent()
	
	setCTAs: (array = []) =>
		for cta in @ctas
			cta.animate
				opacity: 0
				options:
					time: .15
			
		cta?.once onAnimationEnd, =>
			cta.destroy() for cta in @ctas
			@ctas = []
		
		for cta, i in array
			@ctas[i] = new cs.Button
				parent: @
				y: Align.bottom(i * -60)
				height: 60
				width: @width
				x: 0
				fill: if cta.primary then '#f0f9fd' else '#f0f9fd'
				shadowY: 1
				shadowColor: 'rgba 151 151 151, 0.4'
				color: if cta.primary then 'main' else 'main'
				text: cta.text
				type: 'body1'
				action: nextView
				borderRadius: 0
				borderWidth: 1
			
			_.assign @ctas[i].textLayer,
				fontFamily: 'AktivGrotesk-Medium'
				fontSize: 14
				y: Align.center(1)
		
		_.assign @scrimBody,
			y: _.last(@ctas)?.y - 16
			height: Screen.height - ((_.last(@ctas)?.y ? Screen.height - 128) + 16)
		
		_.assign @scrimFade,
			maxY: _.last(@ctas)?.y - 15
		
		@hackyhackysolution = @scrimBody.copy()
		
		_.assign @hackyhackysolution,
			parent: @content
			y: @text.maxY
			

views = []
v = 0

nextView = -> 
	v++
	app.showNext(views[v])

headerLottery = ['Hello there', 'What else can I do?', undefined]
ctaLottery = [
	{text: 'Okay', primary: true},
	{text: 'Whatever', primary: false}
	{text: 'No Thanks', primary: false}
	{text: 'Not gonna happen', primary: false}
	]
	
textLottery = 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet.Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet. ntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet.Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet.'

for i in _.range(10)
	view = new WalkthruView
		ctas: ctaLottery[0... _.random(1, 3) ]
		text: textLottery[0 ... _.random(100, 900)]
		header: _.sample(headerLottery)
		icon: i % 2 is 0
	views.push(view)