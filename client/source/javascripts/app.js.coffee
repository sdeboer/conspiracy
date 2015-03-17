app = (router, location, http)->
	http.defaults.useXDomain = true
	http.defaults.withCredentials = true
	delete http.defaults.headers.common['X-Requested-With']

	router.when('/welcome/',
		templateUrl: '/templates/welcome.html')

	router.when('/stock/',
		templateUrl: '/templates/stock.html')

	router.when('/layout/',
		templateUrl: '/templates/layout.html')

	router.otherwise redirectTo: '/welcome'

	#location.html5Mode false

angular.module 'Conspiracy',
	['ngResource', 'ngRoute', 'angular.js.injector'],
	['$routeProvider', '$locationProvider', '$httpProvider', app]
