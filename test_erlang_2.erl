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
      Line -> Line ++ get_all_lines(Device, Word, Acc + 1, 0),
              Res = {Word,Line},
              io:format("~p~n", [Res])
  end.

find_word([LH|LT], Device, [WH|WT], Acc1, Acc2) ->
  case LH == WH of
    true -> find_word([LH|LT], Device, [WH|WT], Acc1, Acc2)
