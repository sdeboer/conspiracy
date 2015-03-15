InjectorService = angular.module 'angular.js.injector', []

Injector = ($compile, $rootScope)->
	scope = null
	singlePageMode = false
	head = angular.element document.head

	$rootScope.$on('$locationChangeStart', ->
		removeAll() if singlePageMode)

	_initScope = ->
		scope ?= head.scope()
	
	addJsFile = (href)->
		_initScope()

		if scope.injectedJS?
			for i in scope.injectedJS when i.href == href
				return
		else
			scope.injectedJS = []
			#head.append($compile("<script data-ng-repeat='js in injectedJS' data-ng-src='{{js.href}}' type='text/javascript'></script>")(scope))
			head.append($compile("<link data-ng-repeat='js in injectedJS' data-ng-href='{{js.href}}' rel='stylesheet' />")(scope))

		scope.injectedJS.push href: href
	
	removeAll = ->
		_initScope()

		scope.injectedJS ?= []

	setSinglePageMode = (bool)-> singlePageMode = !!bool

	{
		add: addJsFile
		removeAll: removeAll
		setSinglePageMode: setSinglePageMode
	}

InjectorService.service 'jsInjector', ['$compile', '$rootScope', Injector]
