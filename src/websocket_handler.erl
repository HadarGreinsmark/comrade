-module (websocket_handler).
-behaviour(cowboy_http_handler).


-export([init/2, 
         websocket_handle/3,
         terminate/3]).

-record(state, {
	openDocs = []
}).

init(Req, Opts) ->
	lager:info("New request"),
	% Req2 = cowboy_req:set_resp_header("sec-websocket-protocol", "comrade/0.1", Req),
	% CONTINUE: start/terminate child, check if started, terminated
	{cowboy_websocket, Req, Opts}.


websocket_handle({text, _}, Req, State) ->
	lager:info("New handle1"),
	Pid = doc_manager:get_doc_proc("My secret diary"),
	lager:info("started on pid ~p", [Pid]),
	{reply, {text, "Delicious!"}, Req, State};

websocket_handle(_Data, Req, State) ->
	lager:info("New handle2"),
	{ok, Req, State}.

terminate(_Reason, _Req, #state{openDocs=OpenDocs}) ->
	lager:info("start terminate"),
	% lists:foreach(fun(DocId) ->
	% lager:info("terminate one"),
	% 	ok = supervisor:terminate_child(ot_text_sup, DocId) 
	% end, OpenDocs),
	ok.
