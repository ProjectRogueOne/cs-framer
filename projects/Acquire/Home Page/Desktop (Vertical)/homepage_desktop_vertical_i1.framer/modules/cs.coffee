framework = require 'framework'

# New Components

{ Donut } = require 'cs-components/Donut'
{ Card } = require 'cs-components/Card'

for componentName in [
	'Donut'
	'Card'
]
	c = eval(componentName)
	do (componentName, c) =>
		window[componentName] = (options = {}) =>
			_.assign(options, {app: framework.app})
			return new c(options)