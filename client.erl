-module(client).

-import(string, [substr/3, equal/2]).
-export([start/0, startMining/3]).

start() ->
    IPAddress = "localhost",
    PortNumber = 1204,
    % you can pass localhost for now.
    {ok, Sock} = gen_tcp:connect(IPAddress, PortNumber, [binary, {packet, 0}]),
    ok = gen_tcp:send(Sock, "I want work"),
    startWorkers(1, 4, Sock).
    %ok = gen_tcp:close(Sock).

startWorkers(X, N, Sock) ->
    Workers = [  % { {Pid, Ref}, Id }
        { spawn(client, startMining, [X, Id, Sock]), Id }
        || Id <- lists:seq(1, N)
    ],
    Workers.

startMining(X, Id, Sock) ->
    io:format("Worker~w: I'm still alive~n", [Id]),
    % start time
    T1 = erlang:time(),
    io:fwrite("Time of worker ~w -> ~w \n",[Id, T1]),
    worker(X, Sock),
    T2 = erlang:time(),
    io:fwrite("Time 2 of worker ~w -> ~w \n", [Id, T2]),
    X.

worker(NumberOfZeros, Sock) ->
    
    Random_Generated_String = randomStringGenerator(),
    HashString = run_SHA256(Random_Generated_String),
    % Check if we have the desired number of zeros
    Check = checkStringMatch(NumberOfZeros, HashString),

    % Recursive Loop until we find the right number of leading zeros
    if 
        Check == true ->
            Coin_Found = io_lib:format("\nanjaligupta:~s ~s\n", [Random_Generated_String, HashString]),
            
            %STR3 = concat(concat(Random_Generated_String," "), HashString),
            %STR3 = Random_Generated_String ++ " " + HashString,
            gen_tcp:send(Sock, Coin_Found);
        true -> 
            worker(NumberOfZeros, Sock)
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