-module(doc_manager).
-behaviour(gen_server).

-export([start_link/0,
         init/1,
         terminate/2,
         handle_call/3,
         get_doc_proc/1]).


-record(state, {openDocs = []}).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).


init([]) ->
	lager:info("Manager created"),
	{ok, #state{}}.


terminate(Reason, State) ->
	ok.

get_doc_proc(DocName) ->
	gen_server:call(?MODULE, {get_doc_proc, DocName}).


handle_call({get_doc_proc, DocName}, _From, #state{openDocs=OpenDocs} = State) ->
	lager:info("handle_call"),
	case lists:keyfind(DocName, 1, OpenDocs) of
		{_, Pid} ->
			{reply, Pid, State};
		false ->
			{ok, Pid} = supervisor:start_child(ot_text_sup, [DocName]),
			NewDoc = {DocName, Pid},
			{reply, Pid, State#state{openDocs = [NewDoc|OpenDocs]}}
	end.
