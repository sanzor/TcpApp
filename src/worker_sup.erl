%%% Worker Supervisor
%%% Supervises the pool of workers , whose number is set from the config
-module(worker_sup).
-behaviour(supervisor).
-export([init/1,start_link/1,start_child/0]).
-define(NAME,?MODULE).
% API
start_link(LSock)->
    {ok,Pid}=supervisor:start_link({local,?NAME},?NAME,[LSock]),
    {ok,Pid}.
  
start_child()->
    supervisor:start_child(?NAME, []).
% Callbacks
init([LSock])->
    Strategy={simple_one_for_one,2,4},
    ChildSpec=[#{
        id => worker,
        start=>{sock_worker,start_link,[LSock]},
        restart=>transient,
        shutdown=>brutal_kill,
        mod=>[sock_worker],
        type=>worker
        }],
    {ok,{Strategy,ChildSpec}}.










