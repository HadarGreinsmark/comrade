-module(doc_manager).
-behaviour(gen_server).

-export([start_link/0,
         init/1,
         terminate/2,
         handle_call/3,
         get_doc_proc/1]).


-record(state, {}).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).


init([]) ->
	lager:info("Manager created"),
	{ok, #state{}}.


terminate(Reason, State) ->
	ok.

get_doc_proc(DocId, EditorPid) ->
	gen_server:call(?MODULE, {get_doc_proc, DocId, EditorPid}).


handle_call({start_subscription, DocId, EditorPid}, _From, State) ->
	lager:info("handle_call"),
	case supervisor:start_child(ot_text_sup, DocId) of
		{ok, Pid} ->
			{reply, Pid, State};
		{error, {already_started, Pid}} ->
			{reply, Pid, State}
	end,
	ot_text:register_editor(EditorPid).


handle_call({end_subscription, DocId}, _From, State) ->
	lager:info("handle_call"),
	case supervisor:start_child(ot_text_sup, DocId) of
		{ok, Pid} ->
			{reply, Pid, State};
		{error, {already_started, Pid}} ->
			{reply, Pid, State}
	end.