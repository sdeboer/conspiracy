app = (router, location, http)->
	http.defaults.useXDomain = true
	http.defaults.withCredentials = true
	delete http.defaults.headers.common['X-Requested-With']

	router.when('/profile/:profile_id',
		templateUrl: '/templates/profile.html')

	router.when('/profile',
		templateUrl: '/templates/profile.html')

	router.when('/welcome',
		templateUrl: '/templates/welcome.html')

	router.when('/game_list',
		templateUrl: '/templates/game_list.html')

	router.when('/play/:game_id',
		templateUrl: '/templates/play.html')

	router.otherwise redirectTo: '/welcome'

	location.html5Mode false

angular.module 'ChaseApp',
	['ngResource', 'ngRoute', 'angular.js.injector'],
	['$routeProvider', '$locationProvider', '$httpProvider', app]
