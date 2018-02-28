# Helpers

exports.random = 
	firstName: -> _.sample(['John', 'Mary', 'Mark', 'Sue'])
	lastName: ->  _.sample(['Smith', 'Anderson', 'Liamson', 'Romani'])
	location: ->  _.sample(['Chicago', 'London', 'New York', 'Madrid'])


exports.formatDateTime = (date) -> 
	return date.toLocaleDateString(['en-us'], 
		'month': 'short', 
		'day': 'numeric', 
		'weekday': 'long', 
		'hour':'numeric', 
		'minute': '2-digit' 
	)

exports.formatShortDate = (date) -> 
	return date.toLocaleDateString(['en-us'], 
		'weekday': 'long', 
		'hour':'numeric', 
		'minute': '2-digit' 
	)

exports.formatDate = (date) -> 
	return date.toLocaleDateString(['en-us'], 
		'month': 'short', 
		'day': 'numeric', 
		'weekday': 'long'
	)