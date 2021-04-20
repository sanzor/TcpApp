%%% Application module running a tcp server
%%% that will listen on a given port 
-module(sock_app).
-behaviour(application).
-export([start/2,stop/1]).

%api
start(normal,[])->
   {ok,Pid}=main_sup:start_link(),
   {ok,Pid};

start({takeover,_OtherNode},[])->
   {ok,Pid}=main_sup:start_link(),
   Pid.

stop(Reason)->
    ok.






