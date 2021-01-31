-module(sock_event).
-export([start/1]).

-define(NAME,?MODULE).

start()->
    {ok,Filename}=application:get_env(logfile),
    gen_event:start_link({local,?NAME}, [{log_to_file,Filename}]).


notify(Message)->