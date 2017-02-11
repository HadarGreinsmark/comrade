-module(ot_text_sup).
-behaviour(supervisor).

-export ([start_link/0,
          init/1]).

start_link() ->
	lager:info("ee"),
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
	{ok, { {simple_one_for_one, 5, 10}, [
		#{ id => undefined, start => {ot_text, start_link, []} }
	]}}.


request_doc(DocId) ->
	case supervisor:start_child(ot_text_sup, [DocId]) of
						{ok, Pid} ->
							ot_text_sup:add_editor(DocId);
						{error, {already_started, Pid}} ->
							ot_text:remove_editor(DocId)
					end,

reject_doc(DocId) ->