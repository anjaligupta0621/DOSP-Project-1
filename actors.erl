%% @author
-module(actors).

% -import(string, [len/1, concat/2, chr/2, substr/3, str/2, to_lower/1, to_upper/1]).
-export([main/0]).

main() ->
    get_data(),
    server(),
    worker(),
    sha256().

get_data() ->
    {ok, [X]} = io:fread("input : ", "~d"),
    io:format("Enter the number of zeros: ~w\n", [X]).

server() ->
    'Entered Server Code'.

worker() ->
    'Entered Server Code'.

sha256() ->
    io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256,"teststring"))]).