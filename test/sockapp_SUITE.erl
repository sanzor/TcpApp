-module(sockapp_SUITE).
-include_lib("stdlib/include/assert.hrl").
-include_lib("common_test/include/ct.hrl").
-export([all/0,init_per_suite/1,end_per_suite/1,init_per_testcase/2,end_per_testcase/2, can_receive_state/1, can_enter_tcp_clause/1]).


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
        can_enter_tcp_clause
        
    ].

can_receive_state(Config)->
    Port=?config(port, Config),
    [{_,Socket},{_,Pid}]=init_client(Port),
    ?assertMatch({state, Socket,[]}, gen_server:call(Pid,state)).

can_enter_tcp_clause(Config)->
    [{_,Socket},{_,Pid}]=init_client(?config(port,Config)),
    ?assertMatch({state,_,[]}, gen_server:call(Pid,state)),
    ?assertEqual(0,sockapp_SUITE:sendAndReceive(Socket, count)),
    ?assertMatch({state,_,[count]},gen_server:call(Pid,state)),
    ?assertEqual(1,sockapp_SUITE:sendAndReceive(Socket,count)),
    ?assertMatch({state,_,[count,count]}, gen_server:call(Pid,state)),
    ?assertMatch([count,count],sockapp_SUITE:sendAndReceive(Socket,messages)).

sendAndReceive(Socket,Message)->
    TCPMessage=binary_to_term(Message),
    gen_tcp:send(Socket,TCPMessage),
    Output=receive Received->binary_to_term(Received) end,
    Output.

init_client(Port)->
    {ok,Socket}=gen_tcp:connect("localhost", Port, [binary]),
    {ok,Pid}=sock_worker:start_link(Socket,3),
    [{socket,Socket},{pid,Pid}].

