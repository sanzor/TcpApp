-module(mnapp).
-behaviour(application).


start(Start,Args)->
    file:write("c:\\a.txt", <<"sugi pl">>),
    ok

stop(Stop)