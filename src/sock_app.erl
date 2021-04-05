%%% Application module running a tcp server
%%% that will listen on a given port 
-module(sock_app).
-behaviour(application).
-export([start/2,stop/1]).

%api
start(Mode,Arguments)->
    case openSocket() of
        {ok,Socket}->main_sup:start_link(Socket);
        {error,Reason}->{error,Reason}
    end.

openSocket()->
    {ok,Port}=application:get_env(listenPort),
    {ok,ListenSock}=gen_tcp:listen(Port,[binary]),
    {ok,ListenSock}.
stop(Reason)->
    ok.






