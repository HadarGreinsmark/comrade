-module (websocket_handler).
-behaviour(cowboy_http_handler).


-export([init/2, 
         websocket_handle/3,
         terminate/3]).

-record(state, {
}).

init(Req, Opts) ->
	lager:info("New request"),
	% Req2 = cowboy_req:set_resp_header("sec-websocket-protocol", "comrade/0.1", Req),
	{cowboy_websocket, Req, Opts}.


websocket_handle({text, _}, Req, State) ->
	lager:info("New handle1"),
	{reply, {text, "Delicious!"}, Req, State};

websocket_handle(_Data, Req, State) ->
	lager:info("New handle2"),
	{ok, Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.
