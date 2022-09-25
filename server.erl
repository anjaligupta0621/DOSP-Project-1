%% @author
-module(server).
-import(string, [substr/3, equal/2]).
-export([start/0, server/1, startMining/2]).

start() ->
    N= 4,
    X = get_data(),
    createWorkers(N, X),
    server(X).

get_data() ->
    {ok, [X]} = io:fread("\nEnter the number of zeros: ", "~d\n"),
    X.

server(X) ->
    {ok, ListenSocket} = gen_tcp:listen(1204, [binary, {keepalive, true}, {reuseaddr, true}, {active, once}]),
    parallel_connection(ListenSocket, X).

parallel_connection(Listen, X) ->
    {ok, Socket} = gen_tcp:accept(Listen),
    ok = gen_tcp:send(Socket, io_lib:format("~p",[X])),
    spawn(fun() -> parallel_connection(Listen, X) end),
    conn_loop(Socket).

conn_loop(Socket) ->
    receive
	{tcp, Socket, Data} ->
	    inet:setopts(Socket, [{active, once}]),
	    Work = "I want work",
        Status = equal(Data, Work),

        if
            Status == true ->
                io:fwrite("A worker is available for some work\n");
            true ->
                io:format("~s", [Data])
                %io:fwrite(Data)
        end,
	    conn_loop(Socket);
	{tcp_closed, Socket} ->
	    closed
    end.

createWorkers(N, X) ->
    Workers = [  % { {Pid, Ref}, Id }
        {spawn(server, startMining, [X, Id]), Id }
        || Id <- lists:seq(1, N)
    ],
    Workers.

startMining(X, Id) ->
    io:format("Worker~w: I'm alive~n", [Id]),
    % start time
    {H1, M1, S1} = erlang:time(),
    io:fwrite("Worker ~w started... \n",[Id]),
    worker(X),
    {H2, M2, S2} = erlang:time(),
    HourDiff = H2 - H1,
    MinDiff = M2 - M1,
    Diff = S2 - S1,
    if
        Diff < 0 ->
            SecDiff = 60 + Diff;
        true ->
            SecDiff = Diff
    end,
    if
        HourDiff == 0 ->
            if
                MinDiff == 0 ->
                    io:fwrite("Worker ~w took ~w seconds to complete the process \n", [Id, SecDiff]);
                true ->
                    io:fwrite("Worker ~w took ~w minutes and ~w seconds to complete the process \n", [Id, MinDiff, SecDiff])
            end;
        true ->
            io:fwrite("Worker ~w took ~w hours, ~w minutes, and ~w seconds to complete the process \n", [Id, HourDiff, MinDiff, SecDiff])
    end,
    startMining(X, Id),
    X.

worker(NumberOfZeros) ->
    Random_Generated_String = randomStringGenerator(),
    HashString = run_SHA256(Random_Generated_String),
    % Check if we have the desired number of zeros
    Check = checkStringMatch(NumberOfZeros, HashString),

    % Recursive Loop until we find the right number of leading zeros
    if 
        Check == true ->
            io:format("\nanjaligupta:~s ~s\n", [Random_Generated_String, HashString]);
        true -> 
            worker(NumberOfZeros)
    end.

randomStringGenerator() ->
    % generates and prints the random string
    Random_Generated_String = base64:encode(crypto:strong_rand_bytes(6)),
    Random_Generated_String. % return the randomly generated string

run_SHA256(Random_Generated_String) ->

    %passing the above generated string to a SHA256 and printing the generated hash value
    HashString = io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256,Random_Generated_String))]),
    HashString. % return Hash String Generated    

checkStringMatch(NumberOfZeros, HashString) ->

    % Check and first 'Number_Of_Zeros' digits of the generated hash function
    PotentialZeros = substr(HashString, 1, NumberOfZeros),
    %% create a target string we desire,
    TargetString =  lists:flatten(lists:duplicate(NumberOfZeros, "0")),

    %% Check if the hash contains desired leading zeros, string comparision
    Status = equal(PotentialZeros, TargetString), 
    % return result of the string match check
    Status.