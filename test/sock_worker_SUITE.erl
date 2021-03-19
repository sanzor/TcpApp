-module(sock_worker_SUITE).
-include_lib("common_test/include/ct.hrl").
-include_lib("stdlib/include/assert.hrl").
-export([all/0,init_per_suite/1,end_per_suite/1,init_per_testcase/2,end_per_testcase/2, can_receive_state/1, can_enter_tcp_clause/1]).

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


all()->
    [
        can_receive_state,
        can_enter_tcp_clause
    ].

can_receive_state(_)->
    Message=state,
    List=run_worker(),
    Pid = proplists:get_value(pid, List),
    ?assertMatch({state, _Socket,[],[],[]}, gen_server:call(Pid,Message)).

can_enter_tcp_clause(_)->
    Message=state,
    List=run_worker(),
    Pid = proplists:get_value(pid, List),
    ?assertMatch({state,_Socket,[],[],[]}, gen_server:call(Pid,Message)),
    NewMessage=count,
    Pid ! {tcp,ign,NewMessage},
    %% ?assertMatch(1,receive Msg->binary_to_term(Msg) end),
    ?assertMatch({state,_Socket,[count],[],[]}, gen_server:call(Pid,state)).


run_worker() ->
    run_worker(8300).

run_worker(Port)->
    {ok,Socket}=gen_tcp:connect("localhost", Port, []),
    {ok,Pid}=sock_worker:start_link(Socket,3),
    [{socket,Socket},{pid,Pid}].

