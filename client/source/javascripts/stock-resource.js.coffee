stockActions =
	get: { method: 'JSONP', params: {jsonp: 'JSON_CALLBACK'} }
	update: { method: 'PUT', withCredentials: true }
	create: { method: 'POST', withCredentials: true }
	query:
		method: 'JSONP'
		isArray: true
		params:
			jsonp: 'JSON_CALLBACK'
			mine: true

Stock = ($resource, host)->
	$resource host + '/stock/:stock_id',
		null,
		stockActions

angular.module('Conspiracy').factory 'StockResource', ['$resource', 'MasterUrl', Stock]
