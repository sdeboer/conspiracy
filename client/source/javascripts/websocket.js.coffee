ChaseApp = angular.module 'ChaseApp'

class SocketContainer
	constructor: (@$q, @$rootScope, @host)->
		@callbacks = {}
		@callbackId = 0

	_getCallbackId: ->
		if @callbackId > 10000
			@callbackId = 0
		else
			@callbackId += 1

	setHost: (@host)->

	connect: (@id)->
		@ws = new WebSocket(@host + @id)

		@ws.onopen = @onOpen
		@ws.onerror = @onError
		@ws.onclose = @onClose

		@ws.onmessage = @onMessage

		@

	close: ->
		@ws.close()

	sendRequest: (request)->
		defer = @$q.defer()
		cid = @_getCallbackId()
		console.log "send", cid
		@callbacks[cid] =
			time: Date.now()
			cb: defer

		request.callback_id = cid
		console.log "sending", request
		@ws.send JSON.stringify(request)
		defer.promise

	onError: =>
		console.log "WS error for " + @id, arguments...

	onClose: =>
		console.log "WS closed for " + @id

	onOpen: =>
		console.log "WS opened for " + @id

	onMessage: (msg)=>
		console.log "WS msg ", msg
		data = JSON.parse msg.data
		cid = data.callback_id

		if cid and cid of @callbacks
			@$rootScope.$apply ->
				@callbacks[cid].cb.resolve data.data

			delete @callbacks[cid]
		else
			@$rootScope.$broadcast data.command, data

		@

ChaseApp.service 'WebSocket', ['$q', '$rootScope', 'WebsocketUrl', SocketContainer]
