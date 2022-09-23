%% @author
-module(server).

-import(string, [substr/3, equal/2]).
-export([main/0]).

main() ->
    X = get_data(),
    server(X).

get_data() ->
    {ok, [X]} = io:fread("\nEnter the number of zeros: ", "~d\n"),
    X.

server(X) ->
    io:fwrite("\nEntered Server Code\n"),
    createWorkers(6, X).
    %PID = spawn(clients, main, [X]),
    %io:fwrite(PID).

createWorkers(N, X) ->

    Workers = [  % { {Pid, Ref}, Id }
        { spawn(clients, main, [X, Id]), Id }
        || Id <- lists:seq(1, N)
    ],
    Workers.
    %monitor_workers(Workers).


