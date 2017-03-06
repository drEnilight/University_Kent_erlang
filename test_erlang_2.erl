-module(test_erlang_2).
-export([word/1]).

word(Word) ->
  {ok, Device} = file:open("ukraine_history.txt", [read]),
  try get_all_lines(Device, Word)
    after file:close(Device)
  end.

get_all_lines(Device, Word) ->
  get_all_lines(Device, Word, {1, []}).

get_all_lines(Device, Word, {LineNumber, Entrancies}) ->
  case io:get_line(Device, "") of
      eof  -> lists:reverse(Entrancies);
      Line -> SplitedString = re:split(string:to_lower(Line), " ", [{return, list}]),
              case lists:member(string:to_lower(Word), SplitedString) of
                true -> get_all_lines(Device, Word, {LineNumber + 1, [{Word, LineNumber} | Entrancies]});
                false -> get_all_lines(Device, Word, {LineNumber + 1, Entrancies})
              end
  end.
