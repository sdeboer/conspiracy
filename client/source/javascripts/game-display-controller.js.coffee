ChaseApp = angular.module 'ChaseApp'

class Controller
	constructor: (@$scope, $window, $route, @socket, positionService)->

		@canvas = positionService.canvas()
		@socket.connect $route.game_id

		@$scope.game_id = $route.game_id
		@$scope.debug = true

		@$scope.$on 'location', @locationChange
		@$scope.$on '$destroy', @destroy

		if @geo = $window.navigator?.geolocation
			@$scope.supportsGeo = true
			@geo.getCurrentPosition @setupFn, @errorFn

	setupFn: (p)=>
		@watchID = @geo.watchPosition @watchPosition, @errorFn,
			enableHighAccuracy: true
			maximumAge: 30000
			timeout: 60000

		@watchPosition p

	errorFn: (e)=>
		@geo.clearWatch(@watchID) if @watchID

		@$scope.$apply =>
			@$scope.supportsGeo = false

	watchPosition: (position)=>
		console.log "GD should have something", position
		@socket.sendRequest
			command: 'geo'
			coords: position.coords

		@$scope.$apply =>
			@$scope.current = position.coords

	locationChange: ($e, data)=>
		@canvas.updatePlayer data

	destroy: ($e)=>
		@geo.clearWatch(@watchID) if @watchID
		@socket.close()

ChaseApp.controller 'GameDisplayController', ['$scope', '$window', '$routeParams', 'WebSocket', 'PositionService', Controller]
