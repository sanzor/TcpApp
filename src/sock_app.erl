%%% Application module running a tcp server
%%% that will listen on a given port 
-module(sock_app).
-behaviour(application).
-export([start/2,stop/1]).

%api
start(Mode,Arguments)->
   {ok,Pid}=main_sup:start_link(),
   {ok,Pid}.

stop(Reason)->
    ok.






