%% @author
-module(actors).

% -import(string, [len/1, concat/2, chr/2, substr/3, str/2, to_lower/1, to_upper/1]).
-export([main/0]).

main() ->
    get_data(),
    server(),
    worker(),
    randomStringGenerator_SHA256().

get_data() ->
    {ok, [X]} = io:fread("Enter the number of zeros: ", "~d\n"),
    io:format("The Number User Entered was: ~w\n", [X]).

server() ->
    'Entered Server Code'.

worker() ->
    'Entered Server Code'.

randomStringGenerator_SHA256() ->
    Random_Generated_String = base64:encode(crypto:strong_rand_bytes(6)),

    % generates random string
    io:format("The random generated string is: ~s\n", [Random_Generated_String]),

    %passing the above generated string to a  SHA256
    io_lib:format("Hash Generated: ~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256,Random_Generated_String))]).