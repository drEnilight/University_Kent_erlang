%% - Add clear/0 function to flush client's mailbox of unprocessed messages.
%% - Add 4-second timeouts to allocate/0 and deallocate/1 client functions.
%% - Add calls to clear/0 in allocate/0 and deallocate/1 client functions.
%% - Add 7-second waits to allocate and deallocate requests in main loop to
%%   simulate an overloaded server and cause client requests to time out.
%% - Add debugging message to clear/0 to display discarded messages.

-module(frequency).
-export([start/0,allocate/0,deallocate/1,stop/0]).
-export([init/0]).

%% These are the start functions used to create and
%% initialize the server.

start() ->
    register(frequency,
	     spawn(frequency, init, [])).

init() ->
  Frequencies = {get_frequencies(), []},
  loop(Frequencies).

% Hard Coded
get_frequencies() -> [10,11,12,13,14,15].

%% The Main Loop

loop(Frequencies) ->
  receive
    {request, Pid, allocate} ->
      timer:sleep(7000),		% Simulate an overloaded server
					% by withholding reply for 7 seconds.
      {NewFrequencies, Reply} = allocate(Frequencies, Pid),
      Pid ! {reply, Reply},
      loop(NewFrequencies);
    {request, Pid , {deallocate, Freq}} ->
      timer:sleep(7000),		% Simulate an overloaded server
					% by withholding reply for 7 seconds.
      NewFrequencies = deallocate(Frequencies, Freq),
      Pid ! {reply, ok},
      loop(NewFrequencies);
    {request, Pid, stop} ->
      Pid ! {reply, stopped}
  end.

%% Functional interface

allocate() ->
    clear(),				% Flush mailbox of unprocessed messages.
    frequency ! {request, self(), allocate},
    receive
	    {reply, Reply} -> Reply
    after 4000 ->			% Time out if no reply received
        timeout				% after four seconds.
    end.

deallocate(Freq) ->
    clear(),				% Flush mailbox of unprocessed messages.
    frequency ! {request, self(), {deallocate, Freq}},
    receive
	    {reply, Reply} -> Reply
    after 4000 ->			% Time out if no reply received
        timeout				% after four seconds.
    end.

stop() ->
    frequency ! {request, self(), stop},
    receive
	    {reply, Reply} -> Reply
    end.


%% The Internal Help Functions used to allocate and
%% deallocate frequencies.

allocate({[], Allocated}, _Pid) ->
  {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->
  {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}.

deallocate({Free, Allocated}, Freq) ->
  NewAllocated=lists:keydelete(Freq, 1, Allocated),
  {[Freq|Free],  NewAllocated}.

%% Removes all messages currently in the mailbox. After all messages have been
%% removed, returns control to the calling function.

clear() ->
  receive
    _Msg ->
      io:format("Message discarded: ~p~n", [_Msg]),	% Show cleared messages.
      clear()
  after 0 ->
    ok
  end.
