-module(wt_SUITE).
-include_lib("stdlib/include/assert.hrl").
-export([big/0]).




big()->
    ?assert(2>3).
