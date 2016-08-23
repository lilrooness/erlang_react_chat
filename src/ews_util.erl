-module(ews_util).

-export([encode_message/3,
        decode_message/2,
        parse_message_data/3]).

encode_message(Message, Type, Username) ->
  jsx:encode([{<<"message">>, Message}, {<<"type">>, Type}, {<<"username">>, Username}]).

decode_message(Message, Username) ->
  case jsx:decode(Message) of
    false ->
      {error, invalid_message};
    Data ->
      Type = proplists:get_value(<<"type">>, Data),
      Content = proplists:get_value(<<"message">>, Data),
      parse_message_data(Type, Content, Username)
  end.

parse_message_data(<<"message">>, Content, Username) ->
  {message, Content, Username};
parse_message_data(<<"command">>, Content, Username) ->
  {command, Content, Username};
parse_message_data(_Type, _Content, _Username) ->
  {error, unhandled_message_type}.
