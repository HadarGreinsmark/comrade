-module(doc_manager_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
	lager:info("doc man"),
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
	{ok, { {one_for_one, 5, 10}, [
		#{ id => doc_manager, start => {doc_manager, start_link, []} },
		#{ id => ot_text_sup, start => {ot_text_sup, start_link, []} }
	]}}.
