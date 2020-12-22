%%% Main supervisor
-module(t_sup).
-behaviour(supervisor).
-export([init/1,start_link/0]).

-define(NAME,?MODULE).

% API
start_link()->
    supervisor:start_link({local,?NAME},?NAME,[]).

% Callbacks
init([])->
    Strategy={one_for_all,0,1},
    ChildSpec=[#{
        id => t_sup,
        start=>{t_sup,start_link,[]},
        restart=>permanent,
        shutdown=>brutal_kill,
        mod=>[server],
        type=>worker
        }],
    {ok,{Strategy,ChildSpec}}.
