%% @author
-module(actors).

-import(string, [substr/3, equal/2]).
-export([main/0]).

main() ->
    X = get_data(),
    server(),
    worker(X).

get_data() ->
    {ok, [X]} = io:fread("\nEnter the number of zeros: ", "~d\n"),
    X.

server() ->
    'Entered Server Code'.

worker(NumberOfZeros) ->

    Random_Generated_String = randomStringGenerator(),
    HashString = run_SHA256(Random_Generated_String),
    % Check if we have the desired number of zeros
    Check = checkStringMatch(NumberOfZeros, HashString),

    % Recursive Loop until we find the right number of leading zeros
    if 
        Check == true ->
            io:fwrite("\n\nYAAASSSSSS :) :)\n\n"),
            io:format("OUTPUT:  ~s\n", [Random_Generated_String]);
        true -> 
            io:fwrite("\n\nOOPSIE, No luck :( \n\n"),
            worker(NumberOfZeros)
    end.

randomStringGenerator() ->
    % generates and prints the random string
    Random_Generated_String = base64:encode(crypto:strong_rand_bytes(6)),
    io:format("The random generated string is: ~s\n", [Random_Generated_String]),

    Random_Generated_String. % return the randomly generated string

run_SHA256(Random_Generated_String) ->

    %passing the above generated string to a SHA256 and printing the generated hash value
    HashString = io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256,Random_Generated_String))]),
    io:fwrite(HashString),  

    HashString. % return Hash String Generated    

checkStringMatch(NumberOfZeros, HashString) ->

    % Check and first 'Number_Of_Zeros' digits of the generated hash function
    PotentialZeros = substr(HashString, 1, NumberOfZeros),
    %io:fwrite(PotentialZeros),

    %% create a target string we desire,
    %% Here TargetString would be "00" if the Number of Zeros was 2.
    TargetString =  lists:flatten(lists:duplicate(NumberOfZeros, "0")),
    %io:fwrite(TargetString),

    %% Check if the hash contains desired leading zeros, string comparision
    Status = equal(PotentialZeros, TargetString), 
    %io:fwrite("~p~n\n",[Status]),
    
    % return result of the string match check
    Status.