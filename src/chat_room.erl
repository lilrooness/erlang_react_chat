-module(chat_room).

-behaviour(gen_server).

-record(state, {
  connections=[]
}).

-export([start_link/0,
        init/1,
        handle_call/3,
        handle_cast/2,
        terminate/2]).

-export([register_new_connection/1,
        unregister_connection/1,
        emit_message/1]).

% CALLBACK FUNCTIONS #####################################

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
  {ok, #state{}}.


% Check that no connections by NewName exist, if not then add
% new connection to connections list. If name exists then
% reply with "name_taken"
handle_call({register, {NewName, _Pid} = Connection}, _From,
            #state{connections=Connections} = State) ->

  case proplists:get_value(NewName, Connections) of
    undefined ->
      {reply, "ok", State#state{connections=Connections ++ [Connection]}};
    _ ->
      {reply, "name_taken", State}
  end;

handle_call({unregister, Username}, _From,
            #state{connections=Connections} = State) ->
  NewConnections = proplists:delete(Username, Connections),
  {reply, ok, State#state{connections=NewConnections}}.

handle_cast({emit, Message}, State) ->
  FEFun = fun({_, Pid}) ->
    Pid ! {new_message, Message}
  end,

  lists:foreach(FEFun, State#state.connections),
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

% API FUNCTIONS ##########################################

register_new_connection(Connection) ->
  gen_server:call(?MODULE, {register, Connection}).

unregister_connection(Username) ->
  gen_server:call(?MODULE, {unregister, Username}).

emit_message(Message) ->
  gen_server:cast(?MODULE, {emit, Message}).
