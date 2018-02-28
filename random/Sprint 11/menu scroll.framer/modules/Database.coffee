# Database

exports.database = 
	offers: []
	categories: [
		'rewards cards',
		'super cards',
		'travel abroad',
		'balance transfer',
		'make it rain',
		'credit balance'
		]
	brands: [
		'Barclays', 
		'AMEX', 
		'LUMA',
		'Vanquis',
		'Natwest',
		'Capital One',
		'Tesco Bank',
		'British Airways'
		]
	products: [
		'Credit Card'
		]
	rateTypes: [
		'Guaranteed', 
		'Select'
		]
	cardImages: [
		'images/card1.png', 
		'images/card2.png'
		]
	features: [
		'amazon cashback',
		'20 bottles of beer',
		'Free tickets to movies'
		]
	
	filter: (offer) -> return true
	
	setFilter: ->
		@filter = (offer) ->
			filter = filterPage.getFilter()
			
			onPreapproved = true
			if filter.preapprovedOnly
				onPreapproved = offer.preapproved is filter.preapprovedOnly
				
			onCategory = true 
			if filter.cardCategories.length > 0
				onCategory = _.includes(filter.cardCategories, offer.category)
			
			onAPR = 
				filter.apr.min <= offer.apr and
				offer.apr <= filter.apr.max
			
			onBrand = true 
			if filter.brands.length > 0
				onBrand = _.includes(filter.brands, offer.brand)
			
			onFeature = true 
			if filter.features.length > 0
				onBrand = _.includes(filter.features, offer.feature)
			
			return _.every([
				onBrand, 
				onAPR, 
				onCategory, 
				onFeature, 
				onPreapproved
				])
	
	getFiltered: (array) ->
		filter = filterPage.getFilter()
		return _.filter(array, @filter)
	
	getSorted: (array) ->
		sort = sortPage.getSort()
		direction = sortPage.getSortDirection()
		sorted = _.sortBy(array, sort)
		if direction is 'descending' then sorted = _.reverse(sorted)
		return sorted
		
	getOffers: ->
		@setFilter()
		filteredOffers = @getFiltered(@offers)
		sortedOffers = @getSorted(filteredOffers)
		return sortedOffers