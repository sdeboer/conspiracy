-module(json_handler).

-export([
				 return_json/3,
				 encode_response/4,
				 construct_response/3, construct_response/4
				]).

return_json(Json, Req, S) ->
	case cowboy_req:qs_val(<<"jsonp">>, Req) of
		{undefined, R2} -> 
			{Json, R2, S};
		{Fn, R2} ->
			B = [Fn, <<"(">>, Json, <<");">>],
			{B, R2, S}
	end.

%encode_response(Resp, Req, State) -> construct_response(jiffy:encode(Resp), Req, State).

encode_response(Resp, Req, Code, State) ->
	construct_response(jiffy:encode(Resp), Req, Code, State).

construct_response(Json, Req, State) ->
	construct_response(Json, Req, State, 200).

construct_response(Json, Req, State, Code) ->
	{Body, R1, S} = return_json(Json, Req, State),
	{ok, R2} = cowboy_req:reply(
							 Code,
							 [{<<"content-type">>, <<"application/json">>}],
							 Body,
							 R1),
	{true, R2, S}.
