-module(stock_handler).
-include("cost.hrl").
-include("stock.hrl").

-export([init/3]).

% Rest Standards
-export([
				 rest_init/2,
				 content_types_provided/2, content_types_accepted/2,
				 allowed_methods/2, resource_exists/2, allow_missing_post/2
				]).

% Callbacks
-export([
				 to_json/2,
				 alter_stock/2
				]).

-record(state, {
					stock_id = undefined,
					stock = undefined
				 }).

init(_Transport, _Req, _Opts) ->
	{upgrade, protocol, cowboy_rest}.

rest_init(Req, _RouteOpts) ->
	lager:error("HERE!"),
	case cowboy_req:binding(stock_id, Req) of
		{undefined, R2} ->
			{ok, R2, undefined};
		{StockId, R2} ->
			{ok, R2, #state{stock_id = StockId}}
	end.

allowed_methods(Req, undefined) ->
	lager:debug("ALLOWED"),
	{[ <<"GET">>, <<"POST">> ], Req, undefined};

allowed_methods(Req, S) ->
	{[<<"GET">>, <<"PATCH">>, <<"PUT">>, <<"DELETE">>], Req, S}.

% used for get
content_types_provided(Req, S) ->
	lager:debug("type_provided"),
	{[
		{{<<"application">>, <<"json">>, '*'}, to_json},
		{<<"text/html">>, to_json},  % should be to_html
		{<<"text/plain">>, to_json}  % should be to_text
	 ], Req, S}.

% used for put and post
content_types_accepted(Req, S) ->
	lager:debug("type_accepted"),
	{[
		%{{<<"application">>, <<"x-www-form-urlencoded">>, []}, alter_stock},
		{{<<"application">>, <<"json">>, '*'}, alter_stock}
	 ], Req, S}.

resource_exists(Req, undefined) ->
	lager:debug("exists undefined"),
	case cowboy_req:method(Req) of
		{<<"POST">>, R2} ->
			{ false, R2, undefined };
		{<<"GET">>, R2} ->
			{ true, R2, list}
	end;

resource_exists(Req, S) ->
	lager:debug("exists other ~p", [ S ]),
	StockId = S#state.stock_id,
	case stock:find(StockId) of
		undefined ->
			{false, Req, S};

		Stock ->
			{true, Req, S#state{stock = Stock}}
	end.

allow_missing_post(Req, S) -> {false, Req, S}.

alter_stock(Req, undefined) ->
	case cowboy_req:body(Req) of
		{ok, Body, R2} ->
			Stock = stock:create(jiffy:decode(Body)),
			StockId = stock:id(Stock),
			% actually needs to include "stock/" in the path
			% or, preferably get the initial part out of the 
			% Req object.
			{ {true, <<$/, StockId/binary>>},
				R2,
				#state{stock=Stock, stock_id = StockId}
			};

		{error, Reason} ->
			json_handler:encode_response({error, Reason}, Req, undefined, 400)
	end;

alter_stock(Req, S) ->
	case cowboy_req:body(Req) of
		{ok, Body, R2} ->
			{ok, Stock} = stock:update(S#state.stock, jiffy:decode(Body)),
			Json = stock:to_json(Stock),
			%json_handler:construct_response(Json, R2, S);
			S2 = #state{stock_id = Stock#stock.id, stock = Stock},
			json_handler:return_json(Json, R2, S2);

		{error, Reason} ->
			json_handler:encode_response({error, Reason}, Req, S, 400)
	end.

to_json(Req, list) ->
	J = stock:list(),
	Json = jiffy:encode(J),
	json_handler:return_json(Json, Req, list);

to_json(Req, S) ->
	Json = stock:to_json(S#state.stock),
	json_handler:return_json(Json, Req, S).

