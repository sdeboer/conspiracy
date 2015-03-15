ChaseApp = angular.module 'ChaseApp'

class ProfileService
	constructor: (@resource)->
		@observer = @resource.get()
		@profiles = [@observer]

	length: -> @profiles.length

	add: (pid)->
		if pid and !@has(pid)
			@profiles.push @resource.get(profile_id: pid)

		@

	isObserver: (pid)->
		@observer.id is pid

	has: (pid)->
		!!@profile pid

	profile: (pid)->
		for profile in @profiles when profile.id is pid
			return profile

		null

ChaseApp.service 'ProfileList', ['ProfileResource', ProfileService]
