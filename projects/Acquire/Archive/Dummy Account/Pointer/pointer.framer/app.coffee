homepage.point = 0

pointer.bringToFront()

pwidth = Screen.width
pHeight = Screen.width * pointer.height/pointer.width

pointer.width = pwidth
pointer.height = pHeight

homepage.onMouseMove (event) ->
		pointer.point = event.point
		