-module(ot_text_sup).
-behaviour(supervisor).

-export ([start_link/0,
          init/1]).

start_link() ->
	lager:info("ee"),
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
	{ok, { {simple_one_for_one, 5, 10}, [
		#{ id => ot_text, start => {ot_text, start_link, []} }
	]}}.
