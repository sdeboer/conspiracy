App = angular.module 'Conspiracy'
App.constant 'Conspiracy.conf',
	cardTypes: [
		{ name: 'Secret Master', value: 'master'},
		{ name: 'Character', value: 'character'},
		{ name: 'Action', value: 'action'}
	]

