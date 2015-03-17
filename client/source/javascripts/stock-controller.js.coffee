App = angular.module 'Conspiracy'

class StockController
	constructor: (@$scope, Stock, conf)->
		@$scope.items = Stock.query()

		@$scope.newStock = new Stock()
		@$scope.newStock.type = conf.cardTypes[0]
		@$scope.newStock.span = 1
		@$scope.newStock.cost = 0
		@$scope.newStock.influenceGenerated = 0
		@$scope.newStock.controlGenerated = 0

		@$scope.types = conf.cardTypes

		@$scope.$watch 'newStock', @alterForm, true

	alterForm: (newValue, oldValue)=>
		if @$scope.newStock.id
			@$scope.newStock.$save @saveComplete
		else
			@$scope.newStock.$create @saveComplete

	saveComplete: (stock, http)=>
		if stock.$resolved
			@$scope.stockForm.$setPristine()

App.controller 'StockController', ['$scope', 'StockResource', 'Conspiracy.conf', StockController]
