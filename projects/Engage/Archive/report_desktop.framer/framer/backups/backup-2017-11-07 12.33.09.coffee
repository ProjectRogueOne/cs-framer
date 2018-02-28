cs = require 'cs'

# Device / Setup

cs.Context.setMobile()
Framer.Extras.Hints.disable()

Framer.Device.customize
	deviceType: Framer.Device.Type.Tablet
	screenWidth: 1440
	screenHeight: 876
	deviceImage: 'modules/cs-ux-images/safari_device.png'
	deviceImageWidth: 1442	
	deviceImageHeight: 1087
	devicePixelRatio: 1

Screen.backgroundColor = '#FFF'
Framer.Device.screen.y = 62

SLIDE_DETAILS_IN = false

switch SLIDE_DETAILS_IN
	when true
	
		details_nav.opacity = 0
	
		details_bg.x = Screen.width
		
		tap_area.onTap ->
			details_bg.bringToFront()
			details_bg.animate
				x: 0
				options:
					time: .4
					
			details_nav.bringToFront()
			details_nav.animate 
				opacity: 1
				options:
					time: .25
					delay: .15
			
		back_area.onTap ->
			details_nav.animate 
				opacity: 0
			details_bg.x = 0
			
			details_bg.animate
				x: Screen.width
				options:
					time: .25

	when false
		details_nav.bringToFront()
		report_bg.bringToFront()
		
		details_nav.opacity = 0
	
		tap_area.onTap ->
			details_nav.bringToFront()
			details_nav.opacity = 0
			details_nav.animate 
				opacity: 1
				options:
					time: .25
					delay: .15
					
		back_area.onTap ->
			details_nav.bringToFront()
			details_nav.animate 
				opacity: 0
				options:
					time: .25
					delay: .15
			