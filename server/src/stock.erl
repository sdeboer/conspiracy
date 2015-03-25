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
				 remove/1,
				 to_proplist/1,
				 to_json/1
				]).

% Backend Utilities
-export([
				 clear_all/0,
				 remove_set/0,
				 show_set/0,
				 get_it/1
				]).

-define(STOCK, ?MODULE_STRING).
-define(STOCK_LIST, [?MODULE_STRING, <<"list">>]).

-define(R2P(Record),
				record_to_proplist(#Record{} = Rec) ->
						Z = lists:zip(
									record_info(fields, Record), tl(tuple_to_list(Rec))
								 ),
						lists:filter(fun({_K, undefined}) -> false;
														(_X) -> true end,
												 Z)).

?R2P(stock).

find(SID) ->
	persist:load([?STOCK, SID]).

get_value(K, P)->
	Kb = atom_to_binary(K, utf8),
	proplists:get_value( Kb, P).

create({P}) ->
	S = list_to_tuple(
				[stock| [ get_value(X, P)
									|| X <- record_info(fields, stock)
								]
				]),
	SID = persist:generate(),
	S2 = S#stock{id = SID},
	persist:save([?STOCK, SID] , S2),
	persist:add( [SID], persist:set(?STOCK_LIST)),
	S2.

remove(S) ->
	SID = S#stock.id,
	{ok, _S} = persist:remove([SID], persist:set(?STOCK_LIST)),
	persist:del([?STOCK, SID]),
	ok.

list() ->
	{ M, _S } = persist:members( persist:set(?STOCK_LIST) ),
	[ find(X) || X <- M ].

update(S, {P}) ->
	Fields = record_info(fields, stock),
	S2 = lists:foldl( fun(X, Acc) ->
												case X of
													id -> Acc;
													K ->
														case proplists:get_value(atom_to_binary(K, utf8), P) of
															undefined -> Acc;
															V ->
																I = index(K, Fields) + 1,
																setelement( I, Acc, V )
														end
												end
										end,
										S, Fields),
	persist:save([?STOCK, S2#stock.id], S2),
	S2.

to_proplist(S) -> {record_to_proplist(S)}.

to_json(S) -> jiffy:encode( to_proplist(S) ).

index(V, X) ->
	index(V, X, 1).

index(_V, [], _N) -> error;

index(V, [H|T], N) ->
	if H =:= V -> N;
		 true -> index(V, T, N + 1)
	end.

% Utilities for backend management
clear_all() ->
	[ remove(S) || S <- list() ].

remove_set() ->
	persist:deset(?STOCK_LIST).

show_set() ->
	persist:members(persist:set(?STOCK_LIST)).

get_it(K) ->
	persist:dumb_load([?STOCK, K]).
