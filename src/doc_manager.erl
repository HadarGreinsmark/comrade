-module(doc_manager).
-behaviour(gen_event).

-export([start_link/0,
         init/1,
         terminate/2,
         handle_call/3,
         get_doc_proc/2,
         start_subscription/2,
         end_subscription/2]).


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

start_subscription(DocId, EditorPid) ->
	gen_server:call(?MODULE, {start_subscription, DocId, EditorPid}).

% takes DocId and EditorPid in order to find the link between socket and document
end_subscription(DocId, EditorPid) ->
	gen_server:call(?MODULE, {end_subscription, DocId, EditorPid}).


handle_call({start_subscription, DocId, EditorPid}, _From, State) ->
	lager:info("handle_call"),
	Reply = case supervisor:start_child(ot_text_sup, [DocId]) of
		{ok, Pid} ->
			{reply, Pid, State};
		{error, {already_started, Pid}} ->
			{reply, Pid, State}
	end,
	ot_text:register_editor(EditorPid),
	Reply;


handle_call({end_subscription, DocManagerPid, EditorPid}, _From, State) ->
	ok.