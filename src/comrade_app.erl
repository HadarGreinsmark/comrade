-module(comrade_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    lager:warning("Start app"),
    {ModPath, _} = filename:find_src(?MODULE),
    lager:info(ModPath),
    lager:info("privvv up"),
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", cowboy_static, {priv_file, comrade, "static/index.htm"}},
            {"/comrade", websocket_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_http(http, 100, [{port, 9000}], [{env, [{dispatch, Dispatch}]}]),
    comrade_sup:start_link().

stop(_State) ->
    ok.
