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
    Strategy={one_for_all,0,1},
    ChildSpec=#{
            id=>worker_sup,
            start=>{worker_sup,start_link,[]},
            restart=>permanent,
            shutdown=>brutal_kill,
            type=>supervisor,
            mod=>[worker_sup]
        },
    {ok,{Strategy,[ChildSpec]}}.