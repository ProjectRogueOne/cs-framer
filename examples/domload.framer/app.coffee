data = undefined

# data.json ___
# 
# {
# 	"name": "Batman",
# 	"profession": "Superhero"
# }
#

Utils.domLoadJSON './data.json', (error, data) => 
	hero.text = data.name
	job.text = data.profession

hero = new TextLayer
	text: 'hero'
	
job = new TextLayer
	y: 64
	text: 'job'