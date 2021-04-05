%%%  Main supervisor
%%%  Starts a worker supervisor 
-module(main_sup).
-behaviour(supervisor).
-export([start_link/1]).
-export([init/1]).

-define(NAME,?MODULE).
% API

start_link(LSock)->
    {ok,Pid}=supervisor:start_link(?NAME,[LSock]),
    {ok,Pid}.

init(LSock)->
    Strategy={one_for_one,0,1},
    ChildSpec=[
            {worker_sup,{worker_sup,start_link,[LSock]},permanent,brutal_kill,supervisor,[worker_sup]}
            ],
    {ok,{Strategy,ChildSpec}}.