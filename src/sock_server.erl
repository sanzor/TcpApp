-module(sock_server).
-behaviour(gen_server).
-export([init/1,handle_info/2,start_link/1,handle_cast/2]).
-record(state,{
       socket
    }).

-define(SERVER,?MODULE).

start_link(Args)->
    {ok,Pid}=gen_server:start_link(?SERVER, Args, []),
    {ok,Pid}.
init(Args)->
    {ok,#state{},0}.


handle_info(timeout,State)->
    Port=application:get_env(port),
    {ok,Socket}=gen_tcp:listen(Port,[binary,{active,false}]),
    {noreply,State#state{socket=Socket}};

handle_info(accept,State=#state{socket=S})->
    worker_sup:start_child(worker_sup,S),
    {noreply,State}.

handle_cast(Message,State)->
    io:format("~s",[Message]),
    {noreply,State}.