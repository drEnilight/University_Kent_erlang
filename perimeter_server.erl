-module(perimeter_server).
-export([start/0, perimeter/1]).

start() -> spawn(fun loop/0).

perimeter({Pid, Request}) ->
  rpc(Pid, Request).

rpc(Pid, Request) ->
    Pid ! {self(), Request},
    receive
        {Pid, Response} ->
            Response
    end.

loop() ->
    receive
        {From, {circle, R}} ->
            From ! {self(), 2 * math:pi() * R},
            loop();
        {From, {rectangle, Length, Width}} ->
            From ! {self(), (Length+Width)*2},
            loop();
        {From, {triangle, A, B, C}} ->
            From ! {self(), (A+B+C)},
            loop()
    end.
