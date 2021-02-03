-module(main_sup).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

-define(NAME,?MODULE).
% API

start_link()->
    {ok,Pid}=supervisor:start_link(?NAME,[]),
    {ok,Pid}.


init(Args)->
    Strategy={one_for_one,0,1},
    ChildSpec=[
            {worker_sup,{worker_sup,start_link,[]},permanent,brutal_kill,supervisor,[worker_sup]},
            {sock_event,{sock_event,start_link,[]},permanent,5000,worker,[sock_event]}
            ],
    {ok,{Strategy,ChildSpec}}.