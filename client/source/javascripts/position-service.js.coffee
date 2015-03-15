ChaseApp = angular.module 'ChaseApp'

class PositionCanvas
	constructor: (@profiles)->
		@page = paper
		@page.setup "playMap"
		pv = @page.view
		vw = pv.viewSize.width
		h = vw * 9 / 16
		pv.viewSize = [vw, h]

		b = pv.bounds
		vm = Math.max b.width, b.height
		@scale = vm / 4000
		c = pv.center
		@c_x = c.x
		@c_y = c.y

		@players = {}

		@origin = new @page.Path.Circle pv.center, 3
		@origin.strokeColor = 'green'

		@page.view.draw()
		@page.view.onFrame = @onFrame
		
	updatePlayer: (d)=>
		pid = d.playerID
		xy = @transform new @page.Point(d)
		@profiles.add pid

		if circ = @players[pid]
			circ.position = xy
		else
			circ = new @page.Path.Circle xy, 10
			color = if @profiles.isObserver pid
				'purple'
			else
				'red'

			circ.strokeColor = color
			@players[pid] = circ

	onFrame: (e)=>

	transform: (pt)->
		new @page.Point (pt.x * @scale) + @c_x, -(pt.y * @scale) + @c_y

class PositionService
	constructor: (@profiles)->

	canvas: =>
		new PositionCanvas @profiles

ChaseApp.service 'PositionService', ['ProfileList', PositionService]
