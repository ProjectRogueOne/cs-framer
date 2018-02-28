layer = new Layer
	image: 'images/loading.png'
	point: Align.center()

setImage = (response) -> 
	layer.image = response.url
	
response = fetch("https://source.unsplash.com/random").then(setImage)