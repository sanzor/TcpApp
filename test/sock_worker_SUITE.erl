-module(sock_worker_SUITE).
-include_lib("common_test/include/ct.hrl").
-include_lib("stdlib/include/assert.hrl").
-export([all/0,init_per_suite/1,end_per_suite/1,init_per_testcase/2,end_per_testcase/2]).
-export([])


suite()->
    [{port,8300}].
init_per_suite(Config)->
    Config.

end_per_suite(Config)->
    ok.

init_per_testcase(Case,Config)->
    Config.
end_per_testcase(Case,Config)->
    ok.

run_worker(Port)->
    {ok,Socket}=gen_tcp:listen(Port, []),
    {ok,Pid}=sock_worker:start_link(Socket,3),
    [{socket,Socket},{pid,Pid}].


all()->
    [
        can_receive_state,
        can_enter_tcp_clause
    ].

can_receive_state()->
    Message=state,
    Pid=run_worker(),
    ?_assert({state,[],[],[],[]}=:=gen_server:call(Pid,Message)).

can_enter_tcp_clause()->
    Message=state,
    Pid=run_worker(),
    ?_assert({state,[],[],[],[]}=:=gen_server:call(Pid,Message)),
    NewMessage=count,
    Pid ! {tcp,ign,NewMessage},
    ?_assertMatch(1,receive Msg->binary_to_term(Msg) end),
    ?_assert({state,[count],[],[],[]}=:=gen_server:call(Pid,Message)).

    
