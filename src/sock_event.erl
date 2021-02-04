-module(sock_event).
-export([start_link/0]).
-export([add_handler/2,delete_handler/2]).
-define(NAME,?MODULE).

start_link()->
    {ok,Filename}=application:get_env(logfile),
    gen_event:start_link({local,?NAME}, [{log_to_file,Filename}]).

add_handler(Handler,Args)->
    gen_event:add_handler(?NAME, Handler, Args).

delete_handler(Handler,Args)->
    gen_event:delete_handler(?NAME, Handler, Args).

ev(Message)->
    gen_event:notify(?NAME,Message)
rx(Payload)->
    gen_event:notify(?NAME,Payload).
tx(Payload)->
    gen_event:notify(?NAME, Payload).
    
notify(Message)->