%%%-------------------------------------------------------------------
%% @doc ews_server public API
%% @end
%%%-------------------------------------------------------------------

-module(ews_server_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
  Dispatch = cowboy_router:compile([
    {'_', [
     {"/websocket", websocket_handler, []},
     {"/chat/[...]", cowboy_static, {priv_dir, ews_server, "chat_client/build"}},
     {"/static/[...]", cowboy_static, {priv_dir, ews_server, "chat_client/build/static"}}
    ]}
  ]),
  cowboy:start_http(http_listener, 100, [{port, 8000}],
    [{env, [{dispatch, Dispatch}]}]
  ),
  ews_server_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
