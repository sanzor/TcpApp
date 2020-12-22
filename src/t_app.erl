%%% Application module running a tcp server
%%% that will listen on a given port 
-module(t_app).
-behaviour(application).
-export([start/2,stop/1]).

%api
start(Mode,Arguments)->
    {ok,Pid}=t_sup:start_link(),
    {ok,Pid}.
stop(Reason)->
    ok.






