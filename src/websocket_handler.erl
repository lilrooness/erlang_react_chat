-module(websocket_handler).

-export([init/3,
        websocket_init/3,
        websocket_handle/3,
        websocket_info/3,
        websocket_terminate/3]).

-record(state, {
  username = undefined
}).

init(_Type, _Req, _Opts) ->
  {upgrade, protocol, cowboy_websocket}.

websocket_init(_Type, Req, _Opts) ->
  {ok, Req, #state{}}.

websocket_handle({text, Username}, Req, #state{username=undefined} = State) ->
  io:format("New Connection from ~p~n", [Username]),
  case chat_room:register_new_connection({Username, self()}) of
    ok ->
      {reply, {text, "Welcome " ++ Username}, Req, State#state{username=Username}};
    {error, name_taken} ->
      {reply, {text, "Username in use"}, Req, State}
  end;


websocket_handle({text, Message}, Req, State) ->
  chat_room:emit_message(Message),
  {ok, Req, State}.

websocket_info({new_message, Message}, Req, State) ->
  {reply, [{text, Message}], Req, State};

websocket_info(_Info, Req, State) ->
  {ok, Req, State}.

websocket_terminate(_Reason, _Req, State) ->
  chat_room:unregister_connection(State#state.username),
  ok.
