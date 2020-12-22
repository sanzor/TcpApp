-module(server).
-behaviour(gen_server).
-export([init/1,handle_cast/2,handle_call/3,handle_info/2]).

-define(NAME,?MODULE).
-record(state,{
    socket,
    messages=[]
    }).
%API

start_link(ListenSocket)->
    {ok,Pid}=gen_server:start_link({local,?NAME},?NAME,ListenSocket,[]),
    {ok,Pid}.

init(ListenSock)->
    {ok,#state{socket=ListenSock}}.

handle_call(Message,From,State)->
    {reply,State,State}.

handle_info(accept,State)->
    try 
        {ok,AcceptSocket}=gen_tcp:accept(State#state.socket),
        {ok,NewServer}=server:start_link(State#state.socket),
        case gen_tcp:controlling_process(State#state.socket,NewServer) of
            {error,not_owner}->error("The pid is no longer the owner of the listening socket");
            {error,closed}->error("Listen socket is closed");
            {error,badarg}->error("badarg on controlling process")
        end,
        inet:setopts(State#state.socket,[{active,true}]),
        {ok,State#state{socket=AcceptSocket}}

    catch
        Class:Reason:StackTrace -> erlang:raise(Class,Reason,StackTrace)
    end;
        
handle_info({tcp,Socket,Message},State)->
    Reply=case Message of
            count -> lists:foldl(fun(X,Y)->Y+1 end,0,State#state.messages);
            messages->State#state.messages;
            _ -> unknown
          end,
    Payload=erlang:term_to_binary(Reply),
    gen_tcp:send(State#state.socket,Payload),
    {noreply,State};

handle_info({tcp_closed,Socket},State)->
    {stop,socket_closed}.

handle_cast(Message,State)->
    {noreply,State}.

