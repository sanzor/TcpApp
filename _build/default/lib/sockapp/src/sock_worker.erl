%%%  The worker module that communicates with a given client 
%%%  and responds to all his messages
%%%
-module(sock_worker).
-behaviour(gen_server).
-export([init/1,handle_cast/2,handle_call/3,handle_info/2]).
-export([start_link/2]).
-define(NAME,?MODULE).
-record(state,{
    socket,
    messages=[],
    oob=[]
    }).
%API

start_link(ListenSocket,Count)->
    {ok,Pid}=gen_server:start_link(?NAME,ListenSocket,[]),
    {ok,Pid}.

init(ListenSock)->
    {ok,#state{socket=ListenSock}}.

handle_call(_,_,State)->
    {reply,State,State}.

handle_info(accept,State)->
    try 
        {ok,AcceptSocket}=gen_tcp:accept(State#state.socket),  
        {ok,State#state{socket=AcceptSocket}}
    catch
        Class:Reason:StackTrace -> erlang:raise(Class,Reason,StackTrace)
    end;

handle_info({tcp,_,RawMessage},State)->
    TcpMessage=string:tokens(RawMessage,"\r\n"),
    ExistingMessages=[TcpMessage|State#state.messages],
    Reply=case TcpMessage of
            count -> lists:foldl(fun(_,Y)->Y+1 end,0,State#state.messages);
            messages->State#state.messages;
            _ -> unknown
          end,
    Payload=erlang:term_to_binary(Reply),
    gen_tcp:send(State#state.socket,Payload),
    {noreply,State#state{messages=ExistingMessages}};

handle_info({tcp_closed,_},State)->
    {stop,socket_closed,State};
handle_info(Something,State=#state{oob=Ls})->
    io:fwrite("Unknown info ~p~n",[Something]),
    {noreply,State#state{oob=[Something|Ls]}}.

handle_cast(_,State)->
    {noreply,State}.

