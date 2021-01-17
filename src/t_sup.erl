%%% Main supervisor
-module(t_sup).
-behaviour(supervisor).
-export([init/1,start_link/0]).

-define(NAME,?MODULE).

% API
start_link()->
    case supervisor:start_link({local,?NAME},?NAME,[]) of
        {ok,Pid}->   AcceptorCount=application:get_env(acceptor_count),
                     [supervisor:start_child(t_sup,[X])||X<-lists:seq(0,AcceptorCount)],
                     {ok,Pid};
                   
        {error,Error}->error(Error)
    end.
  


% Callbacks
init([])->
    Strategy={one_for_all,0,1},
    ChildSpec=[#{
        id => t_sup,
        start=>{t_sup,start_link,[]},
        restart=>transient,
        shutdown=>brutal_kill,
        mod=>[server],
        type=>worker
        }],
    {ok,{Strategy,ChildSpec}}.

