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


websocket_handle({text, OpJSON}, Req, State) ->
	lager:info("New handle1"),
	Op = jsx:decode(OpJSON),
	OpName = lists:nth(1, Op),
	case OpName of
		<<"open">> ->
			LocalID = lists:nth(2, Op),
			OpID = lists:nth(2, Op),
			Pid = doc_manager:start_subscription(OpID, self(),
			State2 = State#state{openDocs = [{LocalID, Pid}|OpenDocs]}
			{reply, {text, ...}, Req, State2};
		<<"close">> ->
			;
		_ ->
			;
	end,
	Pid = doc_manager:start_subscription("My secret diary"),
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
