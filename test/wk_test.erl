-module(wk_test).
-include_lib("eunit/include/eunit.hrl").
-define(PORT,8300).

-ifdef(TEST).
run_worker()->
    {ok,Socket}=gen_tcp:listen(?PORT, []),
    {ok,Pid}=sock_worker:start_link(Socket,3),
    Pid.

cleanup(Socket)->
worker_suite()->
    .

-endif.

empty_state_message_test()->
    Message=state,
    Pid=run_worker(),
    ?_assert({state,[],[],[],[]}=:=gen_server:call(Pid,Message)).

no_socket_tcp_message_test()->
    Message=state,
    Pid=run_worker(),
    ?_assert({state,[],[],[],[]}=:=gen_server:call(Pid,Message)),
    NewMessage=count,
    Pid ! {tcp,ign,NewMessage},
    ?_assertMatch(1,receive Msg->binary_to_term(Msg) end),
    ?_assert({state,[count],[],[],[]}=:=gen_server:call(Pid,Message)).

    
