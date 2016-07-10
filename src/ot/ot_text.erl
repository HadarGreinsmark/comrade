-module(ot_text).
-behaviour(gen_server).

-record(state, {name, doc, version=0}).

-export([start_link/1,
         init/1]).

start_link(DocName) ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, DocName, []).


init(DocName) ->
	lager:info("Doc created ~p", [DocName]),
	{ok, #state{name=DocName}}.


create() ->
	"".


apply(Doc, {put, Pos, NewText}) ->
	<<Left:Pos/binary, Right/binary>> = Doc,
	Left ++ NewText ++ Right;

apply(Doc, {del, Pos, NumChars}) ->
	<<Left:Pos/binary, _Deleted:NumChars/binary, Right/binary>> = Doc,
	Left ++ Right.


transform(Op1, Op2) ->
	{}.