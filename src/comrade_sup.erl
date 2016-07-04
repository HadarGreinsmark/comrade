-module(comrade_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).
	
start_link() ->
    lager:debug("Start sup"),
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {ok, { {one_for_one, 5, 10}, []} }.

