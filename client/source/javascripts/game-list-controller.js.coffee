ChaseApp = angular.module 'ChaseApp'

gameTypes = [ { id: 0, name: "robot"},
	{ id: 1, name: "just another"} ]

Controller = ($scope, $location, game)->
	$scope.games = game.list()
	$scope.types = gameTypes
	$scope.currentType = 0
	#$scope.game = game.get game_id: 12

	$scope.playGame = (id)-> $location.path '/play'

	$scope.createGame = ->
		game.create {game_type: $scope.currentType}, (game)->
			console.log 'GC', game.id, game
			$location.path '/play/' + game.id

ChaseApp.controller 'GameListController', ['$scope', '$location', 'GameResource', Controller]
