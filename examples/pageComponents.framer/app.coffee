require 'cs'

# basic scroll component

s = new ScrollComponent
	height: Screen.height
	backgroundColor: '#333'
	scrollHorizontal: false
	width: Screen.width / 5

for i in _.range(12)
	new Layer
		parent: s.content
		gradient: 
			start: '#ffcc33'
			end: '058a5f'
		hueRotate: i * 45
		width: Screen.width / 5
		y: i * 220
		
new H2
	parent: s
	text: 'Scroll Component'
	x: 16
	y: 16
	color: '#000'

# basic page component

p = new PageComponent
	height: Screen.height
	scrollHorizontal: false
	width: Screen.width / 5
	x: Screen.width * 1/5
	brightness: 90
	yOffset: .5

for i in _.range(12)
	container = new Layer
		y: i * 200
		height: 220
		width: Screen.width / 5
		backgroundColor: '#333'
		
	page = new Layer
		parent: container
		gradient: 
			start: '#ffcc33'
			end: '058a5f'
		width: container.width
		hueRotate: i * 45
	
	p.addPage(container, 'bottom')
	
p.on "change:currentPage", (page) =>
	page.saturate = 100
	for sib in page.siblings
		sib.saturate = 0

p.snapToPage(p.content.children[0])
		
new H2
	parent: p
	text: 'Page Component'
	width: p.width - 32
	x: 16
	y: 16
	color: '#000'

# screen height page component

fp = new PageComponent
	height: Screen.height
	scrollHorizontal: false
	width: Screen.width / 5
	x: Screen.width * 2/5
	brightness: 80
	yOffset: 0

for i in _.range(12)
	container = new Layer
		y: i * 200
		height: Screen.height + 20
		width: Screen.width / 5
		backgroundColor: '#333'
		
	page = new Layer
		parent: container
		gradient: 
			start: '#ffcc33'
			end: '058a5f'
		width: container.width
		height: Screen.height
		hueRotate: i * 45
	
	fp.addPage(container, 'bottom')

	fp.on "change:currentPage", (page) =>
	page.saturate = 100
	for sib in page.siblings
		sib.saturate = 0

fp.snapToPage(fp.content.children[0])
		
title = new H2
	parent: fp
	text: 'Page Component'
	x: 16
	y: 16
	width: fp.width - 32
	color: '#000'
		
new Body
	parent: fp
	text: '@ screen height'
	x: 16
	y: title.maxY
	width: fp.width - 32
	color: '#000'

# more than screen height page component

fpp = new PageComponent
	height: Screen.height
	scrollHorizontal: false
	width: Screen.width / 5
	x: Screen.width * 3/5
	brightness: 80
	yOffset: 0

for i in _.range(12)
	container = new Layer
		y: i * 200
		height: (Screen.height * 2) + 20
		width: Screen.width / 5
		backgroundColor: '#333'
		
	page = new Layer
		parent: container
		gradient: 
			start: '#ffcc33'
			end: '058a5f'
		width: container.width
		height: Screen.height * 2
		hueRotate: i * 45
	
	fpp.addPage(container, 'bottom')

	fpp.on "change:currentPage", (page) =>
	page.saturate = 100
	for sib in page.siblings
		sib.saturate = 0

fpp.snapToPage(fpp.content.children[0])
		
title = new H2
	parent: fpp
	text: 'Page Component'
	x: 16
	y: 16
	width: fp.width - 32
	color: '#000'
		
new Body
	parent: fpp
	text: 'taller than \tscreen height'
	x: 16
	y: title.maxY
	width: fp.width - 32
	color: '#000'

# super special page transition component

ptc = new PageTransitionComponent
	height: Screen.height
	scrollHorizontal: false
	width: Screen.width / 5
	x: Screen.width * 4/5
	brightness: 80
	yOffset: 0

containers = []

for i in _.range(12)
	container = ptc.newPage
		name: if i is 1 then 'special' else '.'
		height: (Screen.height * 2) + 20
		width: Screen.width / 5
		gradient: 
			start: '#ffcc33'
			end: '058a5f'
		grid: true
		hueRotate: i * 45
	
	ptc.on "change:currentPage", (page) =>
		page.saturate = 100
		for sib in page.siblings
			sib.saturate = 0
			
	containers.push(container)


textBox = new Layer
	parent: ptc
	y: 260
	height: 64
	borderRadius: 8
	x: Align.center()
	width: ptc.width - 16
	backgroundColor: '#34b3f1'
	opacity: 0
	
textBoxText = new H2
	parent: textBox
	y: Align.center(2)
	x: Align.center()
	color: '#000'
	opacity: 1
	text: 'Click Here'
	
circle = new Layer
	parent: ptc
	borderWidth: 1
	borderColor: '#00f49c'
	backgroundColor: null
	borderRadius: ptc.width
	width: ptc.width * 2
	height: ptc.width * 2
	y: 500
	x: Align.center()
	opacity: 0
	
ptc.content.children[1].on "change:factor", (factor, layer) ->
	if factor < 0
		textBox.opacity = 0
		circle.opacity = 0
	if 0 < factor < 1
		textBox.y = Utils.modulate(factor, [0, 1], [Screen.height/2 + 300, Screen.height/2], true)
		textBox.opacity = Utils.modulate(factor, [0, 1], [0, 1], true)
		circle.opacity = 0
	else if 1 < factor < 2
		textBox.opacity = 1
		circle.opacity = Utils.modulate(factor, [1, 2], [0, 1], true)
		circle.height = Utils.modulate(factor, [1, 2], [ptc.width * 2, ptc.width], true)
		circle.width = Utils.modulate(factor, [1, 2], [ptc.width * 2, ptc.width], true)
		circle.x = Align.center()
		circle.borderWidth = Utils.modulate(factor, [1, 2], [1, 24], true)
	else if 2 < factor < 3
		textBox.y = Utils.modulate(factor, [2, 3], [Screen.height/2, Screen.height/2 - 300], true)
		circle.y = Utils.modulate(factor, [2, 3], [500, 0], true)
		textBox.opacity = Utils.modulate(factor, [2, 3], [1, 0], true)
		circle.opacity = Utils.modulate(factor, [2, 3], [1, 0], true)
	else if factor > 3
		textBox.opacity = 0
		
# 	print factor


ptc.snapToPage(ptc.content.children[0])
		
title = new H2
	parent: ptc
	text: 'Page Transition Component'
	x: 16
	y: 16
	width: ptc.width - 32
	color: '#000'
		
# new Body
# 	parent: ptc
# 	text: 'scrollY: '
# 	x: 16
# 	y: title.maxY
# 	width: fp.width - 32
# 	color: '#000'
