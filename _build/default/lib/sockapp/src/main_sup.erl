-module(main_sup).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

-define(NAME,?MODULE).
% API

start_link()->
    {ok,Pid}=supervisor:start_link(?NAME,[]),
    {ok,Pid}.


add_file_logger(Path)->
    Config=#{config=>#{file=>Path},level=>info},
    logger:add_handler(myhandler, logger_std_h, Config).

init(Args)->
    Logfile=application:get_env(logfile),
    io:format("Adding logger with path: ~s",[Logfile]),
    add_file_logger(Logfile),
    logger:info("Logger added"),
    Strategy={one_for_one,0,1},
    ChildSpec=[
            {worker_sup,{worker_sup,start_link,[]},permanent,brutal_kill,supervisor,[worker_sup]}
            ],
    {ok,{Strategy,ChildSpec}}.