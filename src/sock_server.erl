-module(sock_server).
-behaviour(gen_server).
-export([init/1,handle_info/2,start_link/1,handle_cast/2,handle_call/3]).
-export([children/1]).
-record(state,{
       socket,
       cmap
    }).

-define(SERVER,?MODULE).


%API 
start_link(Args)->
    {ok,Pid}=gen_server:start_link({local,?SERVER},?MODULE, Args, []),
    {ok,Pid}.


children(Filter) when is_function(Filter)->
    gen_server:call(sock_server,{children,Filter}).

init(_)->
    {ok,#state{cmap=dict:new()},0}.


%% callbacks


handle_info(timeout,State)->
    {ok,Port}=application:get_env(listenPort),
    {ok,Lsock}=gen_tcp:listen(Port,[binary]),
    {ok,Pid}=worker_sup:start_child(Lsock),
    Ref=erlang:monitor(process, Pid),
    {noreply,State#state{socket=Lsock,cmap=dict:store(Ref, Pid, State#state.cmap)}};

handle_info({'DOWN',Ref,process,_,_},State)->
    erlang:demonitor(Ref),
    NewDict=dict:erase(Ref, State#state.cmap),
    {noreply,State#state{cmap=NewDict}}.

handle_cast({new,Pid},State)->
    Ref=erlang:monitor(process,Pid),
    dict:store(Ref, Pid, State#state.cmap),
    {noreply,State};

handle_cast(_, State)->
    {noreply,State}.

handle_call(children,_, State)->
    {reply,State#state.cmap,State};
handle_call({children,Filter},_,State)->
    Reply=dict:filter(Filter, State#state.cmap),
    {reply,Reply,State};
handle_call(_,_,State)->
    {reply,State,State}.

