-module(sockapp_SUITE).
-include_lib("stdlib/include/assert.hrl").
-include_lib("common_test/include/ct.hrl").
-export([all/0,init_per_suite/1,end_per_suite/1,init_per_testcase/2,end_per_testcase/2, can_receive_state/1, can_enter_tcp_clause/1]).

suite()->
    [{port,8300}].
init_per_suite(Config)->
    Config.

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
    Message=state,
    Port=proplists:get_value(port, Config),
    ct:pal("Port is ~p",[Port]),
    CData=init_client(Port),
    
    Pid = proplists:get_value(pid, CData).
    
    % ?assertMatch({state, _Socket,[],[],[]}, gen_server:call(Pid,Message)).

can_enter_tcp_clause(Config)->
    Message=state,
    
    CData=init_client(?config(port,Config)),
    Pid = proplists:get_value(pid, CData),
    ?assertMatch({state,_Socket,[],[],[]}, gen_server:call(Pid,Message)),
    NewMessage=count,
    Pid ! {tcp,ign,NewMessage},
    ?assertMatch({state,_Socket,[count],[],[]}, gen_server:call(Pid,state)).



init_client(Port)->
    {ok,Socket}=gen_tcp:connect("localhost", Port, []),
    {ok,Pid}=sock_worker:start_link(Socket,3),
    [{socket,Socket},{pid,Pid}].

