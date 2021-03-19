-module(sock_worker_SUITE).
-export([all/0,init_per_suite/1,end_per_suite/1,init_per_testcase/2,end_per_testcase/2,suite/0]).
-export([can_receive_state/1,can_enter_tcp_clause/1,run_worker/1,testr/1]).
-include_lib("stdlib/include/assert.hrl").
-include_lib("common_test/include/ct.hrl").


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

run_worker(Port)->
    {ok,Socket}=gen_tcp:listen(Port, []),
    {ok,Pid}=sock_worker:start_link(Socket,3),
    [{socket,Socket},{pid,Pid}].


all()->
    [
        testr,
        can_receive_state,
        can_enter_tcp_clause
        
    ].

testr(Config)->
    Port=?config(port,Config),
    Port>8200.
can_receive_state(Config)->
    Message=state,
    Pid=sock_worker_SUITE:run_worker(8300),
    ?assert({state,[],[],[],[]}=:=gen_server:call(Pid,Message)),
    exit(Pid).

can_enter_tcp_clause(Config)->
    Message=state,
    Pid=sock_worker_SUITE:run_worker(8300),
    ?assert({state,[],[],[],[]}=:=gen_server:call(Pid,Message)),
    NewMessage=count,
    Pid ! {tcp,ign,NewMessage},
    ?assertMatch(1,receive Msg->binary_to_term(Msg) end),
    ?assert({state,[count],[],[],[]}=:=gen_server:call(Pid,Message)).

    
