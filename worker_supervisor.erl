
-module(worker_supervisor).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-define(SERVER, ?MODULE).


-spec(start_link() -> {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
  supervisor:start_link({global, ?MODULE}, ?MODULE, []).

init([]) ->
  io:format("supervisor started... \n"),
  RestartStrategy = one_for_one,
  MaxRestarts = 3,
  MaxSecondsBetweenRestarts = 5,
  Flags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

  Restart = permanent,

  Shutdown = infinity,

  Type = worker,

  ChildSpecifications = {serverId, {server, start, []}, Restart, Shutdown, Type, [server]},

  {ok, {Flags, [ChildSpecifications]}}.


