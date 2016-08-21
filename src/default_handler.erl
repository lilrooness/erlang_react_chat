-module(default_handler).

-export([init/3, handle/2, terminate/3]).

-record(state, {

}).

init(_Transport, Req, []) ->
  {ok, Req, #state{}}.

handle(Req, State=#state{}) ->
  {ok, Req2} = cowboy_req:reply(200,
  [{<<"content-type">>, <<"text/plain">>}], <<"Hello Erlang!">>, Req),
  {ok, Req2, State}.

terminate(_, _, _) ->
  ok.
