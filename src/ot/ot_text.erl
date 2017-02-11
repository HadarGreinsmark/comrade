-module(ot_text).
-behaviour(gen_server).

-record(state, {docID, openEditors = sets:new(), opList = []}).

-export([start_link/1,
  init/1,
  add_editor/1,
  remove_editor/1,
  terminate/2,
  handle_cast/2]).

start_link(DocID) ->
  lager:info("sl ot ~p", [DocID]),
  gen_server:start_link({local, ?MODULE}, ?MODULE, [DocID], []).


init([DocID]) ->
  lager:info("Doc created ~p", [DocID]),
  {ok, #state{docID = DocID}}.


terminate(_Reason, _State) ->
  ok.

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


add_editor(EditorPid) ->
  gen_server:cast(?MODULE, {add_editor, EditorPid}).

remove_editor(EditorPid) ->
  gen_server:cast(?MODULE, {remove_editor, EditorPid}).

handle_cast({add_editor, EditorPid}, #state{openEditors = OpenEditors} = State) ->
  State2 = State#state{openEditors = sets:add_element(EditorPid, OpenEditors)},
  {noreply, State2};

handle_cast({remove_editor, EditorPid}, #state{openEditors = OpenEditors} = State) ->
  State2 = State#state{openEditors = sets:del_element(EditorPid, OpenEditors)},
  {noreply, State2}.

