-module (websocket_handler).
-behaviour(cowboy_http_handler).


-export([init/2, 
         websocket_handle/3,
         terminate/3]).

-record(state, {
	openDocs = [] % TODO: doesn't scale well
}).

init(Req, State) ->
	lager:info("New request"),
	lager:info("444~p",[State]),
	% Req2 = cowboy_req:set_resp_header("sec-websocket-protocol", "comrade/0.1", Req),
	% CONTINUE: start/terminate child, check if started, terminated
	{cowboy_websocket, Req, #state{}}.


websocket_handle({text, OperationJSON}, Req, State) ->
	lager:info("New handle1"),
	Operation = jsx:decode(OperationJSON),
	lager:info("444~p",[Operation]),
	OpName = lists:nth(1, Operation),
	case Operation of
		[<<"open">>, LocalID, ClientVersion, DocId] ->
			Pid = doc_manager:start_subscription(DocId, self()),
			lager:info("111~p",[State]),
			State2 = State#state{openDocs = [{LocalID, Pid}|State#state.openDocs]},
			lager:info("000~p",[State2]),
			FrameMsg = jsx:encode([ok, LocalID, ClientVersion]),
			{reply, {text, FrameMsg}, Req, State2}; % TODO: should send update based on the client version

		[<<"close">>, LocalID] ->
			{value, {_, Pid}} = lists:keysearch(LocalID, 1, State#state.openDocs),
			doc_manager:end_subscription(Pid, self()),
			OpenDocs2 = lists:keydelete(LocalID, State#state.openDocs),
			State2 = State#state{openDocs = OpenDocs2},
			{ok, Req, State2}
			;
		%[<<"ins">>, LocalID, ClientVersion, DocId] ->
		%	;
		_ ->
			{ok, Req, State}
	end;
	%Pid = doc_manager:start_subscription("My secret diary"),
	%lager:info("started on pid ~p", [Pid]);
	%{reply, {text, "Delicious!"}, Req, State};

websocket_handle(_Data, Req, State) ->
	lager:info("New handle2"),
	{ok, Req, State}.

terminate(_Reason, _Req, _State) -> %#state{openDocs=OpenDocs}
	lager:info("start terminate"),
	% lists:foreach(fun(DocId) ->
	% lager:info("terminate one"),
	% 	ok = supervisor:terminate_child(ot_text_sup, DocId) 
	% end, OpenDocs),
	ok.
