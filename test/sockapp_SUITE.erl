-module(sockapp_SUITE).
-include_lib("stdlib/include/assert.hrl").
-include_lib("common_test/include/ct.hrl").
-export([all/0,init_per_suite/1,end_per_suite/1,init_per_testcase/2,end_per_testcase/2]).
 -export([can_receive_state/1, can_receive_message/1,can_change_state/1]).
-export([sendAndReceive/2]).


%%% Utilities
sendAndReceive(Socket,Message)->
    ct:pal("Sending: ~p",[Message]),
    TCPMessage=term_to_binary(Message),
    gen_tcp:send(Socket,TCPMessage),
    receive {tcp,_,Received}->binary_to_term(Received) end.

init_client(Port)->
    {ok,Socket}=gen_tcp:connect("localhost", Port, [binary]),
    {ok,Pid}=sock_worker:start_link(Socket,3),
    [{socket,Socket},{pid,Pid}].

%%% API
init_per_suite(Config)->
    [{port,8300}|Config].

end_per_suite(Config)->
    ok.

init_per_testcase(Case,Config)->
    % application:start(sockapp),
    Config.
end_per_testcase(Case,Config)->
    % application:stop(sockapp),
    ok.


all()->
    [
        can_receive_state,
        can_receive_message,
        % can_count,
        can_change_state
    ].

%%% Tests
can_receive_state(Config)->
    Port=?config(port, Config),
    [{_,Socket},{_,_}]=init_client(Port),
    ?assertMatch({state, _,[]}, sockapp_SUITE:sendAndReceive(Socket, state)).

can_receive_message(Config)->
    [{_,Socket},{_,_}]=init_client(?config(port,Config)),
    ?assertMatch({state, _,[]}, sockapp_SUITE:sendAndReceive(Socket, state)),
    ?assertMatch([],sockapp_SUITE:sendAndReceive(Socket, messages)),
    ?assertMatch([messages],sockapp_SUITE:sendAndReceive(Socket, messages)).


% can_count(Config)->
%     [{_,Socket},{_,_}]=init_client(?config(port,Config)),


can_change_state(Config)->
    [{_,Socket},{_,_}]=init_client(?config(port,Config)),
    ?assertMatch({state,_,[]}, sockapp_SUITE:sendAndReceive(Socket, state)),
    ?assertEqual(0,sockapp_SUITE:sendAndReceive(Socket, count)),
    ?assertMatch({state,_,[count]},sockapp_SUITE:sendAndReceive(Socket, state)),
    ?assertEqual(1,sockapp_SUITE:sendAndReceive(Socket, count)),
    ?assertMatch({state,_,[count,count]},sockapp_SUITE:sendAndReceive(Socket, state)),
    ?assertMatch([count,count],sockapp_SUITE:sendAndReceive(Socket,messages)),
    ?assertMatch({state,_,[messages,count,count]},sockapp_SUITE:sendAndReceive(Socket, state)).


