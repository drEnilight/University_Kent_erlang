-module(test_erlang_2).
-export([word/1]).

word(Word) ->
  {ok, Device} = file:open("ukraine_history.txt", [read]),
  try get_all_lines(Device, Word)
    after file:close(Device)
  end.

find_word([], Device, [WH|WT], Acc1, Acc2) ->
  get_all_lines(Device, [WH|WT], Acc1);

find_word(Line, Device, Word, Acc1, Acc2) ->
  [LH | LT] = Line,
  [WH | WT] = Word,
  io:format("~p~n", [Line]),
  case Acc2 /= length(Word) of 
     true -> case LH == WH of
    		    true -> find_word([LT], Device, [WT], Acc1, Acc2 + 1);
    		    false -> find_word([LT], Device, Word, Acc1, 0)
	      end;
     false -> io:format("~p~n", [{Word, Acc1}]),
	      get_all_lines(Device, Word, Acc1)
  end.

get_all_lines(Device, Word) ->
  get_all_lines(Device, Word, 0).

get_all_lines(Device, Word, Acc) ->
  case io:get_line(Device, "") of
      eof  -> [];
      Line -> find_word(Line, Device, Word, Acc, 0)
  end.
