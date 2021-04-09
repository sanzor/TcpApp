%%%  The worker module that communicates with a given client
%%%  and responds to all his messages
%%%
-module(sock_worker).
-behaviour(gen_server).
-export([init/1,handle_cast/2,handle_call/3,handle_info/2]).
-export([start_link/1]).
-define(NAME,?MODULE).
-record(state,{
    socket,
    messages=[]
    }).
%API
-define(STATE,<<131,100,0,5,115,116,97,116,101>>).
start_link([ListenSocket])->
    {ok,Pid}=gen_server:start_link(?NAME,[ListenSocket],[]),
    {ok,Pid}.

init([ListenSock])->
    
    io:format("Got in init"),
    %gen_server:cast(self(), accept),
    {ok,#state{socket=ListenSock},0}.

handle_call(Message,From,State)->{noreply,State}.

handle_info(timeout,State=#state{socket=LSock})->
    io:format("Got in timeout"),
    {ok,Socket}=gen_tcp:accept(LSock),
    worker_sup:start_child(),
    {noreply,State#state{socket=Socket}};
handle_info({tcp,S,RawMessage},State) when RawMessage=:=?STATE ->
    gen_tcp:send(S, term_to_binary(State)),
    {noreply,State};

handle_info({tcp,S,RawMessage},State)->
    Message=binary_to_term(RawMessage),
    Reply=case Message of
            count -> lists:foldl(fun(_,Y)->Y+1 end,0,State#state.messages);
            messages->State#state.messages;
            _ -> unknown
          end,
    gen_tcp:send(S,erlang:term_to_binary(Reply)),
    {noreply,State#state{messages=[Message|State#state.messages]}};

handle_info({tcp_closed,_},State)->
    {stop,socket_closed,State};
handle_info(Something,_)->
    error("Unknown message ~p",[Something]).


handle_cast(accept,State)->
    {ok,AcceptSocket}=gen_tcp:accept(State#state.socket),
    {noreply,State#state{socket=AcceptSocket}};
handle_cast(_,State)->
    {noreply,State}.

