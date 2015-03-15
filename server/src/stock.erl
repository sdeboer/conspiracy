-module(stock).
-include("cost.hrl").
-include("stock.hrl").

-export([
				 find/1,
				 create/1,
				 list/0
				]).

-export([
				 update/2,
				 to_json/1
				]).

-define(STOCK, ?MODULE_STRING).
-define(STOCK_LIST, [?MODULE_STRING, <<"list">>]).

find(SID) ->
	persist:load([?STOCK, SID]).

create({P}) ->
	S = list_to_tuple(
				[stock| [
								 proplists:get_value(X, P)
								 || X <- record_info(fields, stock)
								]
				]),
	SID = persist:generate(),
	S2 = S#stock{id = SID},
	persist:save([?STOCK, SID] , S2),
	persist:add( persist:set(?STOCK_LIST), SID),
	S2.

list() ->
	{ M, _S } = persist:members( persist:set(?STOCK_LIST) ),
	[ find(X) || X <- M ].

update(S, {P}) ->
	Fields = record_info(fields, stock),
	S2 = lists:foldl( fun(X, Acc) ->
												case proplists:get_value(X, P) of
													undefined -> Acc;
													V ->
														setelement( index(X, Fields), Acc, V )
												end
										end,
										S, Fields),
	SID = S2#stock.id,
	persist:save([?STOCK, SID], SID),
	S2.

to_json(S) -> jiffy:encode(S).

index(V, X) ->
	index(V, X, 1).

index(_V, [], _N) -> error;

index(V, [H|T], N) ->
	if H =:= V -> N;
		 true -> index(V, T, N + 1)
	end.
