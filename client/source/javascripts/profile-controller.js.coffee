ChaseApp = angular.module 'ChaseApp'

class ProfileController
	constructor: ($scope, $location, plist)->
		$scope.profile = profile = plist.observer

		$scope.pickGame = -> $location.path '/game_list'

		$scope.$watch 'profile.handle', (newValue, oldValue)->
			if oldValue? and newValue isnt oldValue

				profile.$save $scope.profile, (newProfile, httpResponse)->
					if newProfile.$resolved
						$scope.profileForm.$setPristine()

ChaseApp.controller 'ProfileController', ['$scope', '$location', 'ProfileList', ProfileController]
