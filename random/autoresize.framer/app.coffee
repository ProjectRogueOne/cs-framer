# Auto resize
# @steveruizok

l = new Layer

t = document.createElement('textarea')

l._element.appendChild(t)

t.oninput = -> 
	t.style.height = 'auto'
	t.style.height = t.scrollHeight + 'px'
	l.height = t.scrollHeight
	