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

tap_area.onTap ->
	report_bg.animate
		opacity: 0
		options:
			time: .25