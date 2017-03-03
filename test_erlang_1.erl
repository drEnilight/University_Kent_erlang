-module(test_erlang_1).
-export([perimeter/1, area/1, enclose/1, bits/1, dup/1]).

%%%-------------------------------------------------------------------
%% Define a function perimeter/1 which takes a shape and returns
%% the perimeter of the shape.
%%%-------------------------------------------------------------------

perimeter({circle, R}) ->
	io:format("perimeter for circle is ~p~n", [2 * math:pi() * R]);
perimeter({rectangle, Length, Width}) ->
	io:format("perimeter for rectangle is ~p~n", [(Length+Width)*2]);
perimeter({triangle, A, B, C}) ->
	io:format("perimeter for triangle is ~p~n", [(A+B+C)]).

%%%-------------------------------------------------------------------
%% Choose a suitable representation of triangles, and augment area/1
%% and perimeter/1 to handle this case too.
%%%-------------------------------------------------------------------

area({circle, R}) ->
	io:format("area for circle is ~p~n", [math:pi() * R * R]);
area({rectangle, Length, Width}) ->
	io:format("area for rectangle is ~p~n", [Length*Width]);
area({triangle, A, B, C}) ->
	P = (A + B + C)/2,
	math:sqrt(P*(P-A)*(P-B)*(P-C)).

%%%-------------------------------------------------------------------
%% Define a function enclose/1 that takes a shape an returns the
%% smallest enclosing rectangle of the shape.
%%%-------------------------------------------------------------------

enclose({circle,R}) ->
	{rectangle, R * 2, R * 2};
enclose({rectangle, Length, Width}) ->
	{rectangle, Length, Width};
enclose(S = {triangle, A, B, C}) ->
	Area = area(S),
	Base = max(max(A, B), max(B, C)),
	Height = (Area * 2) / Base,
	{rectangle, Height, Base}.

%%%-------------------------------------------------------------------
%% Define a function bits/1 that takes a positive integer N and returns
%% the sum of the bits in the binary representation. For example bits(7)
%% is 3 and bits(8) is 1.
%%%-------------------------------------------------------------------

bits(N) ->
	bits(N, 0).
bits(0, Acc) ->
	Acc;
bits(N, Acc) when N > 0 ->
	R = N div 2,
	case (N rem 2) of
		1 -> bits(R, Acc + 1);
		0 -> bits(R, Acc)
	end.
%%%-------------------------------------------------------------------
%% Define a function dup to remove all the duplicate elements from a list.
%% This could remove all repeated elements except the first instance, or all
%% repeated elements except the final instance.
%%%-------------------------------------------------------------------

dup(L) ->
  dup(L, []).
dup([], Acc) ->
  lists:reverse(Acc);
dup([H|T], Acc) ->
  case lists:member(H, Acc) of
    true -> dup(T, Acc);
    false -> dup(T, [H | Acc])
  end.
