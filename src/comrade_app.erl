-module(comrade_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    lager:info("privvv up"),
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", cowboy_static, {priv_file, comrade, "static/index.htm"}},
            {"/comrade", websocket_handler, []}
        ]}
    ]),
    lager:info("first"),
    doc_manager_sup:start_link(),
    {ok, _} = cowboy:start_http(http, 100, [{port, 9000}], [{env, [{dispatch, Dispatch}]}]),
    comrade_sup:start_link().

stop(_State) ->
    ok.
