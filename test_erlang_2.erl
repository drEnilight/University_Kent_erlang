-module(test_erlang_2).
-export([word/1]).

word(Word) ->
  {ok, Device} = file:open("ukraine_history.txt", [read]),
  try get_all_lines(Device, Word)
    after file:close(Device)
  end.

get_all_lines(Device, Word) ->
  get_all_lines(Device, Word, 0).

get_all_lines(Device, Word, Acc) ->
  case io:get_line(Device, "") of
      eof  -> [];
      Line -> Split_string = re:split(Line, " ", [{return, list}]),
              find_word(Split_string, Device, Word, Acc)
  end.

find_word([], Device, Word, Acc1) ->
  get_all_lines(Device, Word, Acc1);

find_word(Line, Device, Word, Acc1) ->
  [LH | LT] = Line,
  [WH | WT] = Word.
  case Acc2 /= length(Word) of
    true -> case LH == WH of
      true -> find_word([LT], Device, [WT], Acc1);
      false -> find_word([LT], Device, Word, Acc1)
    end;
    false -> io:format("~p~n", [{Word, Acc1}]),
             get_all_lines(Device, Word, Acc1)
  end.
