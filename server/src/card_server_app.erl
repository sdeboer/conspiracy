-module(card_server_app).

-behaviour(application).
-export([start/2, stop/1]).

-define(C_ACCEPTORS, 5).

start(normal, _StartArgs) ->
	PortOpts = [{port, port()}],
	ProtoOpts = [
			{env, [{dispatch, routes()}]},
			{middlewares, [cowboy_router, cors, sessions, cowboy_handler]}
			],

	case cowboy:start_http(http, ?C_ACCEPTORS, PortOpts, ProtoOpts) of
		{ok, _CowboyPid} ->
			card_server_sup:start_link();
		{error, Report} ->
			lager:error("!! Critical error starting http : ~p", [Report]),
			% Ideally this should actually stop the whole thing....but
			% we want the error messages and returning anything but {ok, pid()}
			% here causes the badmatch error to occur before logs are written
			{ok, self()}
	end.

stop(_State) ->
	ok.

routes() ->
	cowboy_router:compile(
		[{'_',
				[
				 %{"/deck/[:deck_id]", card_handler, []},
				 %{"/game/[:game_id]", card_handler, []},
				 {"/stock/[:stock_id]", stock_handler, []}
					%{"/static/[...]", cowboy_static, [
					%		{directory, {priv_dir, card_server, [<<"static">>]}}
							%{mimetypes, {fun mimetypes:path_to_mimes/2, default}}
					%		]}
					]
				}]
		).

port() ->
	case os:getenv("PORT") of
		false ->
			{ok, Port2} = application:get_env(http_port),
			Port2;
		Port ->
			Port
	end.
