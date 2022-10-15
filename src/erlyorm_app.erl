%%%-------------------------------------------------------------------
%% @doc erlyorm public API
%% @end
%%%-------------------------------------------------------------------

-module(erlyorm_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    erlyorm_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
