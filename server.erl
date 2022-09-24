%% @author
-module(server).
-import(string, [substr/3, equal/2]).
-export([start/0, server/0, startMining/2]).

start() ->
    N= 4,
    X = get_data(),
    createWorkers(N, X),
    server().

get_data() ->
    {ok, [X]} = io:fread("\nEnter the number of zeros: ", "~d\n"),
    X.

server() ->
    % server starts by listening on a specified port number
    {ok, ListenSocket} = gen_tcp:listen(1204, [binary, {packet, 0}, {active, false}]),
    {ok, Sock} = gen_tcp:accept(ListenSocket), 
    loop(Sock),
    ok = gen_tcp:close(Sock),
    ok = gen_tcp:close(Sock).

loop(Sock) ->
    % server accepts a client connection whenever it gets one
    % receive data sent by client
    inet:setopts(Sock,[{active,once}]),
    receive
        {tcp,S,Data} ->
            %Answer = process(Data), % Not implemented in this example

            Work = "I want work",
            Status = equal(Data, Work),

            if
                Status == true ->
                    io:fwrite("A worker is available for some work\n");
                true ->
                    io:format("~s", [Data])
                    %io:fwrite(Data)
            end,


            %gen_tcp:send(S,Answer),
            loop(S);
        {tcp_closed,S} ->
            io:format("Socket ~w closed [~w]~n",[S,self()]),
            ok
    end.

createWorkers(N, X) ->
    Workers = [  % { {Pid, Ref}, Id }
        {spawn(server, startMining, [X, Id]), Id }
        || Id <- lists:seq(1, N)
    ],
    Workers.

startMining(X, Id) ->
    io:format("Worker~w: I'm still alive~n", [Id]),
    % start time
    T1 = erlang:time(),
    io:fwrite("Time of worker ~w -> ~w \n",[Id, T1]),
    worker(X),
    T2 = erlang:time(),
    io:fwrite("Time 2 of worker ~w -> ~w \n", [Id, T2]),
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