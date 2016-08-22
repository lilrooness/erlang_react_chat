-module(ews_util).

-export([encode_message/2,
        decode_message/1,
        parse_message_data/2]).

encode_message(Message, Type) ->
  jsx:encode([{<<"message">>, Message}, {<<"type">>, Type}]).

decode_message(Message) ->
  case jsx:decode(Message) of
    false ->
      {error, invalid_message};
    Data ->
      Type = proplists:get_value(<<"type">>, Data),
      Content = proplists:get_value(<<"message">>, Data),
      parse_message_data(Type, Content)
  end.

parse_message_data(<<"message">>, Content) ->
  {message, Content};
parse_message_data(<<"command">>, Content) ->
  {command, Content};
parse_message_data(_Type, _Content) ->
  {error, unhandled_message_type}.
