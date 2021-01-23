%%% Main supervisor
-module(worker_sup).
-behaviour(supervisor).
-export([init/1,start_link/0]).
-define(NAME,?MODULE).
% API
start_link()->
    {ok,Pid}=supervisor:start_link({local,?NAME},?NAME,[]),
    {ok,Pid}.
  
start_listeners()->
    {ok,Count}=application:get_env(acceptorCount),
    [start_listener(X)|| X<-lists:seq(1,Count)],
    ok.
start_listener(Value)->
    {ok,Pid}=supervisor:start_child(?MODULE,[Value]),
    {ok,Pid}.
% Callbacks
init(Args)->
    {ok,Port}=application:get_env(listenPort),
    {ok,ListenSock}=gen_tcp:listen(Port,[]),
    spawn_link(fun start_listeners/0),
    Strategy={simple_one_for_one,0,1},
    ChildSpec=[#{
        id => worker,
        start=>{sock_worker,start_link,[ListenSock]},
        restart=>transient,
        shutdown=>brutal_kill,
        mod=>[sock_worker],
        type=>worker
        }],
    {ok,{Strategy,ChildSpec}}.

