ChaseApp = angular.module 'ChaseApp'

profileActions =
	get: { method: 'JSONP', params: {jsonp: 'JSON_CALLBACK'} }
	save: { method: 'PATCH', withCredentials: true}

Profile = ($resource, host)->
	$resource host + '/profile/:profile_id',
		null,
		profileActions

ChaseApp.factory 'ProfileResource', ['$resource', 'TagUrl', Profile]
