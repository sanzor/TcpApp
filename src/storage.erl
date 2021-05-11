-module(storage).
-export([init/0]).
-record(user,{
    id,
    name,
    position
}).

install(Nodes)->
    ok=mnesia:create_schema(Nodes),
    rpc:multicall(Nodes, application, start,[mnesia]),
    application:start(mnesia),
    mnesia:create_table(user,[{attributes,record_info(fields,user)},
                              {index,#user.id}])
    rpc:multicall(Nodes, application, start,[mnesia]).

createUser(Name)->undefined.
updateUser(Id,Position)->undefined.

deleteUser(Id,Position)->undefined.
