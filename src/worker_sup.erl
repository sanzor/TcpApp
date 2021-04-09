%%% Worker Supervisor
%%% Supervises the pool of workers , whose number is set from the config
-module(worker_sup).
-behaviour(supervisor).
-export([init/1,start_link/0,start_child/1]).
-define(NAME,?MODULE).

%%API
start_link()->
    {ok,Pid}=supervisor:start_link({local,?NAME},?NAME,[]),
    {ok,Pid}.
  
start_child(LSock)->
    supervisor:start_child(?NAME, [LSock]).
% Callbacks
init(Args)->
    Strategy={simple_one_for_one,2,4},
    ChildSpec=[#{
        id => worker,
        start=>{sock_worker,start_link,[]},
        restart=>transient,
        shutdown=>brutal_kill,
        mod=>[sock_worker],
        type=>worker
        }],
    {ok,{Strategy,ChildSpec}}.










